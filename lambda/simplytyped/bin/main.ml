open SimplytypedLib.Main
  
(* read file, and output it to a string *)

let read_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch; s

(* read line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None

(* let print_term t = print_string (string_of_term t); print_newline();; *)

let rec print_trace = function
    [] -> print_newline()
  | [x] -> print_endline (string_of_term x)
  | x::l -> print_endline (string_of_term x); print_string " -> " ; print_trace l

let print_type tau = print_endline (string_of_type tau)
;;

match Array.length(Sys.argv) with
(* typecheck / read input from stdin *)
  2 when Sys.argv.(1)="typecheck" ->
  (match read_line() with
     Some s when s<>"" -> s |> parse |> (fun t -> typecheck bot t) |> print_type
   | _ -> print_newline())  
(* trace n / read input from stdin *) 
| 2 when Sys.argv.(1)="trace" ->
  (match read_line() with
     Some s when s<>"" -> s |> parse |> (fun x -> trace x) |> print_trace
   | _ -> print_newline())
(* typecheck / read input from file *)
| 3 when Sys.argv.(1)="typecheck" ->
  (match read_file Sys.argv.(2) with
     "" -> print_newline()
   | s -> s |> parse |> (fun t -> typecheck bot t) |> print_type)  
(* trace n / read input from file *) 
| 3 when Sys.argv.(1)="trace" ->
  (match read_file Sys.argv.(3) with
     "" -> print_newline()
   | s -> s |> parse |> (fun x -> trace x) |> print_trace)
(* wrong usage *)      
| _ -> failwith "Usage: dune exec simplytyped [trace] [typecheck] [file]"
