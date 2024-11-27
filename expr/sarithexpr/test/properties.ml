open SarithexprLib.Ast
open SarithexprLib.Main
open Random_ast
open QCheck

(* ### Properties ### *)

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

(* ### Tests ### *)

let ast_gen = 
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
        2, map3 eif (self (n/3)) (self (n/3)) (self (n/3));
      ]
    ));;

let arbitrary_ast =
  QCheck.make ast_gen ~print:string_of_expr

let test_progress =
  QCheck.Test.make arbitrary_ast progress

let test_preservation =
  QCheck.Test.make arbitrary_ast preservation
;;

QCheck_runner.run_tests [test_progress; test_preservation];;