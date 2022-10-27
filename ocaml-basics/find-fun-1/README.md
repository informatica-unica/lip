### Exercise #3: find a function

Consider the following Ocaml snippet:
```ocaml
let rec f x y = 
  if x y = 0 then f x (y+1)
  else x y
;;
```
Find a g such that f g 0 = 3.
