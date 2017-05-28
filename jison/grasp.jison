%lex
%%

[^\S\n]+                                  // skip whitespace except newlines
"#".*[\n]+                                // skip line comments

(\n|";")+             return "EDGESEP"

/* [A-Za-z0-9_]+\b       return "IDENT" */
/* [A-Za-z0-9_-]+\b      return "IDENT" */
[A-Za-z0-9_.]+\b      return "IDENT"
[0-9]+("."[0-9]+)?\b  return "NUM"
","                   return "COMMA"
"->"                  return "->"
"-"                   return "-"
":"                   return "COLON"


<<EOF>>               return "EOF"
.                     return "INVALID"

/lex

%start graph

%%

graph:
      edges EDGESEP* EOF
      { console.log(JSON.stringify($1, null, 2)); return $1 }
    ;

nodes:
    nodes COMMA node
    { $$ = $nodes; $$.unshift($node) }
  | node
    { $$ = [$node] }
  ;

// TODO allow anonymous typed term, e.g. ":A"?
node:
    IDENT COLON IDENT
    { $$ = { id: $IDENT, type: $3 } }
  |
    IDENT
    { $$ = { id: $IDENT } }
  ;

edges:
    edges EDGESEP+ edge
    { $$ = $edges; $$.unshift($edge) }
  | edge
    { $$ = [$edge] }
  ;

edge:
    nodes '-' label '->' nodes
    { $$ = { s: $1, t: $5, label: $3 } }
  | nodes '->' nodes
    { $$ = { s: $1, t: $3, label: null } }
  ;

// TODO arrow label should not be a node
label:
    node
    { $$ }
  ;
