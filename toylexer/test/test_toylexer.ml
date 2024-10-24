open Toylexer.Token
open Toylexer.Main

let%test "test_frequencies_1" =
  lexer "x=1; y=x+1" |> frequency 3 = [(ID "x", 2); (ASSIGN, 2); (CONST "1", 2)]

(* YOUR TESTS HERE *)
let%test "test_frequencies_2" =
  lexer "x+y=3; (y+2+x+5)+2=2" |> frequency 5 = [(PLUS, 5);(CONST "2", 3); (ID "x", 2); (ID "y", 2); (ASSIGN, 2)]