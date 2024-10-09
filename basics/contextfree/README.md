# Context-free

From your fork of the repository, go to the `lip/basics` directory and create a new project with the following command:
```
dune init project contextfree
```

Context-free grammars can easily be encoded in OCaml with types only.

First, we need a few constructors to represents non-terminal symbols:

```ocaml
type symbol = A | B | S
```

The primitive type `char` represents terminal symbols:

```ocaml
type terminal = char
```

A sentential form is a word made up of a mixture of terminals and non-terminals.

```ocaml
type symbol_or_terminal = NT of symbol | T of terminal

type sentential_form = symbol_or_terminal list
```

A production maps a single non-terminal symbol to a sentence. We encode this relation with a product type:

```ocaml
type production = symbol * sentential_form
```

Now we're ready to describe a context free grammar to OCaml. Recall that a grammar at its core comprises:

- a set of non-terminal symbols $V$
- a set of terminal symbols $A$
- a set of productions $P$
- a start symbol $S$

We model this collection with a record type, using lists in place of sets:

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

Beginning with the start symbol, we can apply a production `(l,r)` of the grammar to a sentential form `s` to _derive_ a new one.

The new sentential form is obtained from `s` by  replacing the right hand side of the production, `r`, for _the first occurrence_ of `l` in `s`. This is called a step of a derivation.

Your first job is to implement the stepping relation according to this specification:

```
val step : production -> sentential_form -> sentential_form
```

Then, define the _reflexive transitive closure_ of `step`, which performs zero or more steps following a list of productions.

```ocaml
val derive : grammar -> int list -> sentence
```

Productions are identified using their zero-based position in the list that is stored in the grammar record. Have a look at the sample grammar in [test/test_contextfree.ml](test/test_contextfree.ml).ml for more clues.

Finally, define a function `can_step` that checks if a sentential form still contains non-terminal symbols:

```ocaml
val can_step : sentential_form -> bool
```

For example, `0S0` can take a step, while `010` cannot.

## Task 2

Fill in the following grammars in [test/test_contextfree.ml](test/test_contextfree.ml):

1. Define a grammar for the language $0^n1^n$, and derive the following words: the empty word, $01$, $0^{10}1^{10}$.

2. Define a grammar for the language whose words have as many 0's as 1's. Derive the following words: empty, $1001$, $00110101$, $10001110$. 