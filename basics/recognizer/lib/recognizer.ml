(* L1 = [01]+*)
let lang1 chars =
  let rec aux lst =
    match lst with
    | [] -> true  (* Se la lista è vuota, non è valida *)
    | h :: t -> if h = '0' || h = '1' then aux t else false
  in
  aux chars;;

(*L2 = 0?1* *)
let lang2 chars =
  let rec aux lst flgZero =
     match lst with
    | [] -> true
    | h::t when h = '0' && flgZero = false -> aux t true
    | h::t when h = '1' && flgZero = true -> aux t flgZero
    | _::_ -> false
  in aux chars false
;;
(*L3 = 0[01]*0  *)
let lang3 chars = 
  let rec aux lst first=
    match lst with
    | [] -> false
    | x::[] -> if x = '0' then true else false 
    | '1'::_ when first = true -> false
    | '0'::l when first = true -> aux l false
    | x::l when x = '0' || x = '1' -> aux l first
    | _::_ -> false 
  in aux chars true
;;

(* L4 = 0*10*10* *)
let lang4 chars = 
  let rec aux lst count1 =
  match lst with
  [] -> count1 == 2
  | x::l when x = '0' || x = '1' -> aux l  (if x = '1' then count1 +1 else count1)
  | _ ::_ -> false
  in aux chars 0
;;

(* L5 = (00|11)+ *)
let lang5 chars = 
  let rec aux lst = 
    match lst with
    | [] -> true
    | x::y::l when x = y && (x = '0' || x = '1') -> aux l
    | x::y::_ when x != y -> false
    | _::_ -> false
in aux chars;;
    
let recognizers = [lang1;lang2;lang3;lang4;lang5]
                  
let belongsTo w = List.map (fun f -> f w) recognizers
  
