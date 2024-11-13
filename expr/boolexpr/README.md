# A minimal language for boolean expressions

This is a step-by-step guide to create an interpreter for a small language of boolean expressions, with the following [abstract syntax](lib/ast.ml):
```ocaml
type boolExpr =
    True
  | False
  | If of boolExpr * boolExpr * boolExpr
;;
```

To make it more interesting for you, the provided files contain bugs and missing definitions that you need to fix in order to make the project fully work. Solve the tasks in order as you read on.

## Project setup

To start, create a new project named `boolexpr` by launching the following command from the `expr` directory:
```bash
dune init proj boolexpr
```
To instruct dune that our project will use Menhir, add the following line at the end of the file `dune-project`:
```bash
(using menhir 2.1)
```
Now, create a directory `lib` under `boolexpr`:
```bash
mkdir lib
```
At the end of this tutorial, the `boolexpr/lib` directory will have the following structure:
```
lib/
├── ast.ml         # Abstract syntax tree
├── dune           # Dune library definition
├── lexer.mll      # Ocamllex lexer definition
├── main.ml        # Language semantics and utility functions
├── parser.mly     # Menhir parser definition
```
We will discuss these files in the following sections. You can find them in the [lib folder](lib) of this repository.


## Parser

The file [parser.mly](lib/parser.mly) contains the grammar definition of our language.
Menhir will process this file and produce the actual parser in OCaml 
(this will be located in `_build/default/lib/parser.ml`).

The  grammar definition is split into four sections: header, declarations, rules, and trailer (the last one is not needed in our language).
We discuss below these sections.

### Header

The header, which is included between `%{` and `%}`, contains code that will be copied verbatim into the generated parser. 
Here we just open the `Ast` module, in order to avoid pre-pending `Ast` to each `boolExpr` expressions
(for instance, we can write `True` instead of `Ast.True`).

```ocaml
%{
open Ast
%}
```

### Declarations

The declarations define the lexical tokens of our language:
```ocaml
%token TRUE
%token FALSE
%token LPAREN
%token RPAREN
%token IF
%token THEN
%token ELSE
%token EOF

%start <boolExpr> prog
%%
```
Note that these tokens are just names, and they are not yet linked to their concrete string representations.
For instance, there is nothing that says that `LPAREN` and `RPAREN` correspond, respectively, to ( and ).
The lexer will associate token names to their string representations.

The last declaration:
```ocaml
%start <boolExpr> prog
```
says that parsing starts with rule named `prog` (defined below), and that the result of the parsing will be an OCaml value of type `Ast.boolExpr`.

### Rules 

The rules section defines the productions of the grammar.
The start symbol is `prog`, which has the following production:
```ocaml
prog:
  | e = expr; EOF { e }
;
```
This says that a `prog` is an `expr` followed by the token `EOF` (which stands for "end of file"). 
The part `e = expr` binds the value obtained by parsing `expr` to the identifier `e`. 
The final part `{ e }` means that the production returns the value associated to `e`.

The rule `expr` defines four productions:
```ocaml
expr:
  | TRUE { True }
  | FALSE { False }
  | IF; e1 = expr; THEN; e2 = expr; ELSE; e3 = expr; { If(e1, e2, e3) }
  | LPAREN; e=expr; RPAREN {e}
;
```
The first two productions associate the tokens `TRUE` and `FALSE` to the values `True` and `False` of our type `boolExpr`.
The third production parses the IF-THEN-ELSE construct.
The last production parses an expression surrounded by parentheses.


## Task 1: Fix the parser bug

There is a bug in the parser rules of the file [parser.mly](lib/parser.mly). But luckily Menhir is able to detect and report it when we build the project. To see where the bug is, run the following command from the `boolexpr` directory:

```
dune build
```

Can you understand the error message and fix the bug?

---

## Lexer

The file [lexer.mll](lib/lexer.mll) contains the code needed to generate the lexer.
Ocamllex will process this file and produce the actual lexer in OCaml (this will be located in `_build/default/lib/lexer.ml`).

