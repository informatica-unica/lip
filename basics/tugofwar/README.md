# Tug of war

From the `basic` directory of your fork, create a new project with the following command:
```
dune init project tugofwar
```
The main routine in [bin/main.ml](bin/main.ml) reads a line from the stdin.
The expected format is a sequence of symbols A, B, and =, like e.g.:
```
AAAAA===BB
```
This string represents a tug of war game.
The leftmost part represents the players of the team A,
the symbols = represent the rope,
and the rightmost part represents the players of the team B.
The winner of a game is the team with the most players.

As you see from the main routine:
```ocaml
let () = match read_line () with
    Some s -> let l = toklist_of_string s in
    if valid l then print_endline (string_of_winner (win l))
    else print_endline "bad input"
  | None -> print_endline "no winner"
```
you must implement the four missing functions:
- `toklist_of_string` transforms the input string into a list of tokens A, B, X
- `valid` determines if a list of tokens is valid, i.e. it belongs to the language A\*=\*B\*
- `win` determines the winner of a game (token `A` if the winner is team A, token `B` if the winner is team B, and `X` for a tie)
- `string_of_winner` transforms a token into a string.

Hint: you can use the following function to convert a string into a list of char:
```ocaml
let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []
```

Check the file [lib/tugofwar.ml](lib/tugofwar.ml) for the signature of these functions,  
complete their implementation, and then test the project using `dune exec tugofwar`.

Recall that you can use the command:
```
dune utop lib
```
from the `tugofwar` directory to test the functions.
To use it, first open the Tugofwar library with:
```
open Tugofwar;;
```
or write the line in the file `tugofwar/.ocamlinit`.
