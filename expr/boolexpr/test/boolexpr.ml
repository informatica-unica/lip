open BoolexprLib.Main

let test_eval expr exp_result =
  (expr |> parse |> eval) = exp_result

(* ### Unit tests for task 4 *)

let%test "test_eval_1" = failwith "TODO"

(* ### Unit tests for task 5 *)

let%test "test_trace1_1" = failwith "TODO"
