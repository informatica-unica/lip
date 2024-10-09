open Contextfree
open Types
open Grammar

(* The palindromes of even length over {0,1} *)
let g1 =
  {
    symbols = [ S ];
    terminals = [ '0'; '1' ];
    productions =
      [
        (* S -> 0S0 *)
        (S, [ T '0'; NT S; T '0' ]);
        (* S -> 1S1 *)
        (S, [ T '1'; NT S; T '1' ]);
        (* S -> empty *)
        (S, []);
      ];
    start = S;
  }

let%test "step_g1_example" =
  [ NT S ] |> step_g g1 0 |> step_g g1 1 |> step_g g1 2
    |> string_of_sentform = "011110"


(* #### Exercise 2.1 *)
let zero_n_one_n : grammar = failwith "todo"

let%test "zero_n_one_n_1" = (* REMOVE '[]' AND FILL IN HERE *) [] |> string_of_sentform = ""
let%test "zero_n_one_n_2" = (* FILL IN HERE *) [] |> string_of_sentform = "01"
let%test "zero_n_one_n_3" = (* FILL IN HERE *) [] |> string_of_sentform = "00000000001111111111"


(* #### Exercise 2.2 *)
let zero_one_same : grammar = failwith "todo"

let%test "zero_one_same_1" = (* FILL IN HERE *) [] |> string_of_sentform = ""
let%test "zero_one_same_2" = (* FILL IN HERE *) [] |> string_of_sentform = "1001"
let%test "zero_one_same_3" = (* FILL IN HERE *) [] |> string_of_sentform = "00110101"
let%test "zero_one_same_4" = (* FILL IN HERE *) [] |> string_of_sentform = "10001110"