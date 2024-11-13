open BoolexprLib.Main

let test_eval expr exp_result =
  (expr |> parse |> eval) = exp_result

(* ADD YOUR TESTS HERE FOR TASK 4 *)

let%test "test_eval_1" = failwith "TODO"
