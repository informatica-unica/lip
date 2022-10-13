# Boolean expressions with propositional variables

Extend the language of boolean expressions with variables and declarations.
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

## Big-step semantics

The big-step semantics of programs now takes as input a pair `(d,e)`, where `d` is a declaration and `e` is a boolean expression.
In order to define the `eval` function, you will need to define a function to evaluate a declaration, and use this 
to give semantics to the case `Var`.

For instance, a possible implementation of the `eval` function could have the following form:
```ocaml
let rec eval (d,e) = match e with
    True -> true
  | False -> false
  | Var(x) -> (match apply x d with
      Some b -> b
    | None -> raise UnboundVar)
  ...
```

## Static semantics

Unlike thep previous exercises, this language contain syntactically correct programs, which do not have a semantics.
This happens when the boolean expression contains some variables which are not defined in the declarations.
For instance:
```
let x = true ; y = false in x and z
```

Define a function to statically detect when the evaluation of a program will not fail.
