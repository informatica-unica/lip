open Toylexer.Main

(* read line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None
  
let () = match Array.length(Sys.argv) with
  (* read input from stdin and print list of tokens *) 
    1 -> (match read_line() with
        Some s when s<>"" -> s |> lexer |> string_of_tokenlist |> print_endline
      | _ -> print_newline())
  (* read input from stdin and print frequencies *) 
  | 3 when Sys.argv.(1)="freq"
    -> (match read_line() with
        Some s when s<>"" -> s |> lexer |> frequency (int_of_string Sys.argv.(2)) |> string_of_frequencies |> print_string
      | _ -> print_newline())
  (* wrong usage *)      
  | _ -> failwith "Usage: dune exec toylexer [freq]"
