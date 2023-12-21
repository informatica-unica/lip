open Crobots
open Ast
open Main
open Trace
open Memory

let parse_expr = parse' Parser.test_expr
let parse_stat = parse' Parser.test_stat

let%test "int_const1" = "1" |> parse_expr = CONST 1
let%test "int_const2" = "01" |> parse_expr = CONST 1

let%test "if_else " =
  "if (1) {} else {}" |> parse_stat = IFE (CONST 1, EMPTY, EMPTY)

let%test "if_no_else " = "if (1) {}" |> parse_stat = IF (CONST 1, EMPTY)

let%test "dangling_else" =
  "if (1) if (0) {} else {}" |> parse_stat
  = IF (CONST 1, IFE (CONST 0, EMPTY, EMPTY))

let%test "arithexpr" =
  "1 + 2 * 3 / -(2 - 3)" |> parse_expr
  = BINARY_EXPR
      ( CONST 1,
        ADD,
        BINARY_EXPR
          ( BINARY_EXPR (CONST 2, MUL, CONST 3),
            DIV,
            UNARY_EXPR (UMINUS, BINARY_EXPR (CONST 2, SUB, CONST 3)) ) )

let%test "stat_list" =
  "{ 1; 2; }" |> parse_stat = BLOCK (SEQ (EXPR (CONST 1), EXPR (CONST 2)))

let rec last = function
  | [] -> failwith "last on empty list"
  | [ x ] -> x
  | _ :: l -> last l

let%test "foo_1" =
  "
  int foo(x) { int y = 2; return x + y; }
  int main () { return 1 + foo(42); }"
  |> parse |> trace |> last = CONST 45

let%test "foo_2" =
  "
  int foo(x) { int y = 2; return x + y; }
  int main () { return bar(3) + foo(42); }
  int bar(n) { return n * 2; }"
  |> parse |> trace |> last = CONST 50

let%test "foo_3" =
  "
  int foo(x) { int y = 2; return x + y; }
  int main () { return foo(z); }
  int z = 2;
  "
  |> parse |> trace |> last = CONST 4

let%test "factorial_wrong" =
  "
  int fact(n) { 
    if (n == 0) return 1;
    else {
      return n * fact (n-1);
    }
  }
  int main () {
    return fact(4);
  }"
  |> parse |> trace |> last = CONST 24

let%test "factorial" =
  "
  int fact(n) {
    if (n != 0) return n * fact (n-1);
    else return 1;
  }
  int main () {
    return fact(4);
  }"
  |> parse |> trace |> last = CONST 24

let%test "factorial-ignore-expr-after-return" =
  "
  int fact(n) {
    int a;
    if (a = n > 0) { return n * fact (n-1); a = 2; } 
    else return 1;
  }
  int main () {
    return fact(6);
  }"
  |> parse |> trace |> last = CONST 720

let%test "prefix-incr" =
  "
  int main() {
    int x = 1;

    int y = ++x;
    
    return x == 2 && y == 2;
  }"
  |> parse |> trace |> last = CONST 1

let%test "factorial-iterative" =
  "
  int fact(n) {
    int acc = 1;

    while (n) {
      acc = acc * n; 
      n = n - 1;
    }
    
    return acc;
  }

  int main () {
    return fact(4);
  }"
  |> parse |> trace |> last = CONST 24

let%test "do-while" =
  "
  int main () {
    int i = 1;
    int x = 2;
    do {
      x = x * 2;
    }
    while (i != 1);

    return x;
  }"
  |> parse |> trace |> last = CONST 4

let%test "do-while-shadow" =
  "
  int main () {
    int i = 1;
    int x = 2;

    do {
      int x = 42;
      ++x;
    }
    while (i != 1);

    return x;
  }"
  |> parse |> trace |> last = CONST 2

let%test "block" =
  "
  int main() {
    int y;
    int x;
    x = 50;
    {
      int x;
      x = 40;
      y = x+2;
    }

    return x == 50 && y == 42;
  }"
  |> parse |> trace |> last = CONST 1

let%test "many-args" =
  "
  int foo(w,x,y,z) { return w * x + y * z; }
  int main() {
    int a = 2;
    return foo(10,a,3/a,42);
  }"
  |> parse |> trace |> last = CONST 62

let%test "many-args2" =
  "
  int foo(w,x,y,z) { return x * y + w * z; }
  int main() {
    int a = 2;
    return foo(10,a,3/a,42);
  }"
  |> parse |> trace |> last = CONST 422

let%test "many-args3" =
  "
  int foo(w,x,y,z) { return x * y + w * z; }
  int main() {
    int a = 2;
    return foo(8 + a,a,3/a,42 + a * 0);
  }"
  |> parse |> trace |> last = CONST 422

