open Toyparser.Main

let%test "test_eval_1" = parse "1 + 2 + 3 + (1 + 2)" |> eval = 9

(* YOUR TESTS HERE *)