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
        S --> "1"; (* 2 *)
        S --> "0"; (* 3 *)
        S --> ""; (* 4 *)
      ];
    start = S;
  }


(* #### Exercise 3, medium (balanced_parentheses)*)
let balanced_parentheses : grammar = 
  {
    symbols = [ S ];
    terminals = [ '('; ')'; '[' ; ']'; '{' ; '}' ];
    productions =
      [
        S --> ""; (* 0 *)
        S --> "()S"; (* 1 *)
        S --> "[]S"; (* 2 *)
        S --> "{}S"; (* 3 *)
        S --> "(S)"; (* 4 *)
        S --> "[S]"; (* 5 *)
        S --> "{S}"; (* 6 *)
        S --> "S()"; (* 7 *)
        S --> "S[]"; (* 8 *)
        S --> "S{}"; (* 9 *)
      ];
    start = S;
  }


(* #### Exercise 4, hard (same_amount)

   Hint 1: you can use 'a' and 'b' for terminals.
   Hint 2: think of the language of words where the number of 0s is one greater
   than the number of 1s and viceversa, then combine them.
*)
let same_amount : grammar = 
  {
    symbols = [ S ];
    terminals = [ '0'; '1'];
    productions =
      [
        S --> ""; (* 0 *)
        S --> "0011S"; (* 1 *)
        S --> "1100S"; (* 2 *)
        S --> "01S"; (* 3 *)
        S --> "10S"; (* 4 *)
        S --> "0S1"; (* 5 *)
        S --> "1S0"; (* 6 *)
      ];
    start = S;
  }
