open SarithexprLib.Main
  
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

(* print a result *)

let print_val e = print_string (string_of_val e); print_newline();;

(* print a trace *)

let rec print_trace = function
    [] -> print_newline()
  | [x] -> print_endline (string_of_expr x)
  | x::l -> print_endline (string_of_expr x); print_string " -> " ; print_trace l
;;

let print_type e = try 
    print_endline (string_of_type (typecheck e))
  with TypeError s -> print_endline s
;;

match Array.length(Sys.argv) with
(* eval / read input from stdin *) 
  1 -> (match read_line() with
    Some s when s<>"" -> s |> parse |> eval |> print_val
  | _ -> print_newline())
(* trace / read input from stdin *)      
| 2 when Sys.argv.(1) = "trace" -> (match read_line() with
    Some s when s<>"" -> s |> parse |> trace |> print_trace
  | _ -> print_newline())
(* typecheck / read input from stdin *)      
| 2 when Sys.argv.(1) = "typecheck" -> (match read_line() with
    Some s when s<>"" -> s |> parse |> print_type
  | _ -> print_newline())
(* eval / read input from file *) 
| 2 -> (match read_file Sys.argv.(1) with
      "" -> print_newline()
    | s -> s |> parse |> eval |> print_val)
(* trace / read input from file *)      
| 3 when Sys.argv.(1) = "trace" -> (match read_file Sys.argv.(2) with
      "" -> print_newline()
    | s -> s |> parse |> trace |> print_trace)
(* typecheck / read input from file *)      
| 3 when Sys.argv.(1) = "typecheck" -> (match read_file Sys.argv.(2) with
      "" -> print_newline()
    | s -> s |> parse |> print_type)
(* wrong usage *)      
| _ -> failwith "Usage: dune exec arithexpr [trace|typecheck] [file]"
