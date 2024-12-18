open FunLib.Types
open FunLib.Prettyprint
open FunLib.Main


(**********************************************************************
 trace test : (command, n_steps, location, expected value after n_steps)
 **********************************************************************)

let test_trace (cmd,n_steps,var,exp_val) =
  cmd
  |> parse
  |> fun c -> last (trace n_steps c)
  |> fun t -> match t with
    St s -> apply s var = exp_val
  | Cmd(_,_) -> failwith "program not terminated"

let%test "test_trace1" = test_trace
  ("int x; x:=51", 2, "x", 51)

let%test "test_trace2" = test_trace
    ("int x; x:=0; x:=x+1", 5, "x", 1)

let%test "test_trace3" = test_trace
    ("int x; int y; x:=0; y:=x+1; x:=y+1", 10, "x", 2)

let%test "test_trace4" = test_trace
    ("int x; int y; x:=0; if x=0 then y:=10 else y:=20", 5, "y", 10)

let%test "test_trace5" = test_trace
    ("int x; int y; x:=1; if x=0 then y:=10 else y:=20", 5, "y", 20)

let%test "test_trace6" = test_trace
    ("int x; int y; int r; x:=3; y:=2; r:=0; while 1<=y do ( r:=r+x; y:=y-1 )", 30, "r", 6)

let%test "test_trace7" = test_trace
    ("int x; int y; x:=3; while 0<=x and not 0=x do x:=x-1; x:=5", 50, "x", 5)

let%test "test_trace8" = test_trace
    ("int min; int x; int y; x:=5; y:=3; if x<=y then min:=x else min:=y", 40, "min", 3)

let%test "test_trace9" = test_trace
    ("int min; int x; int y; int z; x:=1; y:=2; z:=3; if x<=y and x<=z then min:=x else ( if y<=z then min:=y else min:=z )", 40, "min", 1)

let%test "test_trace10" = test_trace
    ("int x; fun f(y) { skip; return y+1 }; x := f(10)", 20, "x", 11)

let%test "test_trace11" = test_trace
    ("int x; fun f(y) { skip; return y+1 }; fun g(z) { skip; return f(z)+2 }; x := g(10)", 20, "x", 13)

let%test "test_trace12_x" = test_trace
    ("int x; int z; fun f(y) { x:=x+1; return x }; x := 10; z := f(0)", 20, "x", 11)

let%test "test_trace12_z" = test_trace
    ("int x; int z; fun f(y) { x:=x+1; return x }; x := 10; z := f(0)", 20, "z", 11)

let%test "test_trace13" = test_trace
    ("int x; int y; int w; fun f(z) { z:=x; x:=y; y:=z; return 0 }; x := 10; y := 20; w := f(0)", 20, "x", 20)

let%test "test_trace14" = test_trace
("int x; int y; int w; fun f(z) { z:=x; x:=y; y:=z; return 0 }; x := 10; y := 20; w := f(0)", 20, "y", 10)

let%test "test_trace15" = test_trace
    ("int x; int y; fun f(x) { x:=20; return 0 }; x := 10; y := f(0); x := x+1", 20, "x", 11)

let%test "test_boss" = test_trace
    ({|
        int x;
        int r;
        fun f(n) { if n=0 then r:=1 else r:=n*f(n-1); return r };
        x := f(5)
    |}, 100, "x", 120)
