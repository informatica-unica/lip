open Contextfree.Grammar
open Contextfree.Types
open Contextfree.Exercises

let input_grammar = todo (* REPLACE [todo] WITH A GRAMMAR YOU WANT TO TEST *)
let max_steps = 10

let random_production (g : grammar) (sent : sentential_form) : int * production
    =
  let symbols : symbol list =
    List.filter_map
      (function
        | Symbol s -> Some s
        | _ -> None)
      sent
  in
  let prods_with_indexes = List.mapi (fun i p -> (i, p)) g.productions in
  let options : (int * production) list =
    List.filter_map
      (fun (i, ((sym, _) as p)) ->
        if List.mem sym symbols then Some (i, p) else None)
      prods_with_indexes
  in
  List.nth options @@ Random.int (List.length options)

let random_derivation (max_steps : int) (g : grammar) =
  let rec go (step : int) (sent : sentential_form) : sentential_form =
    if step <= max_steps && can_step sent then (
      let i, p = random_production g sent in
      print_string @@ "(" ^ string_of_production p ^ ") ";
      let sent' = step_g g i sent in
      go (step + 1) sent')
    else sent
  in
  go 0 [ Symbol g.start ]

let rec loop () =
  let s = random_derivation max_steps input_grammar in
  print_newline ();
  print_endline @@ string_of_sentform s;
  print_newline ();
  Unix.sleepf 0.5;
  loop ()

let _ =
  print_endline "Exit with Ctrl+C\nGenerating words...\n";
  loop ()
