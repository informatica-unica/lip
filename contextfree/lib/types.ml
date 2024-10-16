type symbol = A | B | S

type terminal = char
type symbol_or_terminal = Symbol of symbol | Terminal of terminal
type sentential_form = symbol_or_terminal list
type production = symbol * sentential_form

type grammar = {
  symbols : symbol list;
  terminals : terminal list;
  productions : production list;
  start : symbol;
}

let char_of_symbol = function
  | A -> 'A'
  | B -> 'B'
  | S -> 'S'

let symbol_of_char = function
  | 'A' -> Some A
  | 'B' -> Some B
  | 'S' -> Some S
  | _ -> None

let string_of_sentform = function
  | [] -> ""
  | s ->
      s
      |> List.filter_map (function
           | Terminal t -> Some t
           | Symbol s -> Some (char_of_symbol s))
      |> List.to_seq |> String.of_seq

let string_of_production ((sym, sent) : production) =
  Printf.sprintf "%c->%s" (char_of_symbol sym) (string_of_sentform sent)

let sentform_of_string (s : string) =
  String.fold_right
    (fun c acc ->
      (match symbol_of_char c with
      | Some s -> Symbol s
      | None -> Terminal c)
      :: acc)
    s []

let ( --> ) sym sent : production = (sym, sentform_of_string sent)
