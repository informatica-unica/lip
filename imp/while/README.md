# A simple imperative language

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

## Pretty printing

Implement the following functions to convert data into strings:
```ocaml
string_of_val : exprval -> string

string_of_expr : expr -> string

string_of_cmd : cmd -> string

string_of_state : state -> ide list -> string

string_of_conf : ide list -> conf -> string

string_of_trace : ide list -> conf list -> string
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
trace : int -> cmd -> term list
```
such that `trace n c` performs n steps of the small-step semantics
of the command c.
