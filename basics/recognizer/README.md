# Regular expressions recognizer

This project requires to implement recognizers for the following
regular languages (expressed in Unix regexp syntax):
1. 0?1*
2. 0[01]*0
3. [01]*0[01]{2}
4. 0*10*10*10*
5. (00+11)+

Create a new project with the following command:
```
dune init project recognizer
```

The main routine in [bin/main.ml](bin/main.ml) reads a line from the stdin.
The expected format is a sequence of symbols 0 and 1, like e.g.:
```
0100
```
The main routing converts this line into a list of chars,
and then applies the function:
```ocaml
val belongsTo : char list -> bool list
```
Applying `belongsTo` to a word `w` detects to which of the languages above
the word `w` belongs.
For instance, for the word `01001`, we have that
```ocaml
belongsTo [0;0;1;0] = [false;true;true;false;false]
```

Complete the implementation of the `belongsTo` function,
and then test the project using `dune exec recognizer`.

To test the new function, you can run from the `recognizer` directory
the command:
```
dune utop lib
```
This command enters a REPL environment. To use it, first open the Recognizer library:
```
open Recognizer;;
```
At this point, you can test the functions you have defined in the [lib/recognizer.ml] file.

Recall to create a file `recognizer/.ocamlinit` containing the line:
```
open Recognizer.Main;;
```
