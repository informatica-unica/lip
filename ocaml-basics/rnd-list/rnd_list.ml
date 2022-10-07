let rec rnd_list n b = match n with
  0 -> []
  | _ -> (Random.int b)::(rnd_list (n-1) b);;