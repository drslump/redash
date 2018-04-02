import os
import sys
import codecs
import re

import pytest


PATH = os.path.dirname(os.path.realpath(__file__))

# HACK: Relative imports until everything is properly integrated
sys.path = [ PATH + '/..' ] + sys.path
from parser import ReqlParser
from build_parser import build_parser
sys.path.pop(0)


def get_test_parser(dialects):
    ftest = os.path.join(PATH, 'parser_gen_test_{0}.py'.format('_'.join(dialects)))
    try:
        with codecs.open(ftest, 'w', encoding='utf8') as fd:
            stdout = sys.stdout
            sys.stdout = fd
            try:
                build_parser(dialects)
            finally:
                sys.stdout = stdout

            import imp
            module = imp.load_source('parser_gen', ftest)
    finally:
        os.unlink(ftest)
        pass

    return ReqlParser(module=module)


def load_fixtures(fname, skip=()):
    skip_re = r'@skip ({0})'.format('|'.join(re.escape(x) for x in skip))
    accum = []
    line_cnt = 0
    for line in open(os.path.join(PATH, fname)):
        line = line.rstrip()
        line_cnt += 1
        accum.append(line)

        # HACK: the grammar breaks with empty queries `-- ... ;`
        if line.endswith(';') and not line.startswith('--'):
            query = '\n'.join(accum)

            if not re.search(skip_re, query, re.I):
                yield ('{0}:{1}'.format(fname, line_cnt), query)

            accum = []

