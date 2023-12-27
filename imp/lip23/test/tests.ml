open Crobots
open Ast
open Main
open Trace
open Memory

let%test "minus" =
  "main () { 1 - -2; }" |> parse
  = FUNDECL
      ( "main",
        [],
        EXPR (BINARY_EXPR (CONST 1, SUB, UNARY_EXPR (UMINUS, CONST 2))) )

let%test "if-else" =
  "main() { if (1) {} else {} }" |> parse
  = FUNDECL ("main", [], IFE (CONST 1, EMPTY, EMPTY))

let%test "if-no-else" =
  "main() { if (1) {} }" |> parse = FUNDECL ("main", [], IF (CONST 1, EMPTY))

let%test "dangling-else" =
  "main() { if (1) if (0) {} else {} }" |> parse
  = FUNDECL ("main", [], IF (CONST 1, IFE (CONST 0, EMPTY, EMPTY)))

let%test "arithexpr" =
  "main() { 1 + 2 * 3 / -(2 - 3); }" |> parse
  = FUNDECL
      ( "main",
        [],
        EXPR
          (BINARY_EXPR
             ( CONST 1,
               ADD,
               BINARY_EXPR
                 ( BINARY_EXPR (CONST 2, MUL, CONST 3),
                   DIV,
                   UNARY_EXPR (UMINUS, BINARY_EXPR (CONST 2, SUB, CONST 3)) ) ))
      )

let%test "stat-list" =
  "main () { { 1; 2; } }" |> parse
  = FUNDECL ("main", [], BLOCK (SEQ (EXPR (CONST 1), EXPR (CONST 2))))

let rec last = function
  | [] -> failwith "last on empty list"
  | [ x ] -> x
  | _ :: l -> last l

let%test "abs" =
  "main() { int x = 21; if (x < 0) x = x * -1; return x; }"
  |> parse |> trace |> last = CONST 21

let%test "while-to-5" =
  "main() { int x = 0; while (x < 5) x = x + 1; return x; }" |> parse |> trace
  |> last = CONST 5

let%test "foo-1" =
  "
  foo(x) { int y = 2; return x + y; }
  main () { return 1 + foo(42); }"
  |> parse |> trace |> last = CONST 45

let%test "foo-2" =
  "
  foo(x) { int y = 2; return x + y; }
  main () { return bar(3) + foo(42); }
  bar(n) { return n * 2; }"
  |> parse |> trace |> last = CONST 50

let%test "foo-3" =
  "
  foo(x) { int y = 2; return x + y; }
  main () { return foo(z); }
  int z = 2;
  "
  |> parse |> trace |> last = CONST 4

let%test "factorial-1" =
  "
  fact(n) { 
    if (n == 0) return 1;
    else {
      return n * fact (n-1);
    }
  }
  main () {
    return fact(4);
  }"
  |> parse |> trace |> last = CONST 24

let%test "factorial-2" =
  "
  fact(n) {
    if (n != 0) return n * fact (n-1);
    else return 1;
  }
  main () {
    return fact(4);
  }"
  |> parse |> trace |> last = CONST 24

let%test "factorial-ignore-expr-after-return" =
  "
  fact(n) {
    int a;
    if (a = n > 0) { return n * fact (n-1); a = 2; } 
    else return 1;
  }
  main () {
    return fact(6);
  }"
  |> parse |> trace |> last = CONST 720

let%test "assignment-expr" =
  "
  main() {
    int x = 1;

    int y = x = x + 1;
    
    return x == 2 && y == 2;
  }"
  |> parse |> trace |> last = CONST 1

let%test "factorial-iterative" =
  "
  fact(n) {
    int acc = 1;

    while (n) {
      acc = acc * n; 
      n = n - 1;
    }
    
    return acc;
  }

  main () {
    return fact(4);
  }"
  |> parse |> trace |> last = CONST 24

