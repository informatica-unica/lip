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
  
