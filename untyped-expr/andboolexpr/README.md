# Boolean expressions with not, and, or

Extend the language of boolean expressions with connectives:
- **not e**, the logical negation of e;
- **e1 and e2**, the conjunction between e1 and e2;
- **e1 or e2**, the disjunction between e1 and e2.

You should take care of assigning the right [priority and associativity](http://gallium.inria.fr/~fpottier/menhir/manual.html#sec12) 
to the new connectives, to make their semantics coherent with that of the corresponding OCaml operators. 

In particular, `not` has higher priority than `and`, which in turn has higher priority than `or`.
For instance:
- `not true or true` must evaluate to `true`;
- `not true and false` must evaluate to `false`;
- `false and false or true` must evaluate to `true`;
- `true or false or false` must evaluate to `true`.

Furthermore, we want the if-then-else construct have lower priority over the other connectives. For instance:
- `if true then true else false and false` must evaluate to `true`;
- `if true then false else false or true`  must evaluate to `false`.
