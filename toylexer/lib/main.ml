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
let frequency n lst =
  if n = 0 then failwith "error" else
  (* Creiamo una lista di token unici mantenendo l'ordine originale *)
  let rec unique lst acc = 
    match lst with
    | [] -> List.rev acc
    | x :: xs ->
        if List.mem x acc then unique xs acc
        else unique xs (x :: acc)
  in
  
  let unique_tokens = unique lst [] in

  (* Conta le occorrenze di ogni token *)
  let counted = List.map (fun token ->
    let count = List.length (List.filter (fun x -> x = token) lst) in
    (token, count)
  ) unique_tokens in
  
  (* Ordina in base al numero di occorrenze in ordine decrescente *)
  let sorted = List.sort (fun (_, n1) (_, n2) ->
    compare n2 n1
  ) counted in
  
  (* Funzione take per raccogliere i primi n elementi *)
  let take n lst =
    let rec aux acc count = function
      | [] -> acc
      | x :: xs ->
          if count < n then aux (acc @ [x]) (count + 1) xs  (* Accumula i primi n elementi *)
          else acc
    in
    aux [] 0 lst
  in

  take n sorted  (* Restituisci solo i primi n elementi *)
;;
  
