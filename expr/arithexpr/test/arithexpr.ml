open ArithexprLib.Ast
open ArithexprLib.Main


(**********************************************************************
 Test big-step semantics
 **********************************************************************)

let weval e = try Some (eval e)
  with _ -> None

let test_bigstep expr exp_result =
  (expr |> parse |> weval) = exp_result
  
let%test "test_bigstep1" = test_bigstep "if true then true else false and false" (Some (Bool true))

let%test "test_bigstep2" = test_bigstep "if true then false else false or true" (Some (Bool false))

let%test "test_bigstep3" = test_bigstep "succ 0" (Some (Nat 1))

let%test "test_bigstep4" = test_bigstep "succ succ succ pred pred succ succ pred succ pred succ 0" (Some (Nat 3))

let%test "test_bigstep5" = test_bigstep "iszero pred succ 0" (Some (Bool true))

let%test "test_bigstep6" = test_bigstep "iszero pred succ 0 and not iszero succ pred succ 0" (Some (Bool true))

let%test "test_bigstep7" = test_bigstep "iszero true" None

let%test "test_bigstep8" = test_bigstep "succ iszero 0" None

let%test "test_bigstep9" = test_bigstep "not 0" None

let%test "test_bigstep10" = test_bigstep "pred 0" None

let%test "test_bigstep11" = test_bigstep "pred pred succ 0" None


(**********************************************************************
 Test small-step semantics
 **********************************************************************)

(* last element of a list *)
let rec last = function
    [] -> failwith "last on empty list"
  | [x] -> x
  | _::l -> last l

(* convert nat values to int *)
let rec int_of_nat = function
    Zero -> 0
  | Succ n -> 1 + int_of_nat n
  | _ -> failwith "int_of_nat on non-nat"

(* reduce expression with small-step semantics and convert into value option *)
let weval_smallstep e = match last (trace e) with
    True -> Some (Bool true)
  | False -> Some (Bool false)
  | e when is_nv e -> Some (Nat (int_of_nat e))
  | _ -> None

let test_smallstep expr exp_result =
  (expr |> parse |> weval_smallstep) = exp_result

let%test "test_smallstep1" = test_smallstep "if true then true else false and false" (Some (Bool true))

let%test "test_smallstep2" = test_smallstep "if true then false else false or true" (Some (Bool false))

let%test "test_smallstep3" = test_smallstep "succ 0" (Some (Nat 1))

let%test "test_smallstep4" = test_smallstep "succ succ succ pred pred succ succ pred succ pred succ 0" (Some (Nat 3))

let%test "test_smallstep5" = test_smallstep "iszero pred succ 0" (Some (Bool true))

let%test "test_smallstep6" = test_smallstep "iszero pred succ 0 and not iszero succ pred succ 0" (Some (Bool true))

let%test "test_smallstep7" = test_smallstep "iszero true" None

let%test "test_smallstep8" = test_smallstep "succ iszero 0" None

let%test "test_smallstep9" = test_smallstep "not 0" None

let%test "test_smallstep10" = test_smallstep "pred 0" None

let%test "test_smallstep11" = test_smallstep "pred pred succ 0" None

