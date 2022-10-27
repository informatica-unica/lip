let rec minfun f a b = 
  if a>b then None
  else match minfun f (a+1) b with
      None -> Some (f a)
    | Some n -> if (f a) < n then Some (f a) else Some n
;;
