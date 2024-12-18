# Imperative language with functions

From the `imp/` directory, initialize the project with the command:
```sh
make fun
```
Recall that you can build and run the tests in real time with the command:
```
dune test --watch
```
<br>


Implement the small-step semantics of an imperative language with functions,
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
  | Call of ide * expr
  | CallExec of cmd * expr  (** Runtime only: c is the cmd being reduced, e is the return expr *)
  | CallRet of expr         (** Runtime only: e is the return expr *)

and cmd =
  | Skip
  | Assign of string * expr
  | Seq of cmd * cmd
  | If of expr * cmd * cmd
  | While of expr * cmd

type decl =
  | IntVar of ide
  | Fun of ide * ide * cmd * expr  (** name, parameter, body command, return expr *)

type prog = Prog of (decl list * cmd)
```

Functions have a single parameter, passed by value, they can be recursive, and can have side effects by writing global variables.
For example, we could write the following program to compute the factorial:
```
int x;
int r;
fun f(n) { if n=0 then r:=1 else r:=n*f(n-1); return r };
x := f(5)
```

## Small-step semantics

The states of the small-step semantics are triples containing
a stack of environments, a memory, and an integer representing the first free memory location.
We represent states in OCaml by the type `state` defined as follows:
```ocaml
type loc = int

type envval = IVar of loc | IFun of ide * cmd * expr
type memval = int

type env = ide -> envval
type mem = loc -> memval

type state = { envstack : env list; memory : mem; firstloc : loc }
```

Note that since expressions include function calls, and function bodies include commands,
also the semantics of expressions must be small-step.

For example, considering the following program:
```
int x;
int z;
fun f(x) { if x=0 then z:=1 else if x=1 then z:=0 else z:= f(x-2); return z };
x := f(2)
```
we could have the following computation:
```
<x:=f(2), [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,0/x,1/z], [], 2>
 -> <x:=exec{if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{if 2=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{if false then z:=1 else if x=1 then z:=0 else z:=f(x-2); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{if x=1 then z:=0 else z:=f(x-2); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{if 2=1 then z:=0 else z:=f(x-2); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{if false then z:=0 else z:=f(x-2); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{z:=f(x-2); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{z:=f(2-2); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{z:=f(0); ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [2/2,], 3>
 -> <x:=exec{z:=exec{if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); ret z}; ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,3/x,1/z], [2/2,0/3,], 4>
 -> <x:=exec{z:=exec{if 0=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); ret z}; ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,3/x,1/z], [2/2,0/3,], 4>
 -> <x:=exec{z:=exec{if true then z:=1 else if x=1 then z:=0 else z:=f(x-2); ret z}; ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,3/x,1/z], [2/2,0/3,], 4>
 -> <x:=exec{z:=exec{z:=1; ret z}; ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,3/x,1/z], [2/2,0/3,], 4>
 -> <x:=exec{z:={ret z}; ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,3/x,1/z], [1/1,2/2,0/3,], 4>
 -> <x:=exec{z:={ret 1}; ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,3/x,1/z], [1/1,2/2,0/3,], 4>
 -> <x:=exec{z:=1; ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [1/1,2/2,0/3,], 4>
 -> <x:={ret z}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [1/1,2/2,0/3,], 4>
 -> <x:={ret 1}, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,2/x,1/z], [1/1,2/2,0/3,], 4>
 -> <x:=1, [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,0/x,1/z], [1/1,2/2,0/3,], 4>
 -> [fun(x){if x=0 then z:=1 else if x=1 then z:=0 else z:=f(x-2); return z}/f,0/x,1/z], [1/0,1/1,2/2,0/3,], 4
```
 
