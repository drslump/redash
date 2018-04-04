import json
import logging
import numbers
import re
import sqlite3

from collections import namedtuple
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

    QueryRef = namedtuple('QueryRef', 'name id refresh line column')

    def __init__(self):
        self.queries = []

    def table_ref(self, node):
        logger.warn('table_ref: %s', node)
        if not node.children:
            return

        first = node.children[0]
        if not isinstance(first, ReqlParser.Tree) or first.data != 'ident':
            return

        t_name = first.children[0]
        value = t_name.value

        # No transformation step yet so we have a raw AST
        if t_name.type == 'DQUOTED':
            value = value[1:-1].replace('""', '"')

        m = re.match(r'^query_(\d+)(_refresh)?$', value, re.I)
        if m:
            query_id = int(m.group(1))
            self.queries.append(
                QueryResultsVisitor.QueryRef(
                    value,
                    int(m.group(1)),
                    m.group(2) is not None,
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


def _load_query(user, q):
    query = models.Query.maybe_by_id(q.id)
    location = '(at line {} column {})'.format(q.line, q.column)

    if not query or user.org_id != query.org_id:
        raise PermissionError(u"Query id {} not found. {}".format(query_id, location))

    if not has_access(query.data_source.groups, user, not_view_only):
        raise PermissionError(u"You are not allowed to execute queries on {} data source (used for query id {}). {}".format(
            query.data_source.name, query.id, location))

    return query


def create_tables_from_queries(user, conn, queries):
    # Sort first the ones to refresh in case there are some dupes
    queries = sorted(queries, key=lambda x: x.id * (-1 if x.refresh else 1))

    done = set()
    for q in queries:
        if q.name in done:
            continue

        query = _load_query(user, q)

        results = None
        if not q.refresh:
            latest = models.QueryResult.get_latest(query.data_source, query.query_text, max_age=-1)
            results = latest.data if latest else None

        if results is None:
            logger.info('Running query %s to get new results', query.id)
            results, error = query.data_source.query_runner.run_query(
                query.query_text, user)

            if error:
                raise Exception(
                    u"Failed loading results for query id {0} (at line {1} column {2}).".format(
                        query.id, q.line, q.column))

        else:
            logger.debug('Using previous results for query %s', query.id)

        results = json.loads(results)

        create_table(conn, q.name, results)
        done.add(q.name)


def create_table(conn, table, results):
    columns = ', '.join(
        '"{}"'.format(c['name'].replace('"', '""'))
        for c in results['columns'])

    ddl = u'CREATE TABLE {0} ({1})'.format(table, columns)
    logger.debug("DDL: %s", ddl)
    conn.execute(ddl)

    dml = u'INSERT INTO {table} ({columns}) VALUES ({values})'.format(
        table=table,
        columns=columns,
        values=', '.join(['?'] * len(results['columns'])))
    logger.debug('DML: %s', ddl)

    # Note that this method doesn't support generators
    conn.executemany(dml, [
        [ row.get(column['name']) for column in results['columns'] ]
        for row in results['rows']
        ])

    conn.commit()
    logger.info('Inserted %d rows into %s', len(results['rows']), table)


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

    def _create_db(self):
        conn = sqlite3.connect(':memory:', isolation_level=None)

        if self.configuration['memory']:
            # See http://www.sqlite.org/pragma.html#pragma_page_size
            cursor = conn.execute('PRAGMA page_size')
            page_size, = cursor.fetchone()
            cursor.close()

            pages = int(self.configuration['memory']) / page_size
            conn.execute('PRAGMA max_page_count = {0}'.format(pages))
            conn.execute('VACUUM')
            logger.info('Restricted sqlite memory to %s bytes (page_size: %s, pages: %s)',
                        self.configuration['memory'], page_size, pages)

            conn.commit()

        return conn

    def run_query(self, query, user):
        conn = self._create_db()
        try:
            queries = extract_queries(query)
            create_tables_from_queries(user, conn, queries)

            with conn:

                cursor = conn.execute(query)

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
            conn.cancel()
            error = "Query cancelled by user."
            json_data = None
        finally:
            conn.close()

        return json_data, error


register(Results)
