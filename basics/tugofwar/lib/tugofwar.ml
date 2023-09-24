(* tokens *)
type token = A | B | X

(* val toklist_of_string : string -> token list *)
(* toklist_of_string s transforms the string s into a list of tokens *)
(* Hint: use the function explode in bin/main.ml to convert a string to a char list *)
             
let toklist_of_string s = failwith "TODO"

(* val valid : token list -> bool *)
(* valid l is true when l is a list of tokens in the language A* X* B* *)
    
let valid l = failwith "TODO"

(* val win : token list -> token *)
(* win l determines the winner of a tug of war game. X means tie *)

let win l = failwith "TODO"

(* val string_of_winner : token -> string *)
let string_of_winner w = failwith "TODO"
