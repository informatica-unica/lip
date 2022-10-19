# Arithmetic expressions

Extend the language of [boolean expressions](../andboolexpr) with arithmetic expressions on natural numbers,
according to the following [AST](src/ast.ml):
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

Follow the unit tests in [arithexpr.ml](test/arithexpr.ml) for the concrete syntax of the language. 
To run the tests, execute the following command from the project directory:
```
dune test
```

Note that some expressions in this language are not well-typed, because they improperly mix natural numbers with booleans;
For instance, this is the case for the expressions:
```
iszero true
succ iszero 0
not 0
```
In all these cases, the evaluation should produce a run-time exception specifying the cause of the error.
Run-time exceptions should also be raised for the expressions which evaluate to negative values, like the following:
```
pred 0
pred pred succ 0
```
