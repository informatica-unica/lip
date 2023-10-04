# Adder

From your fork of the repository, go to the `lip/basics` directory and create a new project with the following command:
```
dune init project adder
```
Executing the command will preserve the the files [bin/main.ml](bin/main.ml) and [lib/adder.ml](lib/adder.ml)
in the folders `adder/bin` and `adder/lib`, respectively.

Now, give a look at [bin/main.ml](bin/main.ml). 
The main routine reads a line from the stdin.
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

Digiting `open Adder` each time one starts utop could be quite boring.
This can be avoided by creating a file `adder/.ocamlinit` containing the line:
```
open Adder.Main;;
```

Once you have completed the implementation, you can run some unit tests:
```
dune test
```
If you see an empty output, it means that your code has passed all the unit tests.
