open AndboolexprLib.Ast
open AndboolexprLib.Main

(**********************************************************************
 Test big-step semantics
 **********************************************************************)

let test_bigstep expr exp_result =
  (expr |> parse |> eval) = exp_result
  
let%test "test_bigstep1" = test_bigstep "false" false

let%test "test_bigstep2" = test_bigstep "true" true

let%test "test_bigstep3" = test_bigstep "if true then false else true" false  

let%test "test_bigstep4" = test_bigstep "if false then false else true" true

let%test "test_bigstep5" = test_bigstep "if true then (if true then false else true) else (if true then true else false)" false

let%test "test_bigstep6" = test_bigstep "if (if false then false else false) then (if false then true else false) else (if true then false else true)" false

let%test "test_bigstep7" = test_bigstep "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)" false

let%test "test_bigstep8" = test_bigstep "not not true" true

let%test "test_bigstep9" = test_bigstep "not if true then false else true" true

let%test "test_bigstep10" = test_bigstep "if true then (if true then false else true) else (if true then true else false)" false

let%test "test_bigstep11" = test_bigstep "if (if false then false else false) then (if false then true else false) else (if true then false else true)" false

let%test "test_bigstep12" = test_bigstep "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)" false

let%test "test_bigstep13" = test_bigstep "not true or true" true

let%test "test_bigstep14" = test_bigstep "not true and false" false

let%test "test_bigstep15" = test_bigstep "false and false or true" true

let%test "test_bigstep16" = test_bigstep "true or false and false" true

let%test "test_bigstep17" = test_bigstep "if true then true else false and false" true

let%test "test_bigstep18" = test_bigstep "if true then false else false or true" false


(**********************************************************************
 Test small-step semantics
 **********************************************************************)

let rec last = function
    [] -> failwith "last on empty list"
  | [x] -> x
  | _::l -> last l

let eval_smallstep e = match last (trace e) with
    True -> Some true
  | False -> Some false
  | _ -> None

let test_smallstep expr exp_result =
  (expr |> parse |> eval_smallstep) = exp_result

let%test "test_smallstep1" = test_smallstep "false" (Some false)

let%test "test_smallstep2" = test_smallstep "true" (Some true)

let%test "test_smallstep3" = test_smallstep "if true then false else true" (Some false)

let%test "test_smallstep4" = test_smallstep "if false then false else true" (Some true)

let%test "test_smallstep5" = test_smallstep "if true then (if true then false else true) else (if true then true else false)" (Some false)

let%test "test_smallstep6" = test_smallstep "if (if false then false else false) then (if false then true else false) else (if true then false else true)" (Some false)

let%test "test_smallstep7" = test_smallstep "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)" (Some false)

let%test "test_smallstep8" = test_smallstep "not not true" (Some true)

let%test "test_smallstep9" = test_smallstep "not if true then false else true" (Some true)

let%test "test_smallstep10" = test_smallstep "if true then (if true then false else true) else (if true then true else false)" (Some false)

let%test "test_smallstep11" = test_smallstep "if (if false then false else false) then (if false then true else false) else (if true then false else true)" (Some false)

let%test "test_smallstep12" = test_smallstep "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)" (Some false)

let%test "test_smallstep13" = test_smallstep "not true or true" (Some true)

let%test "test_smallstep14" = test_smallstep "not true and false" (Some false)

let%test "test_smallstep15" = test_smallstep "false and false or true" (Some true)

let%test "test_smallstep16" = test_smallstep "true or false and false" (Some true)

let%test "test_smallstep17" = test_smallstep "if true then true else false and false" (Some true)

let%test "test_smallstep18" = test_smallstep "if true then false else false or true" (Some false)
