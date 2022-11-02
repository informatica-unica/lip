type term =
    Var of string
  | Abs of string * term
  | App of term * term

