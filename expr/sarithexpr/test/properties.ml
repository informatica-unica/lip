open SarithexprLib.Ast
open SarithexprLib.Main
open QCheck

(* ################################################
   Helpers for building expr values
   ################################################ *)

let expr_of_bool b = if b then True else False

let rec expr_of_nat = function
  | 0 -> Zero
  | n -> Succ (expr_of_nat (n - 1))

let epred e = Pred e
let esucc e = Succ e
let enot e = Not e
let eiszero e = IsZero e
let eand a b = And (a,b)
let eor a b = Or (a,b)
let eif a b c = If (a,b,c)

(* ################################################
   Formalization of progress and preservation properties
   ################################################ *)

let rec is_nv : expr -> bool = function
  | Zero -> true
  | Succ e -> is_nv e
  | _ -> false

let is_bv = function
  | True | False -> true
  | _ -> false

let is_value e = is_bv e || is_nv e

let can_take_step e =
  try
    ignore (trace1 e); true
  with NoRuleApplies -> false

let typechecks e =
  try
    ignore (typecheck e); true
  with _ -> false

let progress e =
  typechecks e ==>
  (is_value e || can_take_step e)

let preservation e =
  try
    let ty1 = typecheck e in
    let e' = trace1 e in
    let ty2 = typecheck e' in
    ty1 = ty2
  with _ -> true

(* ################################################
   QCheck setup & test running
   Note: progress will fail!
   ################################################ *)

let expr_gen = 
  QCheck.Gen.(
    sized @@ fix (fun self n -> match n with
    | 0 -> map expr_of_bool bool
    | 1 -> map expr_of_nat nat
    | n ->
      frequency [
        1, map epred (self (n/2));
        1, map esucc (self (n/2));
        1, map eiszero (self (n/2));
        1, map enot (self (n/2));
        1, map2 eand (self (n/2)) (self (n/2));
        1, map2 eor (self (n/2)) (self (n/2));
        1, map3 eif (self (n/3)) (self (n/3)) (self (n/3));
      ]
    ));;

let arbitrary_expr =
  QCheck.make expr_gen ~print:string_of_expr

let test_progress =
  QCheck.Test.make ~name:"test_progress" arbitrary_expr progress

let test_preservation =
  QCheck.Test.make ~name:"test_preservation" arbitrary_expr preservation
;;

QCheck_runner.run_tests [test_progress; test_preservation];;