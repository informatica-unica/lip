let g x = x + 3;; 

let rec f x y = 
  if x y = 0 then f x (y+1)
  else x y;;

assert (f g 0 = 3);;