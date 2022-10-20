# Boolean expressions with global declarations

Extend the language of boolean expressions with variables and global declarations, according to the following [AST](src/ast.ml):
```ocaml
type boolExpr =
    True
  | False
  | Not of boolExpr
  | And of boolExpr * boolExpr
  | Or of boolExpr * boolExpr
  | If of boolExpr * boolExpr * boolExpr
  | Var of string

type boolDecl = (string * boolExpr) list

type boolProg = boolDecl * boolExpr
```

Expressions can now contain propositional variables, e.g.:
```
x and y
```
is a disjunction between the propositional variables x and y.

A **declaration** is a sequence of bindings of variables to boolean values. 
For instance, the declaration:
```
x = true ; y = false
```
binds the identifier x to true, and y to false.

A **program** is either a boolean expression, or a declaration followed by a boolean expression, e.g.:
```
let x = true ; y = false in x and y
```

In this exercise you must extend the lexer, the parser and the big-step semantics.
We give some hints below.

## Lexer

To extend the lexer, you can define identifiers as non-empty sequences of letters, as follows:
```ocaml
let letter = ['a'-'z' 'A'-'Z']
let id = letter+

rule read =
  parse
  ...
  | id { ID (Lexing.lexeme lexbuf) }
  ...
```

## Parser

To extend the parser, you must add new tokens. In particular, the token for identifiers now must carry a string:
```ocaml
%token <string> ID
```
This token will be used in the rule to parse an identifier within an expression:
```ocaml
expr:
  | x = ID { Var x }
  ...
```


## Static checks

This language allows one to write syntactically-correct programs which have an undefined semantics.
This happens when the expression within a program contains some variables which are not defined in the declarations.
For instance:
```
let x = true ; y = false in x and z     (* the variable z is used but not declared *)
```
We want to rule out these troublesome programs before they are executed, i.e. at **static time**.

We also consider incorrect a program whose declaration binds the same variable multiple times, or use expressions with variables in declarations:
```
let x = true ; x = false in x           (* the variable x is declared multiple times *)
let x = true ; y = not x in x and y     (* the expression "not x" in declaration contains a variable *)
```

Write a function with type:
```ocaml
typecheck: boolProg -> bool
```
that statically detects when a program is well-typed.
It is required that the evaluation of well-typed programs never fails.


## Big-step semantics

The big-step semantics of programs now takes as input a program `(d,e)`, where `d` is a declaration and `e` is a boolean expression.
In order to define the `eval` function, you will need to define a function to evaluate a declaration, and use this 
to give semantics to the case `Var`. There are various ways to do this: my suggestion is to write a function which transforms a declaration into a function rho mapping variables to boolean values (a so-called **environment**).
In this way, the rule to evaluate variable will take the form:
```
---------------- [B-Var]
Var x => rho x
```

In order to transform a declaration (represented as a list of pairs) into a function, I suggest to write a recursive function 
```ocaml
env_of_decl : boolDecl -> string -> bool
```
with the following behaviour:
- in the base case (empty declaration), it outputs the always-undefined function;
- in the inductive case (x,e)::d, it computes the environment from d, and extends it with the binding x -> b, where b is the evaluation of e.
