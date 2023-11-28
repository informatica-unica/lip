# Imperative language with blocks

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
  | EmptyDecl
  | IntVar of ide * decl
  | BoolVar of ide * decl

type cmd =
  | Skip
  | Assign of string * expr
  | Seq of cmd * cmd
  | If of expr * cmd * cmd
  | While of expr * cmd
  | Decl of decl * cmd
  | Block of cmd
```

The states of the small-step semantics are triples containing
a stack of environments, a memory, and an integer representing the first free memory location.
We represent states in OCaml by the type `state` defined as follows:
```ocaml
type envval = BVar of loc | IVar of loc
type memval = Bool of bool | Int of int

type env = ide -> envval
type mem = loc -> memval

type state = env list * mem * loc
```
   
For example, for the program:
```pascal
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
 