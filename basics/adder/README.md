# Adder

Create a new project with the following command:
```
dune init project adder
```

Then, copy the files [bin/main.ml](bin/main.ml) and [lib/adder.ml]
in the folders `adder/bin` and `adder/lib`, respectively.

The main routine in [bin/main.ml](bin/main.ml) reads a line from the stdin.
The expected format is a sequence of integers separated by spaces, like e.g.:
```
1 2 3
```
The program converts this line into a list of integers, and then prints their sum.
The function that adds the elements of the list is partially specified in the file [lib/adder.ml]:
```ocaml
val addlist : int list -> int
```
Complete the implementation of the `addlist` function, and then test the project using `dune exec adder`.

To test the new function, you can run from the `adder` directory the command:
```
dune utop lib
```
This command enters a REPL environment. To use it, first open the Adder library:
```
open Adder;;
```
At this point, you can test the functions you have defined in the [lib/adder.ml] file.

In this case we only have one function, `addlist`:
```ocaml
addlist;;
- : int list -> int = <fun>
```
Debug your implementation in utop until it works correctly:
```ocaml
addlist [1;2;3];;
- : int = 6
```
