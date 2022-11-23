open UarithexprLib.Ast
open UarithexprLib.Main

let tests = [
  ("if true then true else false and false", 1);
  ("if true then false else false or true", 0);
  ("succ 0",1);
  ("succ succ succ pred pred succ succ pred succ pred succ 0", 3);
  ("not iszero 0 or not iszero succ 0", 1);    
  ("iszero pred succ 0", 1);
  ("not iszero succ pred succ 0", 1);  
  ("iszero pred succ 0 and not iszero succ pred succ 0", 1);
  ("iszero true", 0);
  ("succ iszero 0", 2);
  ("not 0", 1);
  ("succ 0 and succ succ 0", 1);
  ("0 or succ succ 0", 1);  
  ("if succ iszero(succ 0 and succ succ 0) then true else 0", 1);  
  ("succ 0 or 0", 1);
  ("pred 0", 0);
  ("pred pred succ 0", 0);
  ("true and succ succ pred pred succ 0", 1)
]


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
       print_string (string_of_val ar);
       let b' = (ar = v) in
       if b' then print_string(" [OK]")
       else print_string (" [NO: expected " ^ string_of_val v ^ "]");
       print_newline();
       b && b')
    true
    tests


(**********************************************************************
 Test small-step semantics
 **********************************************************************)

let string_of_wval = function 
    Some v -> string_of_val v
  | _ -> "Error"

(* last element of a list *)
let rec last = function
    [] -> failwith "last on empty list"
  | [x] -> x
  | _::l -> last l

(* convert is_nv value to int *)
let rec int_of_nat = function
    Zero -> 0
  | Succ n -> 1 + int_of_nat n
  | _ -> failwith "int_of_nat on non-nat"

(* reduce expression with small-step semantics and convert into value option *)
let weval_smallstep e = match last (trace e) with
  | e when is_nv e -> Some (int_of_nat e)
  | _ -> None

let%test _ =
  print_newline();  
  print_endline ("*** Testing small-step semantics..."); 
  List.fold_left
    (fun b (s,t) ->
       print_string (s ^ " -> ");
       let ar = s |> parse |> weval_smallstep in
       print_string (string_of_wval ar);
       let b' = (ar = Some t) in
       if b' then print_string(" [OK]")
       else print_string (" [NO: expected " ^ string_of_val t ^ "]");
       print_newline();
       b && b')
    true
    tests

