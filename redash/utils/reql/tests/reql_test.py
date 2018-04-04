import os
import sys

import pytest

from conftest import load_fixtures, get_test_parser


@pytest.fixture(scope='module')
def parser_sqlite_reql():
    return get_test_parser(['sqlite', 'reql'])

@pytest.fixture(scope='module')
def parser_pgql_reql():
    return get_test_parser(['pgsql', 'reql'])


def test_lark_user_aliases_state_bug():
    from parser import ReqlParser

    query = 'SELECT * FROM query_2'

    parser = ReqlParser()
    ast1 = parser.parse(query)

    parser = ReqlParser()
    ast2 = parser.parse(query)

    assert ast1.data == ast2.data


@pytest.mark.parametrize('location, sql', load_fixtures('fixtures.reql'))
def test_reql(location, sql, parser_sqlite_reql):
    assert parser_sqlite_reql.parse(sql)

# Let's make sure we don't break sqlite
@pytest.mark.parametrize('location, sql', load_fixtures('fixtures.sqlite', skip=['reql']))
def test_sqlite_reql(location, sql, parser_sqlite_reql):
    assert parser_sqlite_reql.parse(sql)

# Let's make sure we don't break postgresql
@pytest.mark.parametrize('location, sql', load_fixtures('fixtures.pgsql', skip=['reql']))
def test_pgsql_reql(location, sql, parser_pgql_reql):
    assert parser_pgql_reql.parse(sql)

