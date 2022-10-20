open AndboolexprLib.Main
  
let tests = [
  ("false",false);
  ("if true then false else true",false);
  ("if true then (if true then false else true) else (if true then true else false)",false);
  ("if (if false then false else false) then (if false then true else false) else (if true then false else true)",false);
  ("if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)",false);
  ("not true or true",true);
  ("not true and false",false);
  ("false and false or true",true);
  ("true or false and false",true);
  ("if true then true else false and false",true);
  ("if true then false else false or true",false)  
]

let%test _ = List.fold_left
    (fun b (s,v) ->
       print_string (s ^ " => ");
       let b' = ((s |> parse |> eval) = v) in
       print_string (string_of_bool v);
       print_string (" " ^ (if b' then "[OK]" else "[NO]"));
       print_newline();
       b && b')
    true
    tests
