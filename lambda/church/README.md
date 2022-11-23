# Normal order semantics and combinators

Extend the [pure untyped lambda calculus](../untyped) with the following combinators:

**Identity and Omega**
```
id = fun x. x
omega = fun x. x x
```

**Church booleans**

```
tru = fun t. fun f. t
fls = fun t. fun t. f
and = fun b. fun c. b c fls
ift = fun l. fun m. fun n. l m n
```

**Pairs**
```
pair = fun f. fun s. fun b. b f s
fst = fun p. p tru
snd = fun p. p fls
```

**Church numerals**
```
0 = fun s. fun z. z
1 = fun s. fun z. s z
2 = fun s. fun z. s (s z)
3 = fun s. fun z. s (s (s z))
...
```

**Operators on Church numerals**
```
scc = fun n. fun s. fun z. s (n s z)
add = fun m. fun n. fun s. fun z. m s (n s z)
```

## Lexer and parser

The lexer and the parser must be extended to include the combinators.
For instance, via `dune utop lib` you must obtain:
```ocaml
open ChurchLib.Ast;;
open ChurchLib.Main;;

"scc 1" |> parse;;
- : term =
App(
 Abs ("n", Abs ("s", Abs ("z", App (Var "s", App (App (Var "n", Var "s"), Var "z"))))),
 Abs ("s", Abs ("z", App (Var "s", Var "z"))))
 ```

## Pretty-printing

Extend the pretty-printer function `string_of_term` to produce combinator names whenever possible.
For instance, via `dune utop lib` we expect to obtain:
```ocaml
"scc 1" |> parse |> string_of_term;;
- : string = "scc (1)"
```

## Small-step semantics

Implement the **normal order** evaluation strategy, which reduces first the outermost leftmost redex.
This strategy is defined by the following rules, which are processed in order:
```
t -> t'
--------------------- [NO-Abs]
fun x. t -> fun x. t'

------------------------------ [NO-AppAbs]
(fun x. t1) t2 -> [x -> t2] t1

t1 -> t1'
--------------- [NO-App1]
t1 t2 -> t1' t2

t2 -> t2' 
--------------- [NO-App2]
t1 t2 -> t1 t2'
```
