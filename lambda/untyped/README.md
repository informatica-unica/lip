# Pure untyped lambda calculus

Write an interpreter of the pure untyped lambda-calculus,
according to the following guidelines.

The repository already contains the frontend, the parser and the inline tests, as well as some utility functions.
Before starting, synchronize and pull the repository, and rename the file [lib/main.ml_skeleton](lib/main.ml_skeleton)
into lib/main.ml (use the command `git mv lib/main.ml_skeleton lib/main.ml` from your local copy of the repository).

## Abstract syntax

The abstract syntax of the language is defined in [ast.ml](lib/ast.ml)
as follows:
```ocaml
type term =
    Var of string
  | Abs of string * term
  | App of term * term
```
The terms of the language are variables, lambda-abstractions and applications between two terms.
For instance, the term:
```ocaml
Abs("x", Var "x")
```
represents the identity function.

## Pretty printer

The repository already contains a pretty printer for the terms of the language:
```ocaml
string_of_term : term -> string
```
You can test it via `dune utop lib` as follows:
```ocaml
open UntypedLib.Main;;
open UntypedLib.Ast;;

Abs("z", App(App (Var "x", Var "y"), Var "z")) |> string_of_term;;
- : string = "fun z. (x y) z"
```
Hereafter, when we use utop we assume that the first two `open` commands are always given.

## Concrete syntax

The [lexer](lib/lexer.mll) and the [parser](parser.mly)
are already included in the repository.
The parser ensures that application associates to the left.
For instance, in utop:
```ocaml
"f g h" |> parse;;
- : term = App (App (Var "f", Var "g"), Var "h")

"(fun x. x) (fun y. y z) (fun z. x y z)" |> parse |> string_of_term;;
- : string = "((fun x. x) (fun y. y z)) (fun z. (x y) z)"
```

## Free variables

The free variables of a term t, written fv(t), are defined inductively as follows:
```
fv(x) = {x}

fv(fun x . t) = fv(t) \ {x}

fv(t1 t2) = fv(t1) U fv(t2)
```

Write a function `is_free` to detect if a variable is free in a term:
```ocaml
is_free : string -> term -> bool
```

For instance, we expect that:
```ocaml
"fun x . x (fun y . (x y) z)" |> parse |> (is_free "x");;
- : bool = false

"fun x . x (fun y . (x y) z)" |> parse |> (is_free "y");;
- : bool = false

"fun x . x (fun y . (x y) z)" |> parse |> (is_free "z");;
- : bool = true
```

## Variable renaming

Write a function with type:
```
rename : string -> string -> term -> term
```
such that `rename x x' t` replaces all the free occurrences of `x` in `t` as `x'`. 
For instance:
```ocaml
rename "x" "w" ("(fun z . x y) (fun y. x)" |> parse) |> string_of_term;;
- : string = "(fun z. w y) (fun y. w)"

rename "y" "w" ("(fun z . x y) (fun y. x)" |> parse) |> string_of_term;;
- : string = "(fun z. x w) (fun y. x)"

rename "z" "w" ("(fun z . x y) (fun y. x)" |> parse) |> string_of_term;;
- : string = "(fun z. x y) (fun y. x)"
```
The function must raise an exception in case `x'` occur (either free or bound) in `t`.
For instance:
```ocaml
rename "y" "x" ("(fun z . x y) (fun y. x)" |> parse) |> string_of_term;;
Exception: Failure "name x must be fresh!".

rename "y" "z" ("(fun z . x y) (fun y. x)" |> parse) |> string_of_term;;
Exception: Failure "name z must be fresh!".
```

## Alpha-equivalence

To terms are alpha-equivalent when they have exactly the same structure, except for the choice of bound names.
Write a funtion with type:
```ocaml
equiv : term -> term -> bool
```
which detects if two terms are alpha-equivalent. For instance, we must have:
```ocaml
equiv ("fun x . x y" |> parse) ("fun z . z y" |> parse);;
- : bool = true

equiv ("fun x . x y" |> parse) ("fun z . z z" |> parse);;
- : bool = false

equiv ("fun x . (fun y . x)" |> parse) ("fun y . (fun x . y)" |> parse);;
- : bool = true
```

## Substitutions

A substitution `[x -> t] t'` replaces all the free occurrences of the variable x in t' with the term t.
For instance:
```
[x -> (fun z . z w)] (fun y . x) = fun y . fun z . z w
```
Instead, bound occurrences of x must *not* be substituted. For instance is would be wrong to obtain:
```
[x -> y] (fun x . x) = fun x . y     (* WRONG! *)
```
To see why the above is wrong, note that by renaming the term `fun x . x` with the alpha-equivalent term `fun z . z`, we would obtain:
```
[x -> y] (fun z . z) = fun z . z
```
Another delicate issue is that of **variable capture**. For instence, consider the following substitution:
```
[x -> z] (fun z . x)
```
Here, it would be wrong to obtain:
```
[x -> z] (fun z . x) = fun z . z     (* WRONG! *)
```
To see why this is wrong, note that by renaming `fun z . x` with the alpha-equivalent `fun w . x`, we would obtain:
```
[x -> z] (fun z . x) = fun w . z
```
Note that the two resulting terms `fun z . z` and `fun w . z` are *not* alpha-equivalent: hence, the first substitution is wrong.

To guarantee that substitutions are capture-avoiding, we implement an **explicit renaming of bound variables**.
To this purpose, substitutions take an extra argument: 
```
[x -> t] k t'
```
The natural number k stands for the index of a fresh variable that we can use for such renamings.
For instance, we have:
```
[x -> z] (fun z . x) = fun x1 . z
```
Here, to avoid captures we have alpha-converted `(fun z . x)` into `(fun x1 . x)`, where the fresh variable x1 has been obtained by concatenating x with the index 1.

Other examples of substitution are the following:
```
[x -> z] 1 (fun z . x) (fun y. x) (fun z. z) = (fun x1. z) (fun y. z) (fun x2. x2)

[x -> y z] 1 (fun y . x (fun w . x) = fun x1 . (y z) (fun w . y z)

[x -> y z] 3 (fun y . x (fun z . x y z) = fun x3 . (y z) (fun x4 . ((y z) x3) x4)
```

Using this technique, write a substitution function with the following type:
```ocaml
subst : string -> term -> int -> term -> term * int
```
For instance, we expect that:
```ocaml
subst "x" ("y z" |> parse) 3 ("fun y . x  (fun z . x y z)" |> parse) |> fst |> string_of_term;;
- : string = "fun x3. (y z) (fun x4. ((y z) x3) x4)"
```

## Small-step semantics

The terms of the lambda-calculus can be evaluated according to different strategies, which determine which sub-terms are reduced first.
The **call-by-value** evaluation strategy is defined by the following rules:
```
v ::= fun x . t                 (values)

------------------------------- [CBV-AppAbs]
(fun x . t1) v2 -> [x -> v2] t1

t1 -> t1'
------------------------------- [CBV-App1]
t1 t2 -> t1' t2

t2 -> t2'
------------------------------- [CBV-App2]
v1 t2 -> v1 t2'
```

Implement the call-by-value strategy as a function with the following type:
```ocaml
trace : int -> term -> term
```
where the integer argument stands for the number of steps to be performed.


## Frontend and testing

Run the frontend with the command:
```
dune exec untyped n
```
where n is the number of evaluation steps. For instance, with n=4 we should obtain:
```
((fun x. (x x) x) (fun y. y)) (fun z. z)
 -> (((fun y. y) (fun y. y)) (fun y. y)) (fun z. z)
 -> ((fun y. y) (fun y. y)) (fun z. z)
 -> (fun y. y) (fun z. z)
 -> fun z. z
```
