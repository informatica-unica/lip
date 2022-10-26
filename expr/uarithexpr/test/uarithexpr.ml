open UarithexprLib.Main

let tests = [
  ("if true then true else false and false", 1);
  ("if true then false else false or true", 0);
  ("succ 0",1);
  ("succ succ succ pred pred succ succ pred succ pred succ 0", 3);
  ("iszero pred succ 0", 1);
  ("iszero pred succ 0 and not iszero succ pred succ 0", 1);
  ("iszero true", 0);
  ("succ iszero 0", 2);
  ("not 0", 1);
  ("succ 0 and succ succ 0", 1);
  ("if succ iszero(succ 0 and succ succ 0) then true else 0", 1);  
  ("succ 0 or 0", 1);
  ("pred 0", 0);
  ("pred pred succ 0", 0);
  ("true and succ succ pred pred succ 0", 1)
];;

let%test _ = List.fold_left
    (fun b (s,v) ->
       print_string (s ^ " => ");
       let b' = ((s |> parse |> eval) = v) in
       print_string (string_of_val v);
       print_string (" " ^ (if b' then "[OK]" else "[NO]"));
       print_newline();
       b && b')
    true
    tests
;;
