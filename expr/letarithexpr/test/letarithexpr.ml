open LetarithexprLib.Main

(* wrapping results for testing *)

type wexprval = Ok of exprval | Error

let string_of_wval = function 
    Ok v -> string_of_val v
  | _ -> "Error"

let weval e = try Ok (eval e)
  with _ -> Error
;;
  
let tests = [
  ("if true then true else false and false",Bool true);
  ("if true then false else false or true",Bool false);
  ("succ 0",Nat 1);
  ("succ succ succ pred pred succ succ pred succ pred succ 0", Nat 3);
  ("iszero pred succ 0", Bool true);
  ("iszero pred succ 0 and not iszero succ pred succ 0", Bool true);
  ("let x = 0 in succ x", Nat 1);
  ("let x = 0 in let y = succ x in succ y", Nat 2);
  ("let x = 0 in let x = succ 0 in succ x", Nat 2);
  ("let x = false in ((let x = true in x) or x)", Bool true);
  ("let x = false in x or let x = true in x", Bool true);  
  ("let x = true in x and let x = false in x", Bool false);
  ("let x = (let x = true in x) and false in x", Bool false);    
]

let oktests = List.map (fun (x,y) -> (x,Ok y)) tests;;

let errtests = [
  ("iszero true", Error);
  ("succ iszero 0", Error);
  ("not 0", Error);
  ("pred 0", Error);
  ("pred pred succ 0", Error)
]

(* test big-step *)

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


(* test small-step *)

let weval_smallstep e = match eval_smallstep e with
    None -> Error
  | Some v -> Ok v
;;

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
