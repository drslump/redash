import json
import logging
import numbers
import re
import sqlite3

from dateutil import parser

from redash import models
from redash.permissions import has_access, not_view_only
from redash.query_runner import (TYPE_BOOLEAN, TYPE_DATETIME, TYPE_FLOAT,
                                 TYPE_INTEGER, TYPE_STRING, BaseQueryRunner,
                                 register)
from redash.utils import JSONEncoder

from redash.utils.reql import ReqlParser


logger = logging.getLogger(__name__)


class QueryResultsVisitor(ReqlParser.Visitor):
    """ Search among the table refrences in the query to find those
        that match the `query_\d+` pattern.
    """

    QueryRef = namedtuple('QueryRef', 'name id line column')

    def __init__(self):
        self.queries = []

    def table_ref(self, node):
        if not node.children:
            return

        first = node.children[0]
        if not isinstance(first, Tree) or first.data != 'ident':
            return

        t_name = first.children[0]
        value = t_name.value

        # No transformation step yet so we have a raw AST
        if t_name.type == 'DQUOTED':
            value = value[1:-1].replace('""', '"')

        m = re.match(r'^query_(\d+)$', value, re.I)
        if m:
            self.queries.append(
                QueryResultsVisitor.QueryRef(
                    value,
                    int(m.group(1)),
                    t_name.line,
                    t_name.column))


class PermissionError(Exception):
    pass


def _guess_type(value):
    if value == '' or value is None:
        return TYPE_STRING

    if isinstance(value, numbers.Integral):
        return TYPE_INTEGER

    if isinstance(value, float):
        return TYPE_FLOAT

    if unicode(value).lower() in ('true', 'false'):
        return TYPE_BOOLEAN

    try:
        parser.parse(value)
        return TYPE_DATETIME
    except (ValueError, OverflowError):
        pass

    return TYPE_STRING


def extract_queries(query):
    parser = ReqlParser()
    ast = parser.parse(query)

    visitor = QueryResultsVisitor()
    visitor.visit(ast)

    return visitor.queries


def _load_query(user, query_id):
    query = models.Query.get_by_id(query_id)

    if user.org_id != query.org_id:
        raise PermissionError("Query id {} not found.".format(query.id))

    if not has_access(query.data_source.groups, user, not_view_only):
        raise PermissionError(u"You are not allowed to execute queries on {} data source (used for query id {}).".format(
            query.data_source.name, query.id))

    return query


def create_tables_from_queries(user, connection, queries):
    query_ids = set(x.id for x in queries)
    for query_id in query_ids:
        query = _load_query(user, query_id)

        results, error = query.data_source.query_runner.run_query(
            query.query_text, user)

        if error:
            locations = [
                'Line {0} Column {1}'.format(x.line, x.column)
                for x in queries
                if x.id == query_id]

            raise Exception(
                "Failed loading results for query id {0} (at {1}).".format(
                    query.id, ', '.join(locations)))

        results = json.loads(results)
        table_name = 'query_{query_id}'.format(query_id=query_id)
        create_table(connection, table_name, results)


def fix_column_name(name):
    return name.replace(':', '_').replace('.', '_').replace(' ', '_')


def create_table(connection, table_name, query_results):
    columns = [column['name']
               for column in query_results['columns']]
    safe_columns = [fix_column_name(column) for column in columns]

    column_list = ", ".join(safe_columns)
    create_table = u"CREATE TABLE {table_name} ({column_list})".format(
        table_name=table_name, column_list=column_list)
    logger.debug("CREATE TABLE query: %s", create_table)
    connection.execute(create_table)

    insert_template = u"insert into {table_name} ({column_list}) values ({place_holders})".format(
        table_name=table_name,
        column_list=column_list,
        place_holders=','.join(['?'] * len(columns)))

    for row in query_results['rows']:
        values = [row.get(column) for column in columns]
        connection.execute(insert_template, values)


class Results(BaseQueryRunner):
    noop_query = 'SELECT 1'

    @classmethod
    def configuration_schema(cls):
        return {
            "type": "object",
            "properties": {
                'memory': {
                    'type': 'string',
                    'title': 'Memory limit (in bytes)'
                },
            }
        }

    @classmethod
    def annotate_query(cls):
        return False

    @classmethod
    def name(cls):
        return "Query Results (Beta)"

    def run_query(self, query, user):
        connection = sqlite3.connect(':memory:')

        if self.configuration['memory']:
            # See http://www.sqlite.org/pragma.html#pragma_page_size
            cursor = connection.execute('PRAGMA schema.page_size')
            page_size, = cursor.fetchone()
            cursor.close()

            pages = int(self.configuration['memory']) / page_size
            connection.execute('PRAGMA max_page_count = {0}'.format(pages))
            connection.execute('VACUUM')

        queries = extract_queries(query)
        create_tables_from_queries(user, connection, queries)

        cursor = connection.cursor()
        try:
            cursor.execute(query)

            if cursor.description is not None:
                columns = self.fetch_columns(
                    [(i[0], None) for i in cursor.description])

                rows = []
                column_names = [c['name'] for c in columns]

                for i, row in enumerate(cursor):
                    for j, col in enumerate(row):
                        guess = _guess_type(col)

                        if columns[j]['type'] is None:
                            columns[j]['type'] = guess
                        elif columns[j]['type'] != guess:
                            columns[j]['type'] = TYPE_STRING

                    rows.append(dict(zip(column_names, row)))

                data = {'columns': columns, 'rows': rows}
                error = None
                json_data = json.dumps(data, cls=JSONEncoder)
            else:
                error = 'Query completed but it returned no data.'
                json_data = None
        except KeyboardInterrupt:
            connection.cancel()
            error = "Query cancelled by user."
            json_data = None
        finally:
            connection.close()
        return json_data, error


register(Results)
