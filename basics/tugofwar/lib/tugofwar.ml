(* tokens *)
type token = A | B | X

let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []

(* val toklist_of_string : string -> token list *)
(* toklist_of_string s transforms the string s into a list of tokens *)
(* Hint: use the function explode in bin/main.ml to convert a string to a char list *)
             
let char_to_token c = match c with
  |'A' -> A
  |'B' -> B
  |'X'
  |'=' -> X
  |_-> failwith "Token non esiste";;

let rec toklist_of_string s = 
  List.map char_to_token (explode s);;


(* val valid : token list -> bool *)
(* valid l is true when l is a list of tokens in the language A* X* B* *)
    

let rec valid l = match l with
  [] -> true
  |[A] -> false
  |[X] -> false 
  |[B] -> true
  | a :: tail -> if(a==A) then valid_A tail 
  else if(a==B) then valid_B tail else if(a==X) then valid_X tail else valid tail
and valid_A l = match l with
  [] -> false
  | a :: tail -> if(a==A) then valid_A tail else valid tail
and valid_B l = match l with
  [] -> true
  | a :: tail -> if(a==B) then valid_B tail else false
and valid_X l = match l with
  [] -> false
  | a :: tail -> if(a==X) then valid_X tail else valid tail;;

(* val win : token list -> token *)
(* win l determines the winner of a tug of war game. X means tie *)

let rec win l = match l with
  [] -> 
  | x :: tail -> if(x==A) then 
    

(* val string_of_winner : token -> string *)
let string_of_winner w = failwith "TODO"
