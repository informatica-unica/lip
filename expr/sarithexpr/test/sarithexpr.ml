open SarithexprLib.Main

type wexprval = exprtype option

let string_of_wtype = function 
    Some t -> string_of_type t
  | _ -> "Error"

let wtypecheck e = try Some (typecheck e) 
  with _ -> None
  
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
]

let oktests = List.map (fun (x,y) -> (x,Some y)) tests;;

let errtests = [
  ("iszero true", None);
  ("succ iszero 0", None);
  ("not 0", None);
  ("if 0 then true else false",None);
  ("if succ 0 then true else false",None);
  ("if iszero 0 then true else 0",None);
  ("if iszero 0 then 0 else true",None);
  ("iszero 0 and succ 0",None);
  ("succ 0 and iszero 0",None);
  ("iszero 0 or succ 0",None);
  ("succ 0 or iszero 0",None);
]


(**********************************************************************
 Test type checker
 **********************************************************************)

let%test _ = List.fold_left
    (fun b (s,t) ->
       print_string (s ^ " : ");
       let ar = s |> parse |> wtypecheck in
       print_string (string_of_wtype ar);
       let b' = (ar = t) in
       if b' then print_string(" [OK]")
       else print_string (" [NO: expected " ^ string_of_wtype t ^ "]");
       print_newline();
       b && b')
    true
    (oktests @ errtests)



       