The lexer definition is split into four sections: header, identifiers, rules, and trailer (the last section is not needed for our language).

### Header

In the header we open the `Parser` module, in order to use the token definitions in that module without pre-pending `Parser`:
```ocaml
{
open Parser
}
```

### Identifiers

This section defines named regular expressions, to be used later in the rules section.
Here, we define an indentifier `white`, to denote sequences of one or more whitespaces (spaces and tabs):
```ocaml
let white = [' ' '\t']+
```

### Rules

This section defines rules that associate tokens to their string representations.
The lexer tries to match regular expressions in the order they are listed (similarly to the `match` construct).
When it finds a match, it outputs the token specified in the curly brackets.
Our lexer is defined as follows (the terms `rule`, `read`, `parse` and `eof` are keywords):
```ocaml
rule read =
  parse
  | white { read lexbuf }  
  | "true" { TRUE }
  | "false" { FALSE }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | eof { EOF }
```
Most of the lines are straightforward. 
The first line means that if the regular expression names `white` is matched, the lexer should just skip it, without producing a token.
The last line matches the `eof` regular expression, i.e. the end of the file or string being lexed. 

## Generating the library

In order to use the lexer and parser from OCaml, we write in [main.ml](lib/main.ml) a small driver function to translate a string into an AST:
```ocaml
open Ast

let parse (s : string) : boolExpr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast
```
This function first transforms the string in input into a stream of tokens. 
Then, is applies the lexer and the parser to transform this stream into an AST.

At this point we can wrap the driver, lexer and parser into a library named `boolexprLib`.
This is specified in the [dune](lib/dune) file in `lib`:
```ocaml
(library
 (name boolexprLib))

(menhir
 (modules parser))

(ocamllex lexer)
```
We can now build the project, by launching the following command from the `boolexpr` directory:
```bash
dune build
```
If everything is correct, `dune build` runs silently without errors.


## Testing the parser

We can test the parser within the utop REPL, which can be accessed through the command:
```bash
dune utop lib
```
From utop, we can execute OCaml code. First, it is useful to open our library, so to avoid to prepend `BoolexprLib.Main` everytime we use a function:
```ocaml
open BoolexprLib.Main;;
open BoolexprLib.Ast;;
```
We can now test the parser by applying the `parse` function:
```ocaml
parse "true";;
- : boolExpr = True

parse "if true then false else true";;
- : boolExpr =
If (True, False, True)
```
Note that the parser will fail to parse strings which do not correspond to syntactically correct boolean expressions.
In these cases, the parser will raise an exception, without providing details about what caused the error:
```ocaml
parse "if true then false";;
Exception: BoolexprLib.Parser.MenhirBasics.Error.
```

## Big-step semantics

We now implement the big-step semantics of our language, defined by the following rules (where b is a boolean value):
```ocaml
------------------- [B-True]
True => true

------------------- [B-False]
False => false

e0 => true   e1 => b
---------------------------- [B-IfTrue]
If(e0,e1,e2) => b

e0 => false  e2 => b
---------------------------- [B-IfFalse]
If(e0,e1,e2) => b
```

This semantic is implemented as a recursive function `eval` that evaluates the expression `True` to the boolean value `true`,
`False` to `false`, and call itself recursively to evaluate if-then-else expressions.

## Task 2: Complete `eval`

Complete the definition of `eval` [main.ml](lib/main.ml) in by implementing the inference rules for if-then-else expressions.

---

We can test the semantics via `dune utop lib`, as we did for the parser.
For instance:
```ocaml
parse "if true then false else true" |> eval;;
- : bool = false
```
Here we have used the pipeline operator `|>` to pass the string resulting from `parse` as input to the function `eval`.

## Small-step semantics

