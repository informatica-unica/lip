open Contextfree.Grammar
open Contextfree.Types
open Contextfree.Exercises

let input_grammar = todo (* REPLACE [todo] WITH A GRAMMAR YOU WANT TO TEST *)

let random_list max_value : int list =
  List.init (Random.int 100 + 1) (fun _ -> Random.int max_value)

let string_of_list (to_string : 'a -> string) (l : 'a list) : string =
  let rec go = function
    | [] -> ""
    | [ x ] -> to_string x
    | x :: xs -> to_string x ^ "; " ^ go xs
  in
  "[" ^ go l ^ "]"

let rec loop () =
  let production_seq = random_list (List.length input_grammar.productions) in
  let literal_productions =
    List.map (List.nth input_grammar.productions) production_seq
    |> string_of_list string_of_production
  in
  let s = derive input_grammar production_seq |> string_of_sentform in
  Unix.sleepf 0.5;
  print_endline @@ literal_productions ^ ":";
  print_endline s;
  print_newline ();
  loop ()

let _ =
  print_endline "Exit with Ctrl+C\nGenerating words...";
  loop ()
