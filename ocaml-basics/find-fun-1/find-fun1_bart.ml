let rec f x y = 
  if x y = 0 then f x (y+1)
  else x y
;;

let g z = if z<3 then 0 else z;;

f g 0;;
