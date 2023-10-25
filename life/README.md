# Game of life

This project requires to have the [ANSIterminal](https://opam.ocaml.org/packages/ANSITerminal/) package installed. Install it to your opam switch with:
```bash
opam install ANSITerminal
```

From your fork of the repository, go to the `lip/` directory and create a new project:
```bash
dune init project life
```

Then, run the following commands from the `lip/life` directory:
```
sed -i '2i   (libraries ANSITerminal)' lib/dune
```

These commands extend the dune configuration files,
to instruct the compiler to use the ocamllex and the Menhir tools.
After running these commands, the file `lib/dune` should look as follows:
```
(library
 (libraries ANSITerminal)
 (name life))
(menhir (modules parser))
(ocamllex lexer)
```

The goal of this project is to extend with a parser
an OCaml project implementing [Conway's Game of life](https://playgameoflife.com/).
The original project can be run as follows:
```bash
dune exec life n_rounds
```
where `n_rounds` can take on any positive integer (e.g. `100`).

If everything is fine, your console will display a field of asterisks
which evolves forming strange patterns.

The rule that defined the behaviour of the game is in [lib/main.ml](lib/main.ml):
```ocaml
let alive w i j =
  let (cell,nb) = neighbours w i j in
  let alive_nb = count nb in
  if cell then (* cell is alive *)
    (* cell survives? *)
    alive_nb = 2 || alive_nb = 3
  else (* cell is dead *)
    (* cell is born? *)
    alive_nb = 3
```
This function takes as input a field `w`, represented as a list of lists of bool, and two indices `i` (row) and `j` (column).
The function `alive w i j` tells the cell at index `(i,j)` is alive
in the next round.
In Conways' game of life, a cell is alive in the next round if either:
- the cell is alive in the current round, and there are 2 or 3 alive cells in its neighbours;
- the cell is dead in the current round, and there are exactly 3 alive cells in its neighbours.

The project requires to extend the game to general cellular automata
of the [Life family](http://www.mirekw.com/ca/rullex_life.html).
Each cellular automaton in this family is defined by a **S/B rule**,
i.e. a pair (S,B) of sequences of digits where:
- S are the numbers of alive neighbours necessary for an alive cell to survive
- B are the numbers of alive neighbours necessary for a dead cell to born.
For instance, Conway's Game of life is defined by the rule `S23/B3`.

The project requires you to work at the following tasks:

## Task 1

Define a type `rule` to represent rules in the S/B form, and
make the `alive` function parameteric on a S/B rule.
Its type must be:
```ocaml
alive : bool list list -> int -> int -> Life.Rule.rule -> bool
```
Modify [bin/main.ml](bin/main.ml) to pass the rule S23/3 to the `loop` function.

## Task 2

From `lip/life`, run the following to commands:
```bash
echo '(using menhir 2.1)' >> dune-project
echo -e '(menhir (modules parser))\n(ocamllex lexer)' >> lib/dune
```

Use the [Menhir](https://gallium.inria.fr/~fpottier/menhir/)
parser generator to define a syntax of S/B rules.
The obtained parser transforms strings into S/B rules,
and it is made available by the function:
```ocaml
parse : string -> Life.Rule.rule
```
Modify [bin/main.ml](bin/main.ml) to pass an additional command line argument
that specifies a S/B rule.
For instance, after this extension one can run the
Conway's Game of life as follows:
```bash
dune exec life S23/B3 100
```

## Task 3

Extend the parser to allow for **extended S/B rules**.
In extended S/B rules, digits are separated by a comma.
For instance, Conway's rule can be specified as follows:
```
ES2,3/B3
```
The S and B are optional, while the E (which distinguishes extended rules from standard rules) is not:
```
E2,3/3
```
Whitespaces can be used freely:
```
E 2,3 / 3
```
Ranges of values can be specified with the a..b notation.
For instance, the following rule states that the alive cells needed to survive
range from 0 to 5 and from 7 to 12, while died cells cannot reborn:
```
ES0..5,7..12/B
```