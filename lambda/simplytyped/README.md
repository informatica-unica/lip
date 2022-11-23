# Simply typed lambda-calculus

Write an interpreter of the simply typed lambda-calculus with bool and nat base types, according to the following guidelines.

## Abstract syntax

The abstract syntax of the language is defined in [ast.ml](lib/ast.ml)
as follows:
```ocaml
type term =
    Var of string
  | Abs of string * ty * term
  | App of term * term
  | True
  | False
  | Not of term
  | And of term * term
  | Or of term * term
  | If of term * term * term
  | Zero
  | Succ of term
  | Pred of term
  | IsZero of term
```
Note that, unlike in the [untyped lambda-calculus](../untyped), in the simply typed lambda-calculus the variables in abstractions are **explicitly typed**. The possible types are defined by the following abstract syntax:
```ocaml
type ty = TBool | TNat | TFun of ty * ty
```
where the type `TBool` represents booleans, `TNat` is for naturals, and `TFun` for function types.
For instance, the term:
```ocaml
fun f: nat->bool. f 0
```
represents a function that takes as argument a function f from nat to bool, and applies it to 0.
Its abstract syntax is:
```ocaml
"fun f: nat->bool. f 0" |> parse;;
- : term = Abs ("f", TFun (TNat, TBool), App (Var "f", Zero))
```

## Type checking

Write a function with type
```ocaml
typecheck : (string -> ty) -> term -> ty
```
such that `typecheck gamma t` returns the type of the term `t` in the type environment `gamma`, or raises a `TypeError` exception if the term is not typeable.

For instance, in the empty type environment (`bot`) we expect to have:
```ocaml
(fun x:nat. iszero x) 0" |> parse |> typecheck bot;;
- : ty = TBool

fun x:nat. iszero x" |> parse |> typecheck bot;;
- : ty = TFun (TNat, TBool)
```

## Small-step semantics

The call-by-value evaluation strategy extends that of the [untyped lambda calculus](../untyped/#small-step-semantics). 
The base rules are the following rules:
```
v ::= fun x . t | bv | nv       (values)
bv ::= true | false             (bool values)
nv ::= 0 | succ nv              (nat values)

------------------------------- [CBV-AppAbs]
(fun x:T . t1) v2 -> [x -> v2] t1

t1 -> t1'
------------------------------- [CBV-App1]
t1 t2 -> t1' t2

t2 -> t2'
------------------------------- [CBV-App2]
v1 t2 -> v1 t2'
```
Besides these rules, the semantics of the simply typed lambda calculus include rules
for operating on the base types. These rules are similar to those given for the
language of [arithmetic expressions](../../expr/arithexpr#small-step-semantics).

Implement the call-by-value strategy as a function with the following type:
```ocaml
trace : term -> term list
```
Note that, unlike in the [untyped lambda-calculus](../untyped), the well-typed terms of the simply typed lambda calculus 
always terminate into a value. 
Therefore, there is no need for using feeding `trace` with the number of steps.


## Frontend and testing

Run the frontend with the commands:
```
dune exec simplytyped trace
dune exec simplytyped typecheck
```
For instance, we should obtain:
```
dune exec simplytyped typecheck
(fun x:bool. fun y:bool. x and y) true true
bool

dune exec simplytyped trace
(fun x:bool. fun y:bool. x and y) true true
((fun x : bool . fun y : bool . x and y) (true)) (true)
 -> (fun y : bool . true and y) (true)
 -> true and true
 -> true
```

