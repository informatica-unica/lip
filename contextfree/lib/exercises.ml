open Types

(* Use this grammar structure as a blueprint for the exercises. *)
let todo : grammar =
  {
    symbols = [ S ];
    terminals = [ '0'; '1' ];
    productions =
      [
        S --> "0S0";
        S --> "1S1";
        S --> "";
      ];
    start = S;
  }


(* #### Exercise 1, easy (a_n_b_n) *)
let a_n_b_n : grammar = todo


(* #### Exercise 2, easy (word_reverse) *)
let word_reverse : grammar = todo


(* #### Exercise 3, easy (palindromes) *)
let palindromes : grammar = todo


(* #### Exercise 4, medium (balanced_parentheses)*)
let balanced_parentheses : grammar = todo


(* #### Exercise 5, hard (same_amount)
   Hint: this time, use 'a' and 'b' for terminals.
*)
let same_amount : grammar = todo
