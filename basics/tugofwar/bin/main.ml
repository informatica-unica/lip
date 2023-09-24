open Tugofwar
    
(* read one line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None

(* convert a string to a list of char *)

let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []

let () = match read_line () with
    Some s -> let l = toklist_of_string s in
    if valid l then print_endline (string_of_winner (win l))
    else print_endline "bad input"
  | None -> print_endline "no winner"

