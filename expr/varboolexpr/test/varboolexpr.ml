open VarboolexprLib.Main

(* wrapping results for testing *)

type wexprval = Ok of bool | Error

let string_of_wval = function 
    Ok b -> string_of_bool b
  | _ -> "Error"

let weval (d,e) = try Ok (eval (d,e)) 
  with _ -> Error
;;

let tests = [
  ("if true then true else false and false",true);
  ("if true then false else false or true",false);
  ("let x=true in x",true);
  ("let x=true in x or false and false",true);
  ("let x=true; y=false in x or y",true);
  ("let x=not true; y=not false in x or y",true);
  ("let x=if true then false else true; y=not false; z=not true in if x then y else z",false)
];;

let oktests = List.map (fun (x,y) -> (x,Ok y)) tests;;

let errtests = [
  ("let x=false; y=true or x in y", Error);
  ("let x=true ; y=false in x and z", Error);
  ("let x=true ; x=false in x", Error)
];;

let%test _ = List.fold_left
    (fun b (s,v) ->
       print_string (s ^ " => ");
       let b' = ((s |> parse |> weval) = v) in
       print_string (string_of_wval v);
       print_string (" " ^ (if b' then "[OK]" else "[NO]"));
       print_newline();
       b && b')
    true
    (oktests @ errtests)
