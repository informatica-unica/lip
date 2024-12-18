# Imperative language with blocks

From the `imp/` directory, initialize the project with the command:
```sh
make blocks
```

Implement the small-step semantics of an imperative language with blocks of declarations,
with the following abstract syntax:
```ocaml
type ide = string

type expr =
  | True
  | False
  | Var of ide
  | Const of int
  | Not of expr
  | And of expr * expr
  | Or of expr * expr
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Eq of expr * expr
  | Leq of expr * expr

type decl =
  | IntVar of ide
  | BoolVar of ide

type cmd =
  | Skip
  | Assign of string * expr
  | Seq of cmd * cmd
  | If of expr * cmd * cmd
  | While of expr * cmd
  | Decl of decl list * cmd
  | Block of cmd (* Runtime only: c is the cmd being reduced *)
```

The states of the small-step semantics are triples containing
a stack of environments, a memory, and an integer representing the first free memory location.
We represent states in OCaml by the type `state` defined as follows:
```ocaml
type envval = BVar of loc | IVar of loc
type memval = Bool of bool | Int of int

type env = ide -> envval
type mem = loc -> memval

type state = { envstack : env list; memory : mem; firstloc : loc }
```
   
For example, for the program:
```
{
  int z;
  int y;
  int x;
  x:=50;
  {
    int x;
    x:=40;
    y:=x+2
  };
  z:=x+1
}
```
we could have the following computation:
```
<{ int z; int y; int x; x:=50; { int x; x:=40; y:=x+2 }; z:=x+1 }, [], [], 0>
 -> <{ x:=50; { int x; x:=40; y:=x+2 }; z:=x+1 }, [1/y,0/z,2/x], [], 3>
 -> <{ { int x; x:=40; y:=x+2 }; z:=x+1 }, [1/y,0/z,2/x], [50/2,], 3>
 -> <{ { x:=40; y:=x+2 }; z:=x+1 }, [1/y,0/z,3/x], [50/2,], 4>
 -> <{ { y:=x+2 }; z:=x+1 }, [1/y,0/z,3/x], [50/2,40/3,], 4>
 -> <{ z:=x+1 }, [1/y,0/z,2/x], [42/1,50/2,40/3,], 4>
 -> [], [51/0,42/1,50/2,40/3,], 4
 ```

First, evaluate the expressions with an ad hoc function:
```ocaml
eval_expr : state -> expr -> memval
```
This is similar to `eval_expr` of [while](../while/), but now to query the state for the value of a variable, you first need to access the environment stack, then the memory.

Next, you need a function to populate the state with a list of declarations:
```ocaml
eval_decl : state -> decl list -> state
```
The output environment stack of the output state state will have grown by an additional environment, which is aware of the new identifiers. The location component will have grown to reflect the number of locations consumed by these declarations (one per identifier).

Finally define the single step relation:
```ocaml
trace1 : conf -> conf
```
and the multi step relation:
```ocaml
trace : int -> cmd -> conf list
```

## Implementation notes

1. Notice the braces around declarations.
1. You need a way to parse *a list* of declarations. For this, see if the [Menhir standard library](https://cambium.inria.fr/~fpottier/menhir/manual.html#sec38) can help you.
1. `Block` is a special AST node produced only *at runtime*: it serves the tracer to remember that it's executing commands within the scope of a declaration block.
1. Don't pattern match on the `state` triple. Use the getter functions `getenv`, `getmem` and `getloc` provided by the `Types` module to extract components from a `state` value. If you want to build a new state, there are functions for that too: `makestate`, `setenv`, `setmem`, `setloc`.

Finally, we recommend you keep a terminal in a separate VS Code tab running the following command:
```
dune test --watch
```
This will compile and run the tests in real time, refreshing the output as soon as you as soon as you make changes to any file of the project, speeding up your workflow. When you see `Success, waiting for filesystem changes...`, that means your code passes the tests!