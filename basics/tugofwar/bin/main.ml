open Tugofwar
    
(* read one line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None

let () = match read_line () with
    Some s -> let l = toklist_of_string s in
    if valid l then print_endline (string_of_winner (win l))
    else print_endline "bad input"
  | None -> print_endline "no winner"

