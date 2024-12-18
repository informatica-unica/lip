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