let%test "do-while" =
  "
  main () {
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
  main () {
    int i = 1;
    int x = 2;

    do {
      int x = 42;
      x = x + 1;
    }
    while (i != 1);

    return x;
  }"
  |> parse |> trace |> last = CONST 2

let%test "block" =
  "
  main() {
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
  foo(w,x,y,z) { return w * x + y * z; }
  main() {
    int a = 2;
    return foo(10,a,3/a,42);
  }"
  |> parse |> trace |> last = CONST 62

let%test "many-args-2" =
  "
  foo(w,x,y,z) { return x * y + w * z; }
  main() {
    int a = 2;
    return foo(10,a,3/a,42);
  }"
  |> parse |> trace |> last = CONST 422

let%test "many-args3" =
  "
  foo(w,x,y,z) { return x * y + w * z; }
  main() {
    int a = 2;
    return foo(8 + a,a,3/a,42 + a * 0);
  }"
  |> parse |> trace |> last = CONST 422

let%test "side-effect" =
  "
  int x;
  foo() { x = x - 1; }
  main() {
    x = 42;
    foo();
    return x;
  }"
  |> parse |> trace |> last = CONST 41

let%test "fun-no-shadow" =
  "
  foo(w,x,y,z) { return x * y + w * z; }
  main() {
    int w = 2;
    int y = w;
    int z = foo(8 + w,w,3/w,42 + w * 0);
    return w == 2 && y == 2 && z == 422;
  }"
  |> parse |> trace |> last = CONST 1

let%test "exit-on-return" =
  "
  main() {
    int x = 20;

    {
      int y;
      y = x - 1;
      return y;
    } 
    
    x = 42;
    return x;
  }"
  |> parse |> trace |> last = CONST 19

let%test "foo-nesting" =
  "
  foo(x, y) {
    {
      y = y + (x = x - 1);
      return y;
    }
  }

  main() {
    int x = 20;

    return foo(x,3) == 22 && x == 20;
  }"
  |> parse |> trace |> last = CONST 1

let%test "comments" =
  "
  /* foo is a c00l function */
  foo(w,x,y,z) { return x * y + w * z; }

  /*
    main is not so cool :'(
  */
  main() {
    int w = 2; // why did i declare this?
    int y = w;
    int z = foo(8 + w,w,3/w,42 + w * 0);
    return w == 2 && y == 2 && z == 422; // PlEaSe return 1!!!
  }"
  |> parse |> trace |> last = CONST 1

let%test "wrong-args" =
  try
    "
    or3(a,b,c) {
      return a || b || c;
    }

    main() {
      return or3(0, 1);
    }"
    |> parse |> trace |> ignore;
    false
  with WrongArguments (2, 3) -> true

let%test "wrong-args-intrinsic" =
  try
    "
    main() {
      int s = 50;

      drive(s);
      scan(270, -10, s);
    }"
    |> parse |> trace |> ignore;
    false
  with WrongArguments (1, 2) -> true

let%test "intrinsic-1" =
  "
  main() {
    int x = rand(1000), y = rand(1000);
    int z = (cos(60) + sin(30)) / 100000;
    drive(200 - x,x);
    return cos(-360) == 100000 && z == 1 && x < 1000 && y < 1000;
  }"
  |> parse |> trace |> last = CONST 1

let%test "intrinsic-override" =
  try
    "
    drive(x,y) {
      return x * x + y * y;
    }

    main() {
      int x = rand(1000), y = rand(1000);
      int z = (cos(60) + sin(30)) / 100000;
      drive(200 - x,x);
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

  main()
  {

    while (1)
    {
      go(rand(1000), rand(1000)); /* go somewhere in the field */
    }

  } /* end of main */

  /* go - go to the point specified */

  go(dest_x, dest_y)
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

  distance(x1, y1, x2, y2)
  {
    int x, y, d;

    x = x1 - x2;
    y = y1 - y2;
    d = sqrt((x * x) + (y * y));

    return (d);
  }

  /* plot_course - figure out which heading to go */

  plot_course(xx, yy)
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
