open Toyparser.Main

(* read line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None
  
let () =
  match Array.length(Sys.argv) with
  (* read input from stdin, parse it, and print AST *) 
  | 1 -> begin
    match read_line() with
    | Some s when s<>"" -> 
      s |> parse |> eval |> string_of_intorerr |> print_endline
    | _ -> print_newline()
    end
  (* wrong usage *)
  | _ -> failwith "Usage: dune exec toyparser"
