let rec mem x = function
    [] -> false
  | y::l -> x=y || mem x l;;

let rec dup = function
    [] -> false
  | x::l -> mem x l || dup l;;
