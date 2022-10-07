type card = Joker | Val of int;;

let card_ok = function
    Joker -> true
  | Val n -> n>=1 && n<=10
;;

let win player dealer =
  assert (card_ok player && card_ok dealer);
  match (player,dealer) with
    (_,Joker) -> false
  | (Joker,_) -> true
  | (Val p, Val d) -> (p > d);;