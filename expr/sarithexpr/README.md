# Typed arithmetic expressions with static type checking

First, initialize this project by running the following command from the `expr` directory:
```bash
make sarithexpr
```

Extend the language of [arithmetic expressions](../arithexpr) with static type checking.
More precisely, represent the type of expressions as follows:
```ocaml
type exprtype = BoolT | NatT
```
You must add a function with type:
```ocaml
typecheck : expr -> exprtype
```
which determines the type of a given arithmetic expression, or otherwise raises an informative `TypeError`:
```ocaml
exception TypeError of string;;
```

The following are examples of well-typed expressions and their inferred types:
```ocaml
iszero succ pred pred 0             
Bool

succ (if true then 0 else succ 0)   
Nat

if iszero 0 then succ 0 else succ succ 0
Nat
```

Instead, for the following non well-typed expressions we expect to receive the following error messages:
```ocaml
true and succ 0                     
"succ(0) has type Nat, but type Bool was expected"

succ 0 or iszero 0                  
"succ(0) has type Nat, but type Bool was expected"

if 0 then succ 0 else pred 0        
"0 has type Nat, but type Bool was expected"

if iszero 0 then true else succ succ 0
"succ(succ(0)) has type Nat, but type Bool was expected"
```

## Big-step semantics

No changes are needed to the big-step semantics of arithmetic expressions with dynamic type checking.

## Small-step semantics

No changes are needed to the small-step semantics of arithmetic expressions with dynamic type checking.

## Frontend and testing

The type checker is available in the frontend through the following command:
```
dune exec sarithexpr typecheck
```

Your implementation can be automatically tested as usual with the command:
```
dune test
```
