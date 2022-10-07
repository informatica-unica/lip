let rec string_of_list_tail l = match l with 
    [] -> ""
  | x::l' -> ";" ^ string_of_int x ^ string_of_list_tail l';;

let rec string_of_list l = match l with 
    [] -> "[]"
  | x::l' -> "[" ^ string_of_int x ^ string_of_list_tail l' ^ "]";; 