open Types

(* Use this grammar structure as a blueprint for the exercises. *)
let todo : grammar =
  {
    symbols = [ S ];
    terminals = [ '0'; '1' ];
    productions =
      [
        S --> "0S0"; (* 0 *)
        S --> "1S1"; (* 1 *)
        S --> ""; (* 2 *)
      ];
    start = S;
  }


(* #### Exercise 1, easy (zero_n_one_n) *)
let zero_n_one_n : grammar = 
  {
    symbols = [ S ];
    terminals = [ '0'; '1'];
    productions =
      [
        S --> "";
        S --> "0S1";
      ];
    start = S;
  }


(* #### Exercise 2, easy (palindromes) *)
let palindromes : grammar = 
  {
    symbols = [ S ];
    terminals = [ '0'; '1' ];
    productions =
      [
        S --> "0S0"; (* 0 *)
        S --> "1S1"; (* 1 *)
        S --> ""; (* 2 *)
      ];
    start = S;
  }


(* #### Exercise 3, medium (balanced_parentheses)*)
let balanced_parentheses : grammar = todo


(* #### Exercise 4, hard (same_amount)

   Hint 1: you can use 'a' and 'b' for terminals.
   Hint 2: think of the language of words where the number of 0s is one greater
   than the number of 1s and viceversa, then combine them.
*)
let same_amount : grammar = todo
