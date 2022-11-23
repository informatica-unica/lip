let compare_posfrac (a1,b1) (a2,b2) =
  assert (a1>=0 && b1>0 && a2>=0 && b2>0);
  let l = a1 * b2 and r = a2 * b1 in
  if l=r then 0
  else if l>r then 1
  else -1;;

compare_posfrac (1,2) (2,1);;

assert (compare_posfrac (1,2) (2,4) == 0);;
assert (compare_posfrac (1,2) (1,3) == 1);;
assert (compare_posfrac (1,2) (2,3) == -1);;
