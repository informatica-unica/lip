open SarithexprLib.Main

type wexprval = Ok of exprtype | Error

let string_of_wtype = function 
    Ok t -> string_of_type t
  | _ -> "Error"

let wtypecheck e = try Ok (typecheck e) 
  with _ -> Error
;;
  
let tests = [
  ("if true then true else false and false",BoolT);
  ("if true then false else false or true",BoolT);
  ("if iszero 0 then iszero succ 0 else false or true",BoolT);  
  ("succ 0",NatT);
  ("succ succ succ pred pred succ succ pred succ pred succ 0",NatT);
  ("iszero pred succ 0",BoolT);
  ("iszero pred succ 0 and not iszero succ pred succ 0",BoolT); 
  ("pred 0", NatT);
  ("pred pred succ 0", NatT); 
];;

let oktests = List.map (fun (x,y) -> (x,Ok y)) tests;;

let errtests = [
  ("iszero true", Error);
  ("succ iszero 0", Error);
  ("not 0", Error);
  ("if 0 then true else false",Error);
  ("if succ 0 then true else false",Error);
  ("if iszero 0 then true else 0",Error);
  ("if iszero 0 then 0 else true",Error);
  ("iszero 0 and succ 0",Error);
  ("succ 0 and iszero 0",Error);
  ("iszero 0 or succ 0",Error);
  ("succ 0 or iszero 0",Error);
];;

let%test _ = List.fold_left
    (fun b (s,t) ->
       print_string (s ^ " => ");
       let b' = ((s |> parse |> wtypecheck) = t) in
       print_string (string_of_wtype t);
       print_string (" " ^ (if b' then "[OK]" else "[NO]"));
       print_newline();
       b && b')
    true
    (oktests @ errtests)
