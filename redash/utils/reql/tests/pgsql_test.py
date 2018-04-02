import os
import sys

import pytest

from conftest import load_fixtures, get_test_parser


@pytest.fixture(scope='module')
def parser():
    return get_test_parser(['pgsql'])


@pytest.mark.parametrize('location, sql', load_fixtures('fixtures.pgsql'))
def test_pgsql(location, sql, parser):
    assert parser.parse(sql)
