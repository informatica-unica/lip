# Minimum of a function

Recall the built-in option type:
```ocaml
type 'a option = Some of 'a | None
```

Write a function with the following type:
```ocaml
val minfun : (int -> 'a) -> int -> int -> 'a option = <fun>
```
such that ``minfun f a b`` computes the minimum of f in the range [a,b].
If the range is empty, then the function evaluates to ``None``.
