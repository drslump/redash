// SQL syntax for SELECTs (based on sqlite3)
// https://www.sqlite.org/lang_select.html
//
// Basic grammar is modelled from sqlite.
// Support for PostgreSQL is done by tagging productions.
// ReQL extensions should work with both variants.
//
// A line with a //+dialect will be included for that dialect and
// removed for any other. //-dialect allows to remove a production
// when that dialect is choosen.
//

?start                  : stmt (";"+ stmt?)*
                        | ";"*

stmt                    : select_stmt
//+reql                 | reql_set_stmt


compound_expr           : expr ("," expr)*
?expr                   : expr_or

?expr_or                : expr_and ( OR expr_and )*
?expr_and               : expr_not ( AND expr_not )*

?expr_not               : NOT+ expr_weird
                        | expr_weird

?expr_weird             : EXISTS "(" select_stmt ")" -> expr_exists
                        | expr_binary NOT? BETWEEN expr_binary AND expr_binary -> expr_between
                        | expr_binary NOT? IN expr_binary -> expr_in
                        | expr_binary ( IS NULL | NOTNULL | NOT NULL ) -> expr_null
                        | expr_binary NOT? ( LIKE | GLOB | REGEXP ) expr_binary [ ESCAPE expr_binary ] -> expr_search
                        | expr_binary
//+sqlite               | expr_binary NOT? MATCH expr_binary [ ESCAPE expr_binary ] -> expr_search

// TODO: shall we unwrap according to operator priority
?expr_binary            : expr_unary (op_binary expr_unary)*

?expr_unary             : op_unary+ expr_func
                        | expr_unary COLLATE ident -> expr_collate
                        | expr_func
//+pgsql                | expr_func ( "::" CNAME expr_parens? )+  -> expr_pgcast

?expr_func              : CASE expr? ( WHEN expr THEN expr )+ [ ELSE expr ] END -> expr_case
                        | CAST "(" expr AS type_ref ")" -> expr_cast
                        | ident_scoped expr_parens -> expr_call
                        | expr_parens
//+pgsql                | ("bool"i) expr -> expr_call_type

?expr_parens            : "(" [ DISTINCT? expr_arg ("," expr_arg)* | ASTERISK ] ")"
                        | atom

expr_arg                : expr
//+pgsql                | atom order ident*

?atom                   : literal
                        | parameter
                        | ident_scoped
                        | "(" select_stmt ")"  -> subquery
                        | "(" expr ")"


type_ref                : CNAME [ "(" literal_number [ "," literal_number ] ")" ]

op_binary               : "||" | "*" | "/" | "%" | "+" | "-"
                        | "<<" | ">>" | "&" | "|" | "<" | "<="
                        | ">" | ">=" | "=" | "==" | "!=" | "<>"
                        | IS | IS NOT
//+pgsql                | "~" | IS NOT? DISTINCT FROM

op_unary                : "+" | "-" | "~"

parameter               : PARAMETER  // TODO: support extended tcl syntax?
alias                   : ident
                        | ident expr_parens?
//+sqlite               | literal_string


?ident_scoped           : ident ("." ident)* ["." ASTERISK]
?compound_ident         : ident ("," ident)*
?compound_ident_scoped  : ident_scoped ("," ident_scoped)*


?literal                : literal_number
                        | literal_string
                        | NULL
//+sqlite               | /x'([0-9A-Fa-f]+)'/  -> literal_blob
//+sqlite               | CURRENT_TIME
//+sqlite               | CURRENT_DATE
//+sqlite               | CURRENT_TIMESTAMP

literal_string          : SQUOTED
literal_number          : NUMERIC

?table_or_subquery      : table_ref [ INDEXED BY ident | NOT INDEXED ]
                        | "(" select_stmt ")" [ AS? alias ] -> subquery
                        | "(" join ")"

table_ref               : ident_scoped [ AS? alias ]
                        | ident_scoped "(" compound_expr? ")" [ AS? alias ]
//+reql                 | reql_expr

cte                     : alias [ "(" compound_ident ")" ] AS "(" select_stmt ")"
//+reql                 | alias [ "(" compound_ident ")" ] AS reql_expr             -> reql_cte
//+reql                 | alias [ "(" compound_ident ")" ] AS "(" reql_expr ")"     -> reql_cte

?join                   : table_or_subquery ( op_join table_or_subquery join_constraint? )*

join_constraint         : ON expr
                        | USING "(" compound_ident ")"

op_join                 : ","
                        | NATURAL? [ LEFT OUTER? | INNER | CROSS ] JOIN
//+pgsql                | "," LATERAL

column                  : ASTERISK
                        | expr [ AS? ident ]
//+sqlite               | expr [ AS? (ident | literal_string) ]
//+pgsql                | expr [ WITHIN GROUP "(" order ")" ] [ FILTER "(" where ")" ] [ AS? ident ]

?select_core            : values
                        | select
//+pgsql                | TABLE ident

values                  : VALUES ( expr_parens ("," expr_parens)* )

