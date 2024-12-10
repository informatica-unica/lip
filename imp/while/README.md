# A simple imperative language

From the `imp/` directory, initialize the project with the command:
```sh
make while
```

Implement a simple imperative language with the following abstract syntax:
```ocaml
type ide = string
  
type expr =
  | True
  | False
  | Var of string
  | Const of int     
  | Not of expr
  | And of expr * expr
  | Or of expr * expr
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Eq of expr * expr
  | Leq of expr * expr

type cmd =
  | Skip
  | Assign of string * expr
  | Seq of cmd * cmd
  | If of expr * cmd * cmd
  | While of expr * cmd
```

Use the following types to represent the values of expressions,
and the configurations of the small-step semantics:
```ocaml
type exprval = Bool of bool | Nat of int        (* value of an expression *)
type state = ide -> exprval                     (* state = map from identifiers to expression values *)
type conf = St of state | Cmd of cmd * state    (* configuration = state | (command,state) *)
```

## Concrete syntax

Refer to the [tests](test/while.ml) for the concrete syntax of the language. 
For instance, the Euclid algorithm for computing the GCD can be written as follows:
```pascal
a:=24;
b:=60;
while not a=b do (
     if not a<=b then a:=a-b
     else b:=b-a
);
gcd:=a
```
              
## Operational semantics

Define the semantics of expressions in a big-step style:
```ocaml
eval_expr : state -> expr -> exprval
```

Define the semantics of commands in a small-step style:
```ocaml
trace1 : conf -> conf
```

The function `trace1` can raise one of the following types of exceptions:
```ocaml
exception UnboundVar of string
exception NoRuleApplies
```
The exception `UnboundVar` is raised when trying to access a variable
which has not been initialized, as in the following command:
```
y := x+1
```
Instead, the exception `NoRuleApplies` is raised when the configuration
can no longer be reduced, i.e. it is already in state tagged `St`.

Finally, define a function:
```ocaml
trace : int -> cmd -> conf list
```
such that `trace n c` performs n steps of the small-step semantics
of the command c.

## Small-step relation rules

The small-step semantics of commands can be described by the following inference rules, where `==>` models the big-step evaluation of expressions and `-->` models the small-step relation itself.

```

---------------------------- [Skip]
  Cmd (skip, st) --> St st

            st |- e ==> v
--------------------------------------- [Assign]
  Cmd (x := e, st) --> St st[x |-> v]

      Cmd (c1, st) --> St st'
------------------------------------- [Seq_St]
  Cmd (c1;c2, st) --> Cmd (c2, st')

    Cmd (c1, st) --> Cmd (c1', st')
----------------------------------------- [Seq_Cmd]
  Cmd (c1;c2, st) --> Cmd (c1';c2, st')

          st |- e ==> false
--------------------------------------------------- [If_False]
  Cmd (if e then c1 else c2, st) --> Cmd (c2, st)

          st |- e ==> true
--------------------------------------------------- [If_True]
  Cmd (if e then c1 else c2, st) --> Cmd (c1, st)

          st |- e ==> false
------------------------------------ [While_False]
  Cmd (while e do c, st) --> St st

          st |- e ==> true
-------------------------------------------------------- [While_True]
  Cmd (while e do c, st) --> Cmd (c; while e do c, st)
```

`st[x |-> v]` is notation for "`x` bound to `v` on top of `st`", meaning that you must extend the state function with an additional binding mapping the string `x` to the exprval `v`.

Therefore, you need to implement an auxiliary function:
```ocaml
bind : state -> ide -> exprval -> state
```
such that `bind st x v` yields the state `st[x |-> v]`.

This is a bit tricky to implement, because the values of `state` are functions. You can use the hint below if you can't figure it out by yourself.

<details>

<summary><i>Hint (click to reveal)</i></summary>

```ocaml
let bind st x v : state = fun y -> if x = y then v else st y
```

</details>
<br>

The initial state, from which all computations start, is the state with no
bindings at all. We call this state `bottom`:
```ocaml
bottom : state
```

You will need `bottom` for the implementation of `trace`.

## Lexer and Parser

You will need two different parser rules to parse commands and expressions.

We suggest starting with expressions: reuse the expression syntax and semantics of [arithexpr](../../expr/arithexpr/README.md) and modify it to fit the new `expr` type. In particular, our new expressions must handle variables, integer constants and comparison operators.

Once you've fully implemented expressions, begin modelling the commands: add the new keywords to the lexer and tell the parser how to parse commands.

The start rule of the parser, which we have always called `prog`, must yield ASTs of type `cmd`.

### Resolving conflicts

You will probably have trouble with precedences.
Menhir warn you of the presence of conflicts like this:
```
Warning: 2 states have shift/reduce conflicts.
Warning: 2 shift/reduce conflicts were arbitrarily resolved.
```
But it doesn't really help that much! It doesn't
tell us which particular tokens are causing the conflicts.
The following command often helps overcome this issue:
```
menhir --explain lib/parser.mly
```
This command will create a file `parser.conflicts` under [lib](lib/). Have a look at it. Here are a few lines of what I get:
```ocaml
** Conflict (shift/reduce) in state 39.
** Token involved: SEQ
** This state is reached from prog after reading:

WHILE expr DO cmd

[bla bla...]

** In state 39, looking ahead at SEQ, shifting is permitted
** because of the following sub-derivation:

WHILE expr DO cmd 
              cmd . SEQ cmd

** In state 39, looking ahead at SEQ, reducing production
** cmd -> WHILE expr DO cmd
** is permitted because of the following sub-derivation:

cmd SEQ cmd // lookahead token appears
WHILE expr DO cmd .
```
Basically, it's trying to tell us that it doesn't know what to do when parsing a program involving a sequence and a while command. Do we put the sequence under the while or vice versa? For a concrete example, the program:
```
while 0 <= x do x := x - 1; skip
```
can mean either:
```
while 0 <= x do (x := x - 1; skip)
```
or:
```
(while 0 <= x do x := x - 1); skip
```

A similar problem arises between if-then-else and sequences.
These conflicts can be solved in one of two ways:
1. Assigning the right precedence to the tokens for `;`, `do` and `else`;
1. Adding parentheses to the command syntax.

Since the test programs use parentheses, follow the second approach.
