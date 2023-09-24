open Adder
    
(* read one line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None

(* convert a string of space-separated integers to a list of integers *)
    
let intlist_of_string s =
  List.map int_of_string (String.split_on_char ' ' s)

(* read one line from stdin, converts to a list of integers, and prints their sum *)
    
let () = match read_line () with
    Some s -> print_endline (string_of_int (addlist (intlist_of_string s)))
  | None -> print_endline "0"

