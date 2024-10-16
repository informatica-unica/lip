open Types

(* Use this grammar structure as a blueprint for the exercises. *)
let todo : grammar =
  {
    symbols = [ S ];
    terminals = [ '0'; '1' ];
    productions =
      [
        S --> [ Terminal '0'; Symbol S; Terminal '0' ];
        S --> [ Terminal '1'; Symbol S; Terminal '1' ];
        S --> [];
      ];
    start = S;
  }


(* #### Exercise 1, easy (zero_n_one_n) *)
let zero_n_one_n : grammar = todo


(* #### Exercise 2, easy (word_reverse) *)
let word_reverse : grammar = todo


(* #### Exercise 3, easy (palindromes) *)
let palindromes : grammar = todo


(* #### Exercise 4, medium (balanced_parentheses)*)
let balanced_parentheses : grammar = todo


(* #### Exercise 5, hard (zero_one_same) *)
let zero_one_same : grammar = todo
