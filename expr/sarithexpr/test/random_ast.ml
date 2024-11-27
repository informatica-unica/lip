open SarithexprLib.Ast

let expr_of_bool b = if b then True else False

let bool () = if Random.int 2 = 1 then True else False

let rec expr_of_nat = function 0 -> Zero | n -> Succ (expr_of_nat (n - 1))

let nat () = Random.int 5 |> expr_of_nat

let value () = if Random.int 2 = 1 then nat () else bool ()

let epred e = Pred e
let esucc e = Succ e
let enot e = Not e
let eiszero e = IsZero e
let eand a b = And (a,b)
let eor a b = Or (a,b)
let eif a b c = If (a,b,c)
 