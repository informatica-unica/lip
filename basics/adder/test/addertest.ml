open Adder

let%test _ = addlist [] = 0
let%test _ = addlist [3] = 3
let%test _ = addlist [1;2] = 3
let%test _ = addlist [1;2;3] = 6
