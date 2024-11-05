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
eval (Add (Add (Const 1,  Const 2), Const 3))
> Ok 6
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
This line instructs the parser that the PLUS token associates to the left. Behind the scenes, it introduces a rule in the parsing tables saying that the sum production cannot appear as the right child of another sum production.

Then, when parsing:
```
1 + 2 + 3
```
The parser will output the AST:
```ocaml
Add(Add (Const 1, Const 2), Const 3)
```

### Associativity and Priority in Menhir

The section of [parser.mly](/lib/parser.mly) between the the token declarations and the grammar rules is dedicated to associativity and priority declarations.

An associativity declaration is written in a single line and it has the form `%left <TOKEN>` or `%right <TOKEN>`.

A line starting with `%left` defines a left-associative group of tokens or productions, while `%right` defines a right-associative group. There's also `%nonassoc`, which defines a group that is not associative.

Every token or production in the same associativity group has the same priority. There can be multiple associativity declarations, each on its own line, for example:
```
%left OR
%left AND
%nonassoc NOT
```
The order of the declaration has a special meaning: it defines the precedence of the tokens. The associativity declarations that come later in the file take precedence over the declarations in the previous lines ([see the documentation](https://gallium.inria.fr/~fpottier/menhir/manual.html#sec%3Aassoc)).

In the example above, the token `OR` has lower priority than both `AND` and `NOT`. At the same time, `AND` has higher precedence than `OR` and lower precedence than `NOT`.

Behind the scenes, the parse tables are constructed so that `OR` cannot appear as a direct child of `AND` in the AST of any given expression without parentheses, and therefore the parser will always try to reduce `AND` first.

## Evaluating results

Let's have a closer look at the type of the evaluator: 

```ocaml
eval : ast -> result
```

Both `ast` and `result` are custom types. In particular, `result` is defined in [lib/mail.ml](/lib/main.ml) as a synonym of `(int, string) Result.t` by the line:

```ocaml
type result = (int, string) Result.t
```

This type expresses the fact that the computations of `eval` can _either_ successfully compute an integer value _or_ they can catastrophically fail with an error that is described by a string message.

When we successfully compute a value and are ready to return it, we wrap it in the `Ok` tag. This is what we've done in the evaluator so far. For example, constant expressions carry a number that can be immediately wrapped in `Ok`:

```ocaml
| Const n -> Ok n
```

When we can't compute a value for the given inputs, we must report the problem to the caller. With results, we do this by returning a string message explaining what went wrong inside the `Error` tag, like in the following pseudocode:

```ocaml
| <Bad inputs> -> Error "Failed to compute a value for the inputs ... because ..."
```

To extract the value from a result we use pattern matching. However, a value is not always available, so it is best to return another result rather than throw an exception. In other words, we must handle the case where the result is an error.

The following pseudocode matches on an input result called `res` and returns a new result. If the input result matches `Ok value`, then `value` is transformed by a function `f`. You can think of `f` as some work that you want to do on the value. Otherwise, if the input result matches `Error msg`, it is propagated in the output exactly as it is:

```ocaml
match res with
| Ok value -> f value
| Error msg -> Error msg
```

This is a common pattern in functional programming and it can be factored out into a higher-order function that takes a result, an anonymous function that transforms a value into a new result, and returns a brand new result. We've named this function `==>` (pronounced "bind") so that it can be used as a infix operator:

```ocaml
let ( ==> ) res f =
  match res with
  | Ok value -> Ok (f value)
  | Error msg -> Error msg
```

The thick arrow operator helps us make the code of the evaluator a lot more succinct and readable. The case for `Add`, for example, simplifies to:

```ocaml
| Add (e1,e2) ->
  eval e1 ==> fun v1 ->
  eval e2 ==> fun v2 ->
  Ok (v1 + v2)
```

This pattern has an additional benefit in that it is short-circuiting: if one of the expressions being evaluated fails with `Error _` then this is the result of the whole `Add` case; execution won't continue on evaluating the other expression.

## Task 2

Extend the lexer, the parser and the evaluation function
to handle also multiplication and division.

Revise the evaluation function to report an error when attempting to divide by zero.
The result of `eval e` must be `Result.Error msg` if the evaluation involves a division by zero. The error message must mention the value of the dividend, as in the following output:

```sh
echo "1 + 2 / 0" | dune exec toyparser
> Error: tried to divide 2 by zero
```

## Task 3

Extend the lexer, the parser and the evaluation function
to handle also the unary minus.
For instance:
```bash
echo "-1 - 2 - -3" | dune exec toyparser
> 0
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
