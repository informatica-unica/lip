let max x y = if x > y then x else y;;

let max_nat x y = if x>=0 && y>=0 then max x y else failwith"Numeri non naturali";;