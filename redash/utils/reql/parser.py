# HACK: Temporary local import precedence while developing
try:
    import _parser
except ImportError:
    from redash.utils.reql import _parser


class ReqlParser(object):

    Visitor = _parser.Visitor
    Tree = _parser.Tree
    Token = _parser.Token

    def __init__(self, transformer=None, postlex=None, module=_parser):
        # Override the utility classes based on the parsing module
        self.Visitor = module.Visitor
        self.Tree = module.Tree
        self.Token = module.Token

        self.lark = module.Lark_StandAlone(transformer=transformer, postlex=None)

    def parse(self, code, transformer=None):
        tree = self.lark.parse(code)
        if transformer:
            transformer.transform(tree)
        return tree
