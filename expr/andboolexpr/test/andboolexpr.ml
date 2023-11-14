open AndboolexprLib.Ast
open AndboolexprLib.Main

let test_eval expr exp_result =
  (expr |> parse |> eval) = exp_result
  
let%test "test1" = test_eval "false" false

let%test "test2" = test_eval "true" true

let%test "test3" = test_eval "if true then false else true" false  

let%test "test4" = test_eval "if false then false else true" true

let%test "test5" = test_eval "if true then (if true then false else true) else (if true then true else false)" false

let%test "test6" = test_eval "if (if false then false else false) then (if false then true else false) else (if true then false else true)" false

let%test "test7" = test_eval "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)" false

let%test "test8" = test_eval "not not true" true

let%test "test9" = test_eval "not if true then false else true" true

let%test "test10" = test_eval "if true then (if true then false else true) else (if true then true else false)" false

let%test "test11" = test_eval "if (if false then false else false) then (if false then true else false) else (if true then false else true)" false

let%test "test12" = test_eval "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)" false

let%test "test13" = test_eval "not true or true" true

let%test "test14" = test_eval "not true and false" false

let%test "test15" = test_eval "false and false or true" true

let%test "test16" = test_eval "true or false and false" true

let%test "test17" = test_eval "if true then true else false and false" true

let%test "test18" = test_eval "if true then false else false or true" false


(**********************************************************************
 Test big-step semantics
 **********************************************************************)

let%test _ =
  print_newline();  
  print_endline ("*** Testing big-step semantics...");
  List.fold_left
    (fun b (s,v) ->
       print_string (s ^ " => ");       
       let ar = s |> parse |> eval in
       print_string (string_of_bool ar);
       let b' = (ar = v) in
       if b' then print_string(" [OK]")
       else print_string (" [NO: expected " ^ string_of_bool v ^ "]");
       print_newline();
       b && b')
    true
    tests


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

let%test _ =
  print_newline();  
  print_endline ("*** Testing small-step semantics...");
  List.fold_left
    (fun b (s,v) ->
       print_string (s ^ " -> ");       
       let ar = s |> parse |> eval_smallstep in
       print_string (string_of_val ar);
       let b' = (ar = Some v) in
       if b' then print_string(" [OK]")
       else print_string (" [NO: expected " ^ string_of_bool v ^ "]");
       print_newline();
       b && b')
    true
    tests

