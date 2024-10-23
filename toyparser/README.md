# Parsing

From your fork of the repository, go to the `lip/` directory and create a new project:
```
dune init project toyparser
```
Then, run the following commands from the `lip/toyparser` directory:
```
echo '(using menhir 2.1)' >> dune-project
echo -e '(menhir (modules parser))\n(ocamllex lexer)' >> lib/dune
```
These commands extend the dune configuration files,
to instruct the compiler to use the ocamllex and the Menhir tools.

The goal of this project is to familiarize with
the [Menhir](https://gallium.inria.fr/~fpottier/menhir/) parser generator.
While the lexer takes as input a string of text and outputs a list of tokens
(in the form of a lexer buffer of type `Lexing.lexbuf`),
the parser takes as input a lexer buffer, 
and gives as output an abstract syntax tree (AST).

You will work on the following files in the `lib` directory:
- [ast.ml](lib/ast.ml), defining the type of the abstract syntax tree
- [lexer.mll](lib/lexer.mll), defining the lexer generator
- [parser.mly](lib/parser.mly), defining the parser generator
- [main.ml](lib/main.ml), containing utility functions.

In this project, we start with simple expressions 
that are summations of natural numbers.
For instance:
```
1 + 2 + 3 + (1 + 2)
```
Correspondigly, the type of the abstract syntax tree is the following:
```ocaml
type ast =
    Const of int
  | Add of ast * ast
```

The main utility function in the `Toyparser` library is:
```ocaml
eval : ast -> result
````
This function takes as input an abstract syntax tree,
and outputs its integer value.
For instance:
```ocaml
eval (Add(Add(Const(1),Const(2)),Const(3)))
> 6
```

The main routine in [bin/main.ml](bin/main.ml)
reads a line from the stdin, and processes it
according to the command line:
```
dune exec toyparser
```
which evaluates the string fed from stdin, and prints the result.

If everything is fine, you can test the project as follows:
```bash
echo "1 + 2 + 3 + (1 + 2)" | dune exec toyparser
> 9
```

The project requires you to work at the following tasks:

## Task 1

Extend the lexer, the parser and the evaluation function
to handle also the subtraction operator.

The tricky part of this task is to obtain the right priority to operators. 
As a guideline, we want to ensure that their priority is the same as in the Python REPL.
For instance:
```bash
echo "5 - 3 - 1" | dune exec toyparser
> 1                                   
```
The priority of operators is defined in [parser.mly](lib/parser.mly).
In the project skeleton, look at the line:
```
%left PLUS
```
This line instructs the lexer that the PLUS token associates to the left. In practice, it introduces a rule in the parser saying that the sum production cannot appear as the right child of another sum production.

Then, when parsing:
```
1 + 2 + 3
```
The parser will output the AST:
```ocaml
Add(Add(Const(1),Const(2)),Const(3))
```

### Associativity and Priority in Menhir
A line starting with `%left` defines a left associative group of tokens or productions, whereas `%right` defines a right associative group.

Every token or production in the same associativity group has the same priority.

There can be multiple associativity declarations, each on its own line:
```
%left tok_1
%left tok_2
...
%left tok_n
```
Each associativity group takes precedence over the ones defined [**above it**](https://gallium.inria.fr/~fpottier/menhir/manual.html#sec%3Aassoc). Here, for example, the token `tok_1` has lower priority than `tok_2`, or equivalently, `tok_2` binds tighter than `tok_1`.

Fundamentally, this means that `tok_1` cannot appear as a direct child of `tok_2` in the AST of any given expression, since the parser will strive to reduce the token with higher priority (here `tok_2`) first.

## Task 2

Extend the lexer, the parser and the evaluation function
to handle also multiplication and division.

Revise the evaluation function so that results are of type `int option`.
The result of `eval e` must be `None` if the evaluation involves a division by zero.

## Task 3

Extend the lexer, the parser and the evaluation function
to handle also the unary minus.
For instance:
```bash
echo "-1 - 2 - -3" | dune exec toyparser
0                                   
```

## Task 4

Extend the lexer, the parser and the evaluation function
to handle also hexadecimal numbers in C syntax.
For instance:
```bash
echo "0x01 + 2" | dune exec toyparser
> 3
```

## Task 5

Implement unit tests in the `test` directory.
