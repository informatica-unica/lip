let f g = if g 0 > 1 then 2 else 3;;

f (fun x -> x+1);;
