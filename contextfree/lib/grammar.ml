open Types

(** [can_step s] detects whether [s] contains non-terminal symbols.
*)
let can_step (s : sentential_form) : bool =
  List.find_opt
    (function
      | Symbol _ -> true
      | _ -> false)
    s
  <> None

(** [step (left, right) w] replaces [right] for the
    first occurrence of [left] in [w]. Examples:

    [step S      (S -> 0S0)   = 0S0]

    [step 0S0    (S -> 1S1)   = 01S10]

    [step 01S10  (S -> ϵ)     = 0110]

    [step 01SS10 (S -> 0S0)   = 010S0S10]

    [step 0110   (S -> 0S0)   = 0110]
*)
let step : production -> sentential_form -> sentential_form =
 fun (a, b) w ->
  let rec insert acc = function
    | [] -> acc
    | Symbol s :: ss when s = a -> List.rev acc @ b @ ss
    | s :: ss -> insert (s :: acc) ss
  in
  insert [] w

let step_g (g : grammar) (n : int) : sentential_form -> sentential_form =
  step (List.nth g.productions n)

(** [derive g ids] returns the [sentential_form] obtained by
    cumulatively applying the productions of [g] in the
    order defined by [ids] to the start symbol of [g].
*)
let derive (g : grammar) (indexes : int list) : sentential_form =
  List.fold_left (fun acc i -> step_g g i acc) [ Symbol g.start ] indexes
