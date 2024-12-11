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
  | Block of cmd (* Runtime only! *)