The small-step semantics of our language is defined by the following inference rules:
```ocaml

--------------------- [S-IfTrue]
If(True,e1,e2) -> e1

--------------------- [S-IfFalse]
If(False,e1,e2) -> e2

e0 -> e0'
----------------------------- [S-If]
If(e0,e1,e2) -> If(e0',e1,e2) 

```

Notice that no inference rule that tells us how to rewrite the expressions `True` or `False`, i.e. the small-step relation is undefined on the AST values `True` and `False`. This makes sense, because `True` and `False` should be treated as values in our language of boolean expressions. Values are expressions that can't be reduced further.

`trace1` is the function that implements the small-step relation, and to make it diverge on the values we raise the exception `NoRuleApplies` when it encounters a value. This exception is declared in the line:

```ocaml
exception NoRuleApplies
```

## Task 3: Complete `trace1`

You'll notice that the definition of `trace1` is missing the case for when the condition expression of `If` is not a value. Fill it in according to the inference rule above.

---

We then implement the transitive closure of the transition relation `trace1`, by applying it recursively until an exception is raised. 
Actually, rather than producing the resulting non-reducible expression, the function `trace` defined below
produces the whole execution trace, in the form of a sequence of boolean expressions:
```ocaml
let rec trace e = try
    let e' = trace1 e
    in e::(trace e')
  with NoRuleApplies -> [e]
;;
```
We can test this function via utop:
```ocaml
parse "if (if true then false else true) then true else false" |> trace;;
- : boolExpr list =
[If (If (True, False, True), True, False);
 If (False, True, False);
 False]
```

## Frontend & testing

To simplify debugging, the project includes a frontend which allow users to run the functions `eval` and `trace` by command line,
providing the input via stdin or file.
Before proceeding, copy the files [main.ml](bin/main.ml) and [dune](bin/dune) into your working directory, under `boolexpr/bin`.
Then, execute:
```bash
dune exec boolexpr
```
This command reads a string from stdin, and evaluates it with the big-step semantics.
For instance, if we enter:
```
if (if true then false else true) then true else (if false then true else false)
```
then the result of the evaluation will be `false` (do it!).

The frontend also features a pretty-printer for the `trace` command:
```bash
dune exec boolexpr trace 
```
For instance, if we enter the same string as before, we obtain as output:
```ocaml
If(If(True,False,True),True,If(False,True,False))
 -> If(False,True,If(False,True,False))
 -> If(False,True,False)
 -> False
```

Finally, the `test` folder contains some automated tests, which can be run via the command:
```bash
dune test
```
If no output is produced, then all tests have passed.
Further information for writing tests can be found on the [dune manual](https://dune.readthedocs.io/en/stable/tests.html).

## Task 4: Write unit tests for `eval`

Use the `test_eval` helper to test that the result of eval for a given expression equals a the expected boolean value.

Translate the following requirements into OCaml unit tests:

1. `"false"` evaluates to `false`
1. `"true"` evaluates to `true`
1. `"if true then false else true"` evaluates to `false`
1. `"if false then false else true"` evaluates to `true`
1. `"if true then (if true then false else true) else (if true then true else false)"` evaluates to `false`
1. `"if (if false then false else false) then (if false then true else false) else (if true then false else true)"` evaluates to `false`
1. `"if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)"` evaluates to `false`

## Task 5: Write unit tests for `trace1`

Translate the following requirements into OCaml unit tests:

1. `trace1` makes progress on any `If` expression (test at most three);
1. If `trace1` can't make progress on an expression, then it is a value (Tip: use the `is_value` predicate from [lib/ast.ml](lib/ast.ml));
1. The expression `"if (if false then false else false) then (if false then true else false) else (if true then false else true)"` is fully reduced no more than 10 steps.

## Task 6 (optional)

Extend the syntax with the `&&` and `||` boolean operators without modifying the big-step or small-step semantics.

Parse `a && b` as:
```
if a then b else false
```
And `a || b` as:
```
if a then true else b
```
then write some unit tests to test that they work as expected.