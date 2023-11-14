open BoolexprLib.Main

let test_eval expr exp_result =
  (expr |> parse |> eval) = exp_result
  
let%test "test1" = test_eval "false" false

let%test "test2" = test_eval "true" true

let%test "test3" = test_eval "if true then false else true" false  

let%test "test4" = test_eval "if false then false else true" true

let%test "test5" = test_eval "if true then (if true then false else true) else (if true then true else false)" false

let%test "test6" = test_eval "if (if false then false else false) then (if false then true else false) else (if true then false else true)" false

let%test "test7" = test_eval "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)" false
