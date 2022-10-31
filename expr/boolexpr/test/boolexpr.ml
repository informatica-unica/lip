open BoolexprLib.Main

let tests = [
  ("false",false);
  ("true",true);
  ("if true then false else true",true);  
  ("if false then false else true",true);
  ("if true then (if true then false else true) else (if true then true else false)",false);
  ("if (if false then false else false) then (if false then true else false) else (if true then false else true)",false);
  ("if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)",false)
];;

let%test _ = List.fold_left
    (fun b (s,v) ->
       print_string (s ^ " => ");
       let b' = ((s |> parse |> eval) = v) in
       print_string (string_of_bool v);
       print_string (" " ^ (if b' then "[OK]" else "[NO: expected " ^ string_of_bool b' ^ "]"));
       print_newline();
       b && b')
    true
    tests
