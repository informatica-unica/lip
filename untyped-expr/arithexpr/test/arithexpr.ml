open ArithexprLib.Main

let s1 = "false"

let s2 = "if true then false else true"

let s3 = "if true then (if true then false else true) else (if true then true else false)"
  
let s4 = "if (if false then false else false) then (if false then true else false) else (if true then false else true)"

let s5 = "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)"

let s6 = "not true or true"

let s7 = "not true and false"

let s8 = "false and false or true"

let s9 = "true or false and false"

let s10 = "if true then true else false and false"

let s11 = "if true then false else false or true"

let s12 = "succ 0"

let s13 = "iszero pred succ 0"

let s14 = "iszero pred succ 0 and not iszero succ pred succ 0"

let%test _ =
  s1 |> parse |> eval = Bool false &&
  s2 |> parse |> eval = Bool false &&
  s3 |> parse |> eval = Bool false &&    
  s4 |> parse |> eval = Bool false &&
  s5 |> parse |> eval = Bool false &&
  s6 |> parse |> eval = Bool true &&
  s7 |> parse |> eval = Bool false &&
  s8 |> parse |> eval = Bool true &&
  s9 |> parse |> eval = Bool true &&
  s10 |> parse |> eval = Bool true &&
  s11 |> parse |> eval = Bool false &&
  s12 |> parse |> eval = Nat 1 &&
  s13 |> parse |> eval = Bool true &&
  s14 |> parse |> eval = Bool true

