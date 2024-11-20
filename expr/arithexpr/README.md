# Typed arithmetic expressions with dynamic type checking

First, initialize this project by running the following command from the `expr` directory:
```bash
make arithexpr
```

Extend the language of [boolean expressions](../andboolexpr) with arithmetic expressions on natural numbers,
according to the following [AST](lib/ast.ml):
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
```
The meaning of the new constructs is the following:
- **Zero** represents the natural number 0;
- **Succ e** evaluates to the successor of e;
- **Pred e** evaluates to the predecessor of e (defined only if e is not zero);
- **IsZero e** evaluates to true iff e evaluates to 0.


## Concrete syntax

Follow the unit tests in [arithexpr.ml](test/arithexpr.ml) for the concrete syntax of the language. 
To run the tests, execute the following command from the project directory:
```
dune test
```
For example, the following is a syntactically correct expression:
```
iszero pred succ 0 and not iszero succ pred succ 0
```
You can check its AST via `dune utop lib` as follows:
```ocaml
"iszero pred succ 0 and not iszero succ pred succ 0" |> ArithexprLib.Main.parse;;
```


## Big-step semantics

The big-step semantics extends that of [boolean expressions](../andboolexpr#big-step-semantics) with the following rules:
```ocaml

---------------------------- [B-Zero]
Zero => 0

e => n
---------------------------- [B-Succ]
Succ(e) => n+1

e => n   n>0
---------------------------- [B-Pred]
Pred(e) => n-1

e => 0
---------------------------- [B-IsZeroZero]
IsZero(e) => true

e => n   n>0
---------------------------- [B-IsZeroSucc]
IsZero(e) => false
```

The `eval` function must have the following type:
```ocaml
eval : expr -> exprval
```
where the type `exprval`, used to wrap booleans and naturals, must be defined as follows (in lib/main.ml):
```ocaml
type exprval = Bool of bool | Nat of int
```

Note that some expressions in this language are not well-typed, because they improperly mix natural numbers with booleans.
For instance, this is the case for the expressions:
```
iszero true
succ iszero 0
not 0
```
In all these cases, the evaluation should produce a **run-time error** specifying the cause of the error.
Run-time errors should also be raised for the expressions which evaluate to negative values, like the following:
```
pred 0
pred pred succ 0
```


## Small-step semantics

The small-step semantics extends that of [boolean expressions](../andboolexpr#small-step-semantics) with the following rules:
```ocaml
nv ::= Zero | Succ(nv)

e -> e'
----------------------------- [S-Succ]
Succ(e) -> Succ(e') 

----------------------------- [S-PredSucc]
Pred(Succ(nv)) -> nv 

e -> e'
----------------------------- [S-Pred]
Pred(e) -> Pred(e') 

----------------------------- [S-IsZeroZero]
IsZero(Zero) -> True

----------------------------- [S-IsZeroSucc]
IsZero(Succ(nv)) -> False 

e -> e'
----------------------------- [S-IsZero]
IsZero(e) -> IsZero(e') 
```

For example, this semantics should give rise to the following execution trace:
```
dune exec arithexpr trace test/test1
iszero(pred(succ(pred(succ(0)))))   
 -> iszero(pred(succ(0)))
 -> iszero(0)
 -> true
```
