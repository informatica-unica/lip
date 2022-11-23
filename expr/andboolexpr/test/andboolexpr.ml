open AndboolexprLib.Ast
open AndboolexprLib.Main
  
let tests = [
  ("false",false);
  ("true",true);
  ("not not true",true);
  ("not if true then false else true",true);
  ("if true then (if true then false else true) else (if true then true else false)",false);
  ("if (if false then false else false) then (if false then true else false) else (if true then false else true)",false);
  ("if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)",false);
  ("not true or true",true);
  ("not true and false",false);
  ("false and false or true",true);
  ("true or false and false",true);
  ("if true then true else false and false",true);
  ("if true then false else false or true",false);
];;


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

