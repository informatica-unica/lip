type boolExpr =
    True
  | False
  | If of boolExpr * boolExpr * boolExpr
;;

let is_value : boolExpr -> bool = function
  | True -> true
  | False -> true
  | _ -> false