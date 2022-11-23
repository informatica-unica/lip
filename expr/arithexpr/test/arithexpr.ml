open ArithexprLib.Ast
open ArithexprLib.Main

type wexprval = exprval option

let string_of_wval = function 
    Some v -> string_of_val v
  | _ -> "Error"

let weval e = try Some (eval e)
  with _ -> None

let tests = [
  ("if true then true else false and false",Bool true);
  ("if true then false else false or true",Bool false);
  ("succ 0",Nat 1);
  ("succ succ succ pred pred succ succ pred succ pred succ 0", Nat 3);
  ("iszero pred succ 0", Bool true);
  ("iszero pred succ 0 and not iszero succ pred succ 0", Bool true);
]

let oktests = List.map (fun (x,y) -> (x,Some y)) tests;;

let errtests = [
  ("iszero true", None);
  ("succ iszero 0", None);
  ("not 0", None);
  ("pred 0", None);
  ("pred pred succ 0", None)
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
       let ar = s |> parse |> weval in
       print_string (string_of_wval ar);       
       let b' = (ar = v) in
       if b' then print_string(" [OK]")
       else print_string (" [NO: expected " ^ string_of_wval v ^ "]");     
       print_newline();
       b && b')
    true
    (oktests @ errtests)


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

let%test _ =
  print_newline();  
  print_endline ("*** Testing small-step semantics...");
  List.fold_left
    (fun b (s,v) ->
       print_string (s ^ " -> ");       
       let ar = s |> parse |> weval_smallstep in
       print_string (string_of_wval ar);
       let b' = (ar = v) in
       if b' then print_string(" [OK]")
       else print_string (" [NO: expected " ^ string_of_wval v ^ "]");
       print_newline();
       b && b')
    true
    (oktests @ errtests)