let%test "side-effect" =
  "
  int x;
  int foo() { --x; }
  int main() {
    x = 42;
    foo();
    return x;
  }"
  |> parse |> trace |> last = CONST 41

let%test "side-effect-trace" =
  "
  int x;
  int foo() { --x; }
  int main() {
    x = 42;
    foo();
    return x;
  }"
  |> parse |> trace |> last = CONST 41

let%test "many-args-trace" =
  "
  int foo(w,x,y,z) { return x * y + w * z; }
  int main() {
    int a = 2;
    return foo(8 + a,a,3/a,42 + a * 0);
  }"
  |> parse |> trace |> last = CONST 422

let%test "fun-no-shadow" =
  "
  int foo(w,x,y,z) { return x * y + w * z; }
  int main() {
    int w = 2;
    int y = w;
    int z = foo(8 + w,w,3/w,42 + w * 0);
    return w == 2 && y == 2 && z == 422;
  }"
  |> parse |> trace |> last = CONST 1

let%test "fact-iterative-trace" =
  "
  int fact(n) {
    int acc = 1;

    while (n) {
      acc = acc * n; 
      n = n - 1;
    }
    
    return acc;
  }

  int main () {
    return fact(4);
  }"
  |> parse |> trace |> last = CONST 24

let%test "do-while-trace" =
  "
  int main () {
    int i = 1;
    int x = 2;
    do {
      x = x * 2;
    }
    while (i != 1);

    return x;
  }"
  |> parse |> trace |> last = CONST 4

let%test "exit-on-return" =
  "
  int main() {
    int x = 20;

    {
      int y;
      y = --x;
      return y;
    } 
    
    x = 42;
    return x;
  }"
  |> parse |> trace |> last = CONST 19

let%test "foo21" =
  "
  int foo(x, y) {
    {
      y = y + --x;
      return y;
    } 
  }

  int main() {
    int x = 20;

    return x == 20 && foo(x,3) == 22;
  }"
  |> parse |> trace |> last = CONST 1

let%test "comments" =
  "
  /* foo is a cool function */
  int foo(w,x,y,z) { return x * y + w * z; }

  /*
    main is not so cool
  */
  int main() {
    int w = 2; // why did i declare this
    int y = w;
    int z = foo(8 + w,w,3/w,42 + w * 0);
    return w == 2 && y == 2 && z == 422; // please return 1
  }"
  |> parse |> trace |> last = CONST 1

let%test "intrinsic1" =
  "
  int main() {
    int x = rand(1000), y = rand(1000);
    drive(200 - x,x);
    int z = (cos(60) + sin(30)) / 100000;
    return cos(-360) == 100000 && z == 1 && x < 1000 && y < 1000;
  }"
  |> parse |> trace |> last = CONST 1

let%test "intrinsic-override-not-allowed" =
  try
    "
    int drive(x,y) {
      return x * x + y * y;
    }

    int main() {
      int x = rand(1000), y = rand(1000);
      drive(200 - x,x);
      int z = (cos(60) + sin(30)) / 100000;
      return cos(-360) == 100000 && z == 1 && x < 1000 && y < 1000;
    }"
    |> parse |> trace |> ignore;
    false
  with IntrinsicOverride -> true

let%test "parse-rabbit" =
  "
  /* rabbit */
  /* rabbit runs around the field, randomly */
  /* and never fires;  use as a target */

  int main()
  {

    while (1)
    {
      go(rand(1000), rand(1000)); /* go somewhere in the field */
    }

  } /* end of main */

  /* go - go to the point specified */

  int go(dest_x, dest_y)
  {
    int course;

    course = plot_course(dest_x, dest_y);
    drive(course, 25);
    while (distance(loc_x(), loc_y(), dest_x, dest_y) > 50)
      ;
    drive(course, 0);
    while (speed() > 0)
      ;
  }

  /* distance forumula */

  int distance(x1, y1, x2, y2)
  {
    int x, y, d;

    x = x1 - x2;
    y = y1 - y2;
    d = sqrt((x * x) + (y * y));

    return (d);
  }

  /* plot_course - figure out which heading to go */

  int plot_course(xx, yy)
  {
    int d;
    int x, y;
    int scale;
    int curx, cury;

    scale = 100000; /* scale for trig functions */

    curx = loc_x();
    cury = loc_y();
    x = curx - xx;
    y = cury - yy;

    if (x == 0)
    {
      if (yy > cury)
        d = 90;
      else
        d = 270;
    }
    else
    {
      if (yy < cury)
      {
        if (xx > curx)
          d = 360 + atan((scale * y) / x);
        else
          d = 180 + atan((scale * y) / x);
      }
      else
      {
        if (xx > curx)
          d = atan((scale * y) / x);
        else
          d = 180 + atan((scale * y) / x);
      }
    }
    return (d);
  }

  /* end of rabbit.r */"
  |> parse |> ignore;
  true
