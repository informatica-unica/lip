# Context-free grammars

From your fork of the repository, go to the `lip/basics` directory and create a new project with the following command:
```
dune init project contextfree
```

Executing the command will preserve predefined files in [lib/](lib/) and [test/](test/) folders. Like in previous exercises, you need to head over to [test/dune](test/dune) and ensure that its content is exactly as follows:
```ocaml
(library
 (name contextfreetest)
 (inline_tests)
 (preprocess
  (pps ppx_inline_test))
 (libraries contextfree))
```

Running `dune build` after performing this check should return silently.

## Formalizing a grammar in OCaml

Recall the informal definition of a grammar, which is the product of the following ingredients:

- a set of non-terminal symbols `V`
- a set of terminal symbols `A`
- a set of productions `P`
- a start symbol `S`

Context-free grammars can easily be formalized in OCaml with types only. We have defined these types in [lib/types.ml](lib/types.ml). Take a look at it as your read on, but do not modify it.

First, we need a few constructors to represent non-terminal symbols:
```ocaml
type symbol = A | B | S
```

The primitive type `char` represents terminal symbols:
```ocaml
type terminal = char
```

A _sentential form_ is a word made up of a mixture of terminals and non-terminals.

```ocaml
type symbol_or_terminal = NT of symbol | T of terminal

type sentential_form = symbol_or_terminal list
```

A production maps a single non-terminal symbol to a sentential form. We encode this relation with a product type:
```ocaml
type production = symbol * sentential_form
```

Now we're ready to describe a context free grammar to OCaml. We model this collection with a record type, using lists in place of sets:
```ocaml
type grammar = {
  symbols : symbol list;
  terminals : terminal list;
  productions : production list;
  start : symbol;
}
```

A grammar can generate words of a language by iteratively applying its
productions to the start symbol. This is the focus of this exercise.

## Task 1

This task requires you to add the missing definitions in the file [lib/grammar.ml](lib/grammar.ml). The first line of this file is:

```ocaml
open Types
```

It imports the types of [lib/types.ml](lib/types.ml) that we introduced earlier so that they're in scope in [lib/grammar.ml](lib/grammar.ml).

#### Exercise 1.1 (step)

Beginning with the start symbol, we can apply a production `(l,r)` of the grammar to a sentential form `s` to _derive_ a new one.

The new sentential form is obtained from `s` by  replacing the right hand side `r` of the production for _the first occurrence_ of `l` in `s`. This is called a _step_ of a derivation.

Your first job is to implement the stepping relation according to this specification:

```ocaml
val step : production -> sentential_form -> sentential_form
```

#### Exercise 1.2 (derive)

Next, define the _reflexive transitive closure_ of `step`, which performs zero or more steps following a list of productions.

```ocaml
val derive : grammar -> int list -> sentential_form
```

Productions are identified using their zero-based position in the list that is stored in the grammar record. Have a look at the sample grammar in [test/test_contextfree.ml](test/test_contextfree.ml) for a better clue.

#### Exercise 1.3 (can_step)

Finally, define a function `can_step` that checks if a sentential form still contains non-terminal symbols:

```ocaml
val can_step : sentential_form -> bool
```

For example, `0S0` can take a step, while `010` cannot.

> [!TIP]
> `dune build` has a handy "watch mode" that builds your project in real time. In the long run, this saves you a lot of typing. Open a new terminal and run it with the `-w` option:
>
>```
>dune build -w
>```
>Keep it running while you work on [lib/grammar.ml](lib/grammar.ml) and have a look at its live output one in a while.

## Task 2

Fill out the missing pieces in [test/test_contextfree.ml](test/test_contextfree.ml) to make the tests pass.

To test your solutions:
```
dune test
```

#### Exercise 2.1 (zero_n_one_n)
Define a grammar for the language `0^n1^n` (that is, `n` repetitions of the letter 0 followed by `n` repetitions of 1, for any `n`). Derive the following words: the empty word, `01`, `0^(10)1^(10)`.

#### Exercise 2.2 (zero_one_same)
Define a grammar for the language whose words have as many 0's as 1's. Derive the following words: empty, `1001`, `00110101`, `10001110`.


