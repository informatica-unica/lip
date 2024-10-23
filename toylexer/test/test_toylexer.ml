open Toylexer.Token
open Toylexer.Main

let%test "test_frequencies_1" =
  lexer "x=1; y=x+1" |> frequency 3 = [(ID "x", 3); (ASSIGN, 2); (ID "y", 1)]

(* YOUR TESTS HERE *)