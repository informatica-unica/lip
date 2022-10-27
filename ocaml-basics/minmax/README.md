# Min and max of a function

Write a function with the following type:
```ocaml
val minmax : (int -> 'a) -> int -> int -> 'a * 'a = <fun>
```
When fed with a function `f: int -> int` and two integers a,b
such that a<=b, the expression `minmax f a b` evaluates to a pair
(min,max), where min and max are, respectively,
the minimum and the maximum of f in the range [a,b].
