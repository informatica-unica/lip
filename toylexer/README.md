# Lexing

From your fork of the repository, go to the `lip/` directory and create a new project with the following command:
```
dune init project toylexer
```
Then, run the following command from the `lip/toylexer` directory:
```
echo '(ocamllex lexer)' >> lib/dune
```
This appends one line to lib/dune, to instruct the compiler to
use the ocamllex tool.

The goal of this project is to familiarize with
the [ocamllex](https://v2.ocaml.org/manual/lexyacc.html) lexer generator.
Usually, a lexer takes as input a string of text
and gives as output a stream of tokens, to be fed as input to a parser
which will produce an abstract syntax tree.
In this project, we will focus only on the lexer:
combining it with a parser will be the goal of the next project.

You will work on the following files in the `lib` directory:
- [token.ml](lib/token.ml), defining the type of tokens
- [lexer.mll](lib/lexer.mll), defining the lexer generator
- [main.ml](lib/main.ml), containing utility functions to use the lexer.

The main routine in [bin/main.ml](bin/main.ml)
reads a line from the stdin, and processes it
according to the command line:
```
dune exec toylexer
```
which prints the sequence of tokens fed from stdin.
The utility functions for this command are already implemented
in [lib/main.ml](lib/main.ml).
You can test the command as follows:
```bash
echo "x=1; y=x+1" | dune exec toylexer
```
If everything is fine, you should see as output:
```
ID(x) ASSIGN CONST(1) SEQ ID(y) ASSIGN ID(x) PLUS CONST(1) EOF
```
which is the tokenization of the input string.

The project requires you to work at the following tasks:

## Task 1

Extend the `Toylexer` library so that the command:
```
dune exec toylexer freq <n>
```
prints the list of the n most frequent tokens.
To this purpose, you must implement the function
```ocaml
frequency : int -> 'a list -> ('a * int) list
```` 
in [lib/main.ml](lib/main.ml).
This function takes as input an integer n
and a list of tokens,
and outputs a list of length at most n.
This list contains pairs `(t,tn)` where `t` is a token
and `tn` is the number of its occurrences in the input.
The resulting list is ordered by the number of occurrences,
in descending order.

For instance:
```
frequency 3 [ID("x"); ASSIGN; ID("y"); SEQ; ID("x"); ASSIGN; ID("x"); PLUS; CONST("1")];;
- : (token * int) list = [(ID "x", 3); (ASSIGN, 2); (ID "y", 1)]
```

> [!NOTE]
> This is a good opportunity to use the `List` API of OCaml's standard library:
> [https://ocaml.org/manual/5.2/api/List.html](https://ocaml.org/manual/5.2/api/List.html)

## Task 2

Extend the lexer with the following types of tokens:
- **ATOK**: all strings of letters and digits starting by a capital letter
- **BTOK**: all strings of lowercase vowels
- **CTOK**: all strings of letters containing at most one vowel
- **DTOK**: all strings of digits possibly starting with `-` and possibly containing a `.` followed by other digits (e.g., 3.14, -7., -.3)
- **ETOK**: all strings representing hexadecimal numbers in C syntax
(i.e., strings starting with 0x or 0X, and containing hexadecimal value HH, where HH is 1 or more hex digits, '0'-'9','A'-'F','a'-'f')

If a string matches more than one of these patterns, then
the assigned token must be the one highest on the list.
Furthermore, all these patterns have priority over `ID` and `CONST`.

> [!NOTE]
> The syntax of `ocamllex`'s regular expressions is explained here:
> [https://ocaml.org/manual/5.2/lexyacc.html#ss:ocamllex-regexp](https://ocaml.org/manual/5.2/lexyacc.html#ss:ocamllex-regexp)

## Task 3

Implement unit tests in the `test` directory.
