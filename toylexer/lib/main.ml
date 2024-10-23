open Token
    
(* tokenize : Lexing.lexbuf -> LexingLib.Token.token list *)

let rec tokenize lexbuf =
  match Lexer.read_token lexbuf with
    EOF -> [EOF]
  | t -> t::(tokenize lexbuf)

(* lexer : string -> LexingLib.Token.token list *)

let lexer (s : string) =
  let lexbuf = Lexing.from_string s in
  tokenize lexbuf

(* string_of_tokenlist : token list -> string *)
    
let string_of_tokenlist tl = 
  List.fold_left (fun s t -> s ^ (string_of_token t ^ (if t=EOF then "" else " "))) "" tl

(* string_of_frequencies : (token * int) list -> string *)
    
let string_of_frequencies fl =
  List.fold_left (fun s (t,n) -> s ^ ((string_of_token t) ^ " -> " ^ string_of_int n ^ "\n")) "" fl

(* frequency : int -> 'a list -> ('a * int) list *)
(* Funzione che conta quante volte un token appare nella lista *)
let rec conta token = function 
    [] -> 0
  | x::tail when x = token -> 1 + conta token tail
  | _::tail -> conta token tail
;;

let rec frequency n list = 
  match list with
    [] -> []  (* Caso base: lista vuota *)
  | x::tail when n>0 -> (x, conta x list) :: frequency (n-1) tail  (* Aggiungi la coppia (token, count) e continua con n-1 *)
  | _ -> []  (* Se n è zero, interrompe la ricorsione *)
;;
