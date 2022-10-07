let rec isIn n l = match l with
  [] -> false
| x::l' -> if x = n then true else isIn n l';;

let rec dup l = match l with
  [] -> false
| x::l' -> if isIn x l' then true else dup l';;