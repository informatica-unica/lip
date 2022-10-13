open BoolexprLib.Main

let s1 = "false"

let s2 = "if true then false else true"

let s3 = "if true then (if true then false else true) else (if true then true else false)"
  
let s4 = "if (if false then false else false) then (if false then true else false) else (if true then false else true)"

let s5 = "if (if (if false then false else false) then (if false then true else false) else (if true then false else true)) then (if false then true else false) else (if true then false else true)"
 
let%test _ =
  parse s1 |> eval = false &&
  parse s2 |> eval = false &&
  parse s3 |> eval = false &&    
  parse s4 |> eval = false &&
  parse s5 |> eval = false  
