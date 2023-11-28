open BlocksLib.Types
open BlocksLib.Prettyprint
open BlocksLib.Main
       
(* read file, and output it to a string *)

let read_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch; s

(* read line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None

(* print a trace *)

let print_trace = function
  | Cmd(c,s)::l -> print_endline (string_of_trace (vars_of_cmd c) (Cmd(c,s)::l))
  | _ -> failwith "print_trace on empty trace"
;;


match Array.length(Sys.argv) with
(* trace n / read input from stdin *) 
  2 -> (let n = int_of_string (Sys.argv.(1)) in
        match read_line() with
          Some s when s<>"" -> s |> parse |> (fun x -> trace n x) |> print_trace
        | _ -> print_newline())
(* trace1 / read input from file *) 
| 3 -> (let n = int_of_string (Sys.argv.(1)) in
        match read_file Sys.argv.(2) with
          "" -> print_newline()
        | s -> s |> parse |> (fun x -> trace n x) |> print_trace)
(* wrong usage *)      
| _ -> failwith "Usage: dune exec blocks n_steps [file]"
