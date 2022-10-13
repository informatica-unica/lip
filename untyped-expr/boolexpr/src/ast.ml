type boolExpr =
    True
  | False
  | If of boolExpr * boolExpr * boolExpr
;;
