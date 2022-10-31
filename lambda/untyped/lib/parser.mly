%{
open Ast
%}

%token <string> VAR
%token ABS
%token DOT
%token LPAREN
%token RPAREN
%token EOF

%start <term> prog

%nonassoc DOT ABS
%nonassoc LPAREN VAR 
%left APP

%%

prog:
  | t = term; EOF { t }
;

term:
  | x = VAR { Var x }
  | ABS; x = VAR; DOT; t = term { Abs(x,t) }
  | LPAREN; t=term; RPAREN { t }
  | t1=term; t2=term { App(t1,t2) } %prec APP
;
