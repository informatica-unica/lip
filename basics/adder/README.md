# Adder

From your fork of the repository, go to the `lip/basics` directory and create a new project with the following command:
```
dune init project adder
```
Executing the command will preserve the files [bin/main.ml](bin/main.ml) and [lib/adder.ml](lib/adder.ml)
in the folders `adder/bin` and `adder/lib`, respectively.
Check that the directory `test` does not contain a file named `adder.ml` (if so, remove it),
and ensure that the file `test/dune` is exactly as follows:
```ocaml
(library
 (name addertest)
 (inline_tests) 
 (preprocess (pps ppx_inline_test))
 (libraries adder))
```

Now, give a look at [bin/main.ml](bin/main.ml). 
The main routine reads a line from the stdin.
The expected format is a sequence of integers separated by spaces, like e.g.:
```
1 2 3
```
The program converts this line into a list of integers, and then prints their sum.
The function that adds the elements of the list is partially specified in the file [lib/adder.ml](lib/adder.ml):
```ocaml
val addlist : int list -> int
```
The first task is to complete the implementation of the `addlist` function.

## Testing and debugging 

After you have completed the previous task, you can run the project with the command `dune exec adder`.
This automatically builds the project, so you do not need to run `dune build`.

If the build gives no errors but the output is not the desired one,
you can test the `addlist` function by running the following command from the `adder` directory:
```
dune utop lib
```
This command enters a REPL environment. To use it, first open the Adder library:
```
open Adder;;
```
At this point, you can test the functions you have defined in the [lib/adder.ml](lib/adder.ml) file.
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
> [!TIP]
> Having to type `open Adder` every time you start utop can get quite annoying.
> This can be avoided by creating a file called **.ocamlinit** under [adder/](.) containing the line:
> ```
> open Adder.Main;;
> ```
> Then run utop as usual. The `Adder.Main` module will be opened for you automatically!

## Unit tests

Once you have completed the implementation, you can run some unit tests:
```
dune test
```
If you see an empty output, it means that your code has passed all the unit tests.
Try to add new tests in the file [test/addertest.ml](test/addertest.ml).

## Troubleshooting

### 1. `Error: I cannot find the root of the current workspace/project.`

Make sure you are running the commands `dune build`, `dune test` and the like from `lip/basic/adder`, the project's root folder.

### 2. I get an `Error: Module "Addertest" is used in several stanzas` after running `dune build`

Make sure the file `dune` under `adder/test` looks exactly like this:
```ocaml
(library
 (name addertest)
 (inline_tests) 
 (preprocess (pps ppx_inline_test))
 (libraries adder))
```
You may need to remove a few undesired lines that were added by `dune init`.

### 3. I get the following error after running `dune build`:
```
File "test/addertest.ml", line 3, characters 13-20:
3 | let%test _ = addlist [] = 0
                 ^^^^^^^
Error: Unbound value addlist
```
Remove `adder.ml` in `adder/test`. Make sure the structure of this folder looks exactly like this:
```
test
├── addertest.ml
└── dune
```
