open BlocksLib.Ast
open BlocksLib.Types
open BlocksLib.Prettyprint
open BlocksLib.Main

(**********************************************************************
 parse test : (variable, term, expected result)
 **********************************************************************)

let test_parse cmd exp_result =
  cmd |> parse |> fun c -> c = exp_result

let%test "test_parse1" = test_parse
    "{ x:=0 }"
    (Decl([],Assign("x",Const(0))))

let%test "test_parse2" = test_parse
    "x:=0; y:=x+1"
    (Seq(Assign("x",Const(0)),Assign("y",Add(Var("x"),Const(1)))))

let%test "test_parse3" = test_parse
    "x:=0; if x=0 then y:=1 else y:=0"
    (Seq(Assign("x",Const(0)),If(Eq(Var("x"),Const(0)),Assign("y",Const(1)),Assign("y",Const(0)))))

let%test "test_parse4" = test_parse
    "x:=0; if x=0 then y:=1 else y:=0; x:=2"
    (Seq(Seq(Assign("x",Const(0)),If(Eq(Var("x"),Const(0)),Assign("y",Const(1)),Assign("y",Const(0)))),Assign("x",Const(2))))

let%test "test_parse5" = test_parse
    "x:=3; while x<=0 do x:=x-1; y:=0"
    (Seq(Seq(Assign("x",Const(3)),While(Leq(Var "x",Const 0),Assign("x",Sub(Var "x",Const 1)))),Assign("y",Const(0))))

let%test "test_parse6" = test_parse
    "{ int x; int y; int z; skip }"
    (Decl ([IntVar "x"; IntVar "y"; IntVar "z"], Skip))

(**********************************************************************
 trace test : (command, n_steps, loc, expected value after n_steps)
 **********************************************************************)

let test_trace (cmd,n_steps,var,exp_val) =
  cmd
  |> parse
  |> fun c -> last (trace n_steps c)
  |> fun t -> match t with
    St s -> getmem s var = exp_val
  | Cmd(_,s) -> getmem s var = exp_val

let%test "test_trace1" = test_trace
  ("{ int x; x:=51 }", 2, 0, Int 51)

let%test "test_trace2" = test_trace
    ("{ int x; x:=0; x:=x+1 }", 5, 0, Int 1)

let%test "test_trace3" = test_trace
  ("{ int x; int y; x:=0; y:=x+1; x:=y+1 }", 5, 0, Int 2)

let%test "test_trace4" = test_trace
  ("{ int x; int y; x:=0; if x=0 then y:=10 else y:=20 }", 5, 1, Int 10)

let%test "test_trace5" = test_trace
  ("{ int x; int y; x:=1; if x=0 then y:=10 else y:=20 }", 5, 1, Int 20)

let%test "test_trace6" = test_trace
  ("{ int x; int y; int r; x:=3; y:=2; r:=0; while 1<=y do { r:=r+x; y:=y-1 } }", 20, 2, Int 6)

let%test "test_trace7" = test_trace
  ("{ int x; int y; x:=3; while 0<=x and not 0=x do x:=x-1; x:=5 }", 10, 0, Int 5)

let%test "test_trace8" = test_trace
  ("{ int min; int x; int y; x:=5; y:=3; if x<=y then min:=x else min:=y }", 10, 0, Int 3)

let%test "test_trace9" = test_trace
  ("{ int min; int x; int y; int z; x:=1; y:=2; z:=3; if x<=y and x<=z then min:=x else { if y<=z then min:=y else min:=z } }", 10, 0, Int 1)

let%test "test_trace10" = test_trace
    ("{ int x; x:=2; { int x; x:=100 }; { x:=x+1 } }", 10, 0, Int 3)

let%test "test_trace11" = test_trace
    ("{ int y; int x; x:=10; { int x; x:=20; y:=x }; y:=x }", 10, 0, Int 10)

let%test "test_trace12" = test_trace
    ("{ int y; int x; x:=10; { int x; x:=20; y:=x } }", 10, 0, Int 20)

let%test "test_trace13" = test_trace
    ("{ int y; { int x; x:=20; y:=x }; { int x; x:=30; y:=x+y+1 } }", 10, 0, Int 51)
