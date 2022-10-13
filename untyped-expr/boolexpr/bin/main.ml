open BoolexprLib.Main
  
(* read file, and output it to a string *)

let read_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch; s
;;

(* read line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None
;;

(* print a bool *)

let print_bool b =
  print_string (if b then "true" else "false"); print_newline()
;;

(* print a trace *)

let rec print_trace = function
    [] -> print_newline()
  | [x] -> print_endline (string_of_boolexpr x)
  | x::l -> print_endline (string_of_boolexpr x); print_string " -> " ; print_trace l
;;

match Array.length(Sys.argv) with
  1 ->
  let s_exp = (match read_line() with Some s -> s | _ -> "")
  in parse s_exp |> eval |> print_bool
| 2 when Sys.argv.(1) = "test" ->
  let s_exp = read_file "test2"
  in parse s_exp |> eval |> print_bool
| 2 when Sys.argv.(1) = "trace" ->
  let s_exp = (match read_line() with Some s -> s | _ -> "")
  in parse s_exp |> trace |> print_trace
| 2 ->
  let s_exp = read_file Sys.argv.(1)    
  in parse s_exp |> eval |> print_bool
| 3 when Sys.argv.(1) = "trace" ->
  let s_exp = read_file Sys.argv.(2)
  in parse s_exp |> trace |> print_trace     
| _ -> failwith "Usage: dune exec boolexpr [trace] [file]"