select                  : SELECT select_mod? column ("," column)* from? where? group? having? order?

select_mod              : DISTINCT | ALL
//+pgsql                | DISTINCT ON expr_parens

from                    : FROM join
where                   : WHERE expr
group                   : GROUP BY compound_expr
having                  : HAVING expr

?compound_select        : select_core ( op_compound select_core )*
op_compound             : UNION ALL?
                        | INTERSECT
                        | EXCEPT

with                    : WITH RECURSIVE? cte ("," cte)*

order                   : ORDER BY ordering_term ("," ordering_term)*
ordering_term           : expr [ ASC | DESC ]
//+pgsql                | expr [ ASC | DESC ] ["NULLS"i ("FIRST"i | "LAST"i)] [USING ("<"|">")]

limit                   : LIMIT expr [ ("OFFSET"i|",") expr ]

select_stmt             : with? compound_select order? limit?

ident                   : CNAME | DQUOTED
//+sqlite               | /\[([^\]].+?)\]/     //-reql


//
// ReQL constructs
//
/////////////////////////////////////////////////////////

//+reql reql_expr       : CNAME reql_params reql_mapper*
//+reql reql_params     : "[" [ reql_param (","? reql_param)* ] "]" | reql_block
//+reql ?reql_param     : reql_pair | ident | literal | parameter
//+reql reql_pair       : CNAME ":" (ident | literal | parameter | reql_block)
//+reql reql_block      : /\[:([\s\S]*?):\]/   -> reql_block
//+reql                 | /\[=([\s\S]*?)=\]/   -> reql_block_verbatim
//+reql                 | /\[<([\s\S]*?)>\]/   -> reql_block_folded
//+reql reql_mapper     : "::" CNAME reql_params?

//+reql reql_set_stmt   : "SET"i CNAME "=" (literal | CNAME)


%import common.CNAME
%import common.NEWLINE
%ignore NEWLINE
%import common.WS
%ignore WS

COMMENT                 : "--" /[^\n]+?/? NEWLINE
                        | "/*" /(.|\n)*?/ "*/"
%ignore COMMENT

PARAMETER               : ("$" | ":") CNAME

SQUOTED                 : "'" ( "''" | NEWLINE | /[^']+/ )* "'"
DQUOTED                 : "\"" ( "\"\"" | /[^"]+/ )* "\""

NUMERIC                 : ( DIGIT+ [ "." DIGIT+ ] | "." DIGIT+ ) [ ("e"|"E") [ "+"|"-" ] DIGIT+ ]
                        | ("0x"|"0X") HEXDIGIT+
DIGIT                   : "0".."9"
HEXDIGIT                : "0".."9" | "A".."F" | "a".."f"

ALL                     : "ALL"i
AND                     : "AND"i
AS                      : "AS"i
ASC                     : "ASC"i
ASTERISK                : "*"
BETWEEN                 : "BETWEEN"i
BY                      : "BY"i
CASE                    : "CASE"i
CAST                    : "CAST"i
COLLATE                 : "COLLATE"i
CROSS                   : "CROSS"i
//+sqlite CURRENT_DATE        : "CURRENT_DATE"i
//+sqlite CURRENT_TIME        : "CURRENT_TIME"i
//+sqlite CURRENT_TIMESTAMP   : "CURRENT_TIMESTAMP"i
DESC                    : "DESC"i
DISTINCT                : "DISTINCT"i
ELSE                    : "ELSE"i
END                     : "END"i
ESCAPE                  : "ESCAPE"i
EXCEPT                  : "EXCEPT"i
EXISTS                  : "EXISTS"i
//+pgsql FILTER         : "FILTER"i
FROM                    : "FROM"i
GLOB                    : "GLOB"i
GROUP                   : "GROUP"i
HAVING                  : "HAVING"i
IGNORE                  : "IGNORE"i
IN                      : "IN"i
INDEXED                 : "INDEXED"i
INNER                   : "INNER"i
INTERSECT               : "INTERSECT"i
IS                      : "IS"i
ISNULL                  : "ISNULL"i
JOIN                    : "JOIN"i
//+pgsql LATERAL        : "LATERAL"i
LEFT                    : "LEFT"i
LIKE                    : "LIKE"i
LIMIT                   : "LIMIT"i
//+sqlite MATCH         : "MATCH"i
NATURAL                 : "NATURAL"i
NOT                     : "NOT"i
NOTNULL                 : "NOTNULL"i
NULL                    : "NULL"i
ON                      : "ON"i
OR                      : "OR"i
ORDER                   : "ORDER"i
OUTER                   : "OUTER"i
RECURSIVE               : "RECURSIVE"i
REGEXP                  : "REGEXP"i
SELECT                  : "SELECT"i
//+pgsql TABLE          : "TABLE"i
THEN                    : "THEN"i
UNION                   : "UNION"i
USING                   : "USING"i
VALUES                  : "VALUES"i
WHEN                    : "WHEN"i
WHERE                   : "WHERE"i
WITH                    : "WITH"i
//+pgsql WITHIN         : "WITHIN"i


