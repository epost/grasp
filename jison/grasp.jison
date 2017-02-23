%lex
%%

\s+                  // skip whitespace
// TODO remove
";"                   return "SEMI"

/* [ ]+                  // skip whitespace */
/* [\n]+                 return "EOLS" */


/* [A-Za-z0-9_]+\b       return "STR" */
/* [A-Za-z0-9_-]+\b      return "STR" */
[A-Za-z0-9_.]+\b      return "STR"
[0-9]+("."[0-9]+)?\b  return "NUM"
","                   return "COMMA"
"->"                  return "->"
"-"                   return "-"


<<EOF>>               return "EOF"
.                     return "INVALID"

/lex

%start graph

%%

graph:
      edges SEMI? EOF
      { console.log(JSON.stringify($1, null, 2)); return $1 }
    ;

nodes:
    nodes COMMA node
    { $$ = $nodes; $$.unshift($node) }
  | node
    { $$ = [$node] }
  ;

node:
  /* : NUM */
  /*   { $$ = Number($1) } */
    STR
    { $$ = $STR }
  ;

edges:
    edges SEMI edge
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
