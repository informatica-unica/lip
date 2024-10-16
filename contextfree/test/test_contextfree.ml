open Contextfree
open Types
open Grammar
open Exercises

let to_string = string_of_sentform

(** Complete the tests below.
    For each test, provide the right sequence of
    productions to generate the word on the right of the "=". *)

(* #### Exercise 1 *)
let%test "zero_n_one_n_1" = derive zero_n_one_n [ 0 ] |> to_string = ""
let%test "zero_n_one_n_2" = derive zero_n_one_n [ 1;0 ] |> to_string = "01"
let%test "zero_n_one_n_3" = derive zero_n_one_n [ 1;1;1;1;1;1;1;1;1;1;0] |> to_string = "00000000001111111111"

(* #### Exercise 2 *)
let%test "palindromes_1" = derive palindromes [ 1;1;3 ] |> to_string = "11011"
let%test "palindromes_2" = derive palindromes [ 0;1;4 ] |> to_string = "0110"
let%test "palindromes_3" = derive palindromes [0;1;1;1;3 ] |> to_string = "011101110"

(* #### Exercise 3 *)
let%test "balanced_parentheses_1" = derive balanced_parentheses [ 1;2;3;0 ] |> to_string = "()[]{}"
let%test "balanced_parentheses_2" = derive balanced_parentheses [ 8;4;6;0 ] |> to_string = "({})[]"
let%test "balanced_parentheses_3" = derive balanced_parentheses [ 4;6;2;5;3;4;0 ] |> to_string = "({[][{}()]})"

(* #### Exercise 4 *)
let%test "zero_one_same_1" = derive same_amount [ 0 ] |> to_string = ""
let%test "zero_one_same_2" = derive same_amount [ 4;3;0 ] |> to_string = "1001"
let%test "zero_one_same_3" = derive same_amount [ 1;3;3;0 ] |> to_string = "00110101"
let%test "zero_one_same_4" = derive same_amount [ 4;4;3;4;0 ] |> to_string = "10100110"
let%test "zero_one_same_5" = derive same_amount [ 5;5;3;4;0 ] |> to_string = "00011011"
let%test "zero_one_same_6" = derive same_amount [ 5;5;4;5;5;1;4;0 ] |> to_string = "0010000011101111"