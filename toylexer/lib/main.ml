open Token
    
(* tokenize : Lexing.lexbuf -> LexingLib.Token.token list *)

(* ocamllex lexer.mll per far funzionare ...Lexer.read_token... *)

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
(* frequency : int -> 'a list -> ('a * int) list *)

(* Funzione ausiliaria per contare le occorrenze dei token *)
let rec conta_occorrenze_singolo token list =
  List.fold_left (fun counter current -> if current = token then counter + 1 else counter) 0 list

(* Funzione principale *)
and frequency n tokens =

  (* Rimuove i duplicati e crea una lista di token unici *)
  let unique_tokens = List.sort_uniq compare tokens in

  (* Crea una lista di coppie (token, numero_di_occorrenze) *)
  let token_counts = List.map (fun current -> (current, conta_occorrenze_singolo current tokens)) unique_tokens in

  (* Ordina la lista in ordine decrescente in base al numero di occorrenze *) 
  let sorted_token_counts = List.sort (fun (_, c1) (_, c2) -> compare c2 c1) token_counts in

  (* Restituisce i primi n elementi della lista *)
  List.filteri (fun i _ -> i < n) sorted_token_counts
;;
