type ty = TBool | TNat | TFun of ty * ty

type term =
    Var of string
  | Abs of string * ty * term
  | App of term * term
  | True
  | False
  | Not of term
  | And of term * term
  | Or of term * term
  | If of term * term * term
  | Zero
  | Succ of term
  | Pred of term
  | IsZero of term
