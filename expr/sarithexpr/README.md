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
which determines the type of a given arithmetic expression according to the following inference rules, where `e : T` stands for "the expression `e` has type `T`":
```
                                                         
----------------    -----------------    ----------------
  True : BoolT        False : BoolT        Zero : NatT   

         e : NatT                       e : NatT      
   --------------------           --------------------
      Succ e : NatT                  Pred e : NatT   
          
         e : NatT                     e : BoolT     
   --------------------           --------------------
     IsZero e : BoolT               Not e : BoolT   

  e1 : BoolT  e2 : BoolT         e1 : BoolT  e2 : BoolT
---------------------------    ---------------------------
    And (e1,e2) : BoolT            Or (e1,e2) : BoolT

            e1 : BoolT    e2 : t    e3 : t
          -------------------------------------
                    If (e1,e2,e3) : t
```

or otherwise raises an informative `TypeError`:
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

## Property-based testing with QCheck (optional)

We're going to formally verify that your implementations of `trace1` and `typecheck` satisfy two fundamental properties of type systems. To do this, we need a library that performs *property-based testing* called [QCheck](https://github.com/c-cube/qcheck).

First, install QCheck to your opam switch:
```
opam install qcheck
```

Then, add the string `qcheck` inside the section `libraries` in the file [test/dune](test/dune):
```
(libraries sarithexprLib qcheck)
```

The properties we are interested in testing are:

- **Progress**: if an expression is well-typed, then either it must be a value (`true`, `false`, or any combination of `succ` and `0`) or it can take a step to another expression.
- **Type preservation**: if an expression `e` is well-typed and it can take a step to another expression `e'`, then `e` and `e'` will have the same type.

While our language has type preservation, it doesn't have progress; QCheck will help us discover why.

The way a QCheck test works is simple: it generates a big number of random values and tries the property on every single one. In our case, the values are those of type `expr`. If one instance of the property is false then the whole test fails, otherwise it passes. This approach to testing is very powerful and it helps us discover bugs in our implementation quicker than unit testing.

We have defined the two properties, the expression generator and the two tests in the source file [properties.ml](test/properties.ml).


Now run the tests as usual with the command: 
```
dune test
```

If you implemented `trace1` and `typecheck` correctly, QCheck will report one failure out of two test runs.
Below is the output:
```
random seed: 219956250              

--- Failure --------------------------------------------------------------------

Test test_progress failed (0 shrink steps):

pred 0
================================================================================
failure (1 tests failed, 0 tests errored, ran 2 tests)
```

As you can see, the test that failed is `test_progress`, as we imagined. QCheck also provides a *counterexample*, i.e. the particular expression that violated the property:
```
pred 0
```
Oh, so that's why! Our naive typechecker gives `pred 0` the type `NatT`, but `pred 0` is neither a value nor it can take a step! In other words, it's **stuck**. A language where terms can get stuck violates the progress property.

The second test that QCheck ran is the type preservation check, which passed. This means that our interpreter won't make silly type judgments at runtime.

*Exercise*: Think of a way to make the progress test pass.