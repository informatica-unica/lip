open Toylexer.Token
open Toylexer.Main

let%test "test_frequencies_1" =
  lexer "x=1; y=x+1" |> frequency 3 = [(ID "x", 3); (ASSIGN, 2); (ID "y", 1)] ;;

(* YOUR TESTS HERE *)

let%test "test_freq_2" =
  lexer "x=y; x=x+1" |> frequency 2 = [(ID "x", 3); (ASSIGN, 2)];;

let%test "test_token" =
  lexer "Abc123" = [ATOK "Abc123"; EOF];;

let%test "test_token_2" =
  lexer "aeiou+1" = [BTOK "aeiou"; PLUS; CONST "1"; EOF];;

let%test "test_token_3" =
  lexer "fgaB=0x4" = [CTOK "fgaB"; ASSIGN; ETOK "0x4" ;EOF];;
