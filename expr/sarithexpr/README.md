# Typed arithmetic expressions with static type checking

Extend the language of [arithmetic expressions](../arithexpr) with static type checking.
More precisely, you must add a function with type:
```ocaml
typecheck : SarithexprLib.Ast.expr -> exprtype
```
which determines the type of a given arithmetic expression, or otherwise raise a `TypeError`.
The type `exprtype` is defined as follows:
```ocaml
type exprtype = BoolT | NatT
```

The new function is available in the frontend through the following command:
```
dune exec sarithexpr typecheck
```
For example, using the previous command we could have the following types for the given inputs:
```ocaml
iszero succ pred pred 0             
Bool

succ (if true then 0 else succ 0)   
Nat

if iszero 0 then succ 0 else succ succ 0
Nat

true and succ 0                     
succ(0) has type Nat, but type Bool was expected

succ 0 or iszero 0                  
succ(0) has type Nat, but type Bool was expected

if 0 then succ 0 else pred 0        
0 has type Nat, but type Bool was expected

if iszero 0 then true else succ succ 0
succ(succ(0)) has type Nat, but type Bool was expected
```

Your implementation can be automatically tested as usual with the command:
```
dune test
```
