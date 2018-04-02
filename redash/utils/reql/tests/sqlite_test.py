import os
import sys

import pytest

from conftest import load_fixtures, get_test_parser


@pytest.fixture(scope='module')
def parser():
    return get_test_parser(['sqlite'])


@pytest.mark.parametrize('location, sql', load_fixtures('fixtures.sqlite'))
def test_sqlite(location, sql, parser):
    assert parser.parse(sql)
