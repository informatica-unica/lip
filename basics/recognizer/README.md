# Regexp recognizer

This project requires to implement recognizers for the following
regular languages (expressed in Unix regexp syntax):
1. `[01]+`
2. `0?1*`
3. `0[01]*0`
4. `0*10*10*`
5. `(00|11)+`

From your fork of the repository, go to the `lip/basics` directory and create a new project with the following command:
```
dune init project recognizer
```
Executing the command will preserve the files [bin/main.ml](bin/main.ml) and [lib/recognizer.ml](lib/recognizer.ml) in the repository.

The main routine in [bin/main.ml](bin/main.ml) reads a line from the stdin,
converts it into a list of chars, and then applies the function:
```ocaml
val belongsTo : char list -> bool list
```
Applying `belongsTo` to a word `w` detects to which of the languages above the word `w` belongs.
Namely, `w` belongs to the i-th language in the list above iff the i-th element of the list
given by `belongsTo w` is true.
For instance, for the word `0010`, we have that:
```ocaml
belongsTo ['0';'0';'1';'0'] = [true; false; true; false; false]
```
Complete the implementation of the `belongsTo` function.

## Testing and debugging

Test the project using `dune exec recognizer`.
To test only the new function, you can run the following command from the `recognizer` directory:
```
dune utop lib
```
This command enters a REPL environment. To use it, first open the Recognizer library:
```
open Recognizer;;
```
or write the line in the file `recognizer/.ocamlinit`.

At this point, you can test the functions you have defined in the [lib/recognizer.ml](lib/recognizer.ml) file.

## Unit tests

This project does not include unit tests. Implement your unit tests as done in the `adder` project.

### Bonus

Is there a word that belongs to all five languages? If you believe so, prove it with a unit test:

```ocaml
let%test "" = belongsTo (* your word *) = [true;true;true;true;true]
```