import sys
import os
import codecs
import re

from lark.tools.standalone import main


def build_parser(dialects, dryrun=False):
    dialects = '|'.join(re.escape(x) for x in dialects)
    spaces = lambda m: ' ' * len(m.group(0))

    pth = os.path.dirname(os.path.realpath(__file__))
    with codecs.open(pth + '/sql.g', encoding='utf8') as fd:
        grammar = fd.read()
        grammar = re.sub(r'//\+({0})\b'.format(dialects), spaces, grammar)
        grammar = re.sub(r'(?m)^.*?//\+(?!{0})\b.*?$'.format(dialects), '', grammar)
        grammar = re.sub(r'(?m)^.*?//\-(?={0})\b.*?$'.format(dialects), '', grammar)

    if not dryrun:
        main(grammar, 'start')

    return grammar


if __name__ == '__main__':
    if '-g' in sys.argv:
        grammar = build_parser(sys.argv, dryrun=True)
        print(grammar)
    else:
        build_parser(sys.argv)
