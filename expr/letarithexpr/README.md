# Arithmetic expressions with let bindings and dynamic type checking

Extend the language of [arithmetic expressions](../arithexpr) with let bindnigs, according to the following [AST](src/ast.ml):
```ocaml
type expr =
    True
  | False
  | Not of expr
  | And of expr * expr
  | Or of expr * expr
  | If of expr * expr * expr
  | Zero
  | Succ of expr
  | Pred of expr
  | IsZero of expr
  | Var of string     
  | Let of string * expr * expr
```

The expression `Let(x,e1,e2)` evaluates as `e2` where all the free occurrences of `x` have been replaced to the value of `e1`. We want to implement an **eager** semantics, where `e1` is completely evaluated before starting the evaluation of `e2`.


## Concrete syntax 

Follow the unit tests in [letarithexpr.ml](test/lwrarithexpr.ml) for the concrete syntax of the language. 
To run the tests, execute the following command from the project directory:
```
dune test
```
For example, the following is a syntactically correct expression:
```
let x = 0 in let y = succ x in iszero succ y
```
You can check its AST via `dune utop src` as follows:
```ocaml
"let x = 0 in let y = succ x in iszero succ y" |> LetarithexprLib.Main.parse;;
```
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

The big-step semantics extends that of [arithmetic expressions](../arithexpr#big-step-semantics) with the following rules.
The evaluation function takes as input (besides the expression) an **environment** `rho`, which is represented as a function from variables (strings) to values.
```ocaml
-------------------------------------- [B-Var]
<x,rho> => rho x

<e1,rho> => v1   <e2,rho{v1/x}> => v2
-------------------------------------- [B-Let]
<let x=e1 in e2,rho> => v2
```
where the notation `rho{v1/x}` denotes the environment `rho` where the variable `x` has been bound to the value `v1`.


## Small-step semantics

The small-step semantics extends that of [arithmetic expressions](../arithexpr#small-step-semantics) with the following rules:
```ocaml

---------------------------------- [S-LetV]
let x=v1 in e2 -> e2[x->v1]

e1 -> e1'
---------------------------------- [S-Let]
let x=e1 in e2 -> let x=e1' in e2
```
where the notation `e2[x->v1]` represents the expression `e2` where all free occurrences of `x` have been replaced by the value `v1`.

For example, we expect to obtain the following trace:
```ocaml
let x = 0 in let y = succ(x) in iszero(succ(y))
 -> let y = succ(0) in iszero(succ(y))
 -> iszero(succ(succ(0)))
 -> false
```
