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
  let unique lst = List.fold_left(fun acc x -> if List.mem x acc then acc else acc @ [x]) [] lst
  in
  let unique_tokens = unique lst in
  let counted = List.map (fun token ->
    let count = List.length (List.filter (fun x -> x = token) lst) in
    (token, count)
  ) unique_tokens in
  
  let sorted = List.sort (fun (_, n1) (_, n2) ->
    compare n2 n1
  ) counted in
  let take n lst = fst (List.fold_left(fun (acc,count) x -> if count < n then (acc @ [x],count+1) else (acc,count)) ([],0) lst) in
  take n sorted  
;;
  
