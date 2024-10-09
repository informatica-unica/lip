open Types

let string_of_sentform (s : sentential_form) : string =
  s
  |> List.filter_map (function T t -> Some t | _ -> None)
  |> List.to_seq |> String.of_seq


(** #### Exercise 1.1
    [step (left, right) w] replaces [right] for the
    first occurrence of [left] in [w]. Examples:

    [step S      (S -> 0S0)   = 0S0]

    [step 0S0    (S -> 1S1)   = 01S10]

    [step 01S10  (S -> empty) = 0110]

    [step 01SS10 (S -> 0S0)   = 010S0S10]
*)
let step : production -> sentential_form -> sentential_form =
  failwith "todo"


(** Use this helper function to implement [derive] *)
let step_g (g : grammar) (n : int) : sentential_form -> sentential_form =
  step (List.nth g.productions n)


(** #### Exercise 1.2
    [derive g ids] returns the [sentence] obtained by
    cumulatively applying the productions of [g] in the
    order defined by [ids] to the start symbol of [g].
*)
let derive : grammar -> int list -> sentential_form =
  failwith "todo"


(** #### Exercise 1.3
    [can_step s] detects whether [s] contains non-terminal symbols.
*)
let can_step : sentential_form -> bool =
  failwith "todo"


