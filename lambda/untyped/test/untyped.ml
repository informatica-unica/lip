open UntypedLib.Ast
open UntypedLib.Main

(**********************************************************************
 parse test : (variable, term, expected result)
 **********************************************************************)

let test_parse = [
  ("fun x. x y", Abs("x", App(Var "x",Var "y")));
  ("fun x1. x1 y2", Abs("x1", App(Var "x1",Var "y2")));
  ("fun x. x (fun y. x y)", Abs("x",App(Var "x",Abs("y",App(Var "x", Var "y")))));
  ("(x y) z", App(App(Var "x",Var "y"),Var "z"));
  ("x (y z)", App(Var "x",App(Var "y",Var "z")));
  ("x y z", App(App(Var "x",Var "y"),Var "z"));
  ("x y z w", App(App(App(Var "x",Var "y"),Var "z"),Var "w"));
  ("fun x. x y z", Abs("x",App(App(Var "x",Var "y"),Var "z")));
  ("fun x. fun y. x y z", Abs("x",Abs("y",App(App(Var "x",Var "y"),Var "z"))));
  ("fun x. fun y. fun z. x y z", Abs("x",Abs("y",Abs("z",App(App(Var "x",Var "y"),Var "z")))));
  ("(fun x. x) (fun y. y)", App(Abs("x",Var("x")),Abs("y",Var("y"))));
  ("(fun x. x) (fun y. y) (fun z. z)", App(App(Abs("x",Var("x")),Abs("y",Var("y"))),Abs("z",Var("z"))))
]

let%test _ =
  print_newline ();
  print_endline ("*** Testing parse...");
  List.fold_left
    (fun b (ts,t) ->
       print_string ts;
       let b' = (parse ts = t) in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_term t ^ "]"));
       print_newline();
       b && b')
    true
    test_parse


(**********************************************************************
 is_free test : (variable, term, result)
 **********************************************************************)
    
let string_of_test_is_free x t =
  x ^ " in fv(" ^ string_of_term t ^ ")"

let test_is_free = [
  ("x","x",true);
  ("x","y",false);    
  ("x","fun x . x y",false);  
  ("y","fun x . x y",true);
  ("x","fun x . x (fun y . x y)",false);    
  ("y","fun x . x (fun y . x y)",false);
  ("z","fun x . x (fun y . (x y) z)",true);
]
  
let%test _ =
  print_newline ();
  print_endline ("*** Testing is_free...");
  List.fold_left
    (fun b (x,ts,er) ->
       let ar = ts |> parse |> (is_free x) in (* actual result *)
       print_string (string_of_test_is_free x (parse ts) ^ " : " ^ string_of_bool ar);
       let b' = (ar = er) in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_bool er ^ "]"));
       print_newline();
       b && b')
    true
    test_is_free



(**********************************************************************
 equiv test : (first term, second term, expected equivalence)
 **********************************************************************)

let test_equiv = [
  ("x", "x", true);  
  ("x", "y", false);
  ("fun x . x", "fun y . y", true);
  ("fun x . x", "fun x . y", false);    
  ("fun x . x y", "fun z . z y", true);
  ("fun x . x y", "fun z . z z", false);  
  ("fun x . x (fun y . x y)", "fun z . z (fun y . z y)", true);
  ("fun x . x (fun y . x y)", "fun z . z (fun w . z w)", true);
  ("fun x . (fun y . x)", "fun y . (fun x . y)", true);
]
  
let%test _ =
  print_newline();
  print_endline ("*** Testing equiv...");
  List.fold_left
    (fun b (t1,t2,er) ->
       let ar = equiv (parse t1) (parse t2) in
       print_string ("equiv (" ^ t1 ^ ") (" ^ t2 ^ ") = " ^ string_of_bool er);
       let b' = (er = ar) in
       print_string (" " ^ (if b' then "[OK]" else "[NO] "));
       print_newline();
       b && b')
    true
    test_equiv


(**********************************************************************
 subst test : (variable, def term, in term, expected result)
 **********************************************************************)

let string_of_test_subst x tx t =
  "[" ^ x ^ " -> " ^ string_of_term (parse tx) ^ "] " ^ string_of_term (parse t)

let test_subst = [
  ("x", "y", "x", "y");  
  ("x", "y", "fun x . x", "fun x . x");
  ("x", "y", "fun x . y", "fun x . y");
  ("x", "y", "fun y . x", "fun x1 . y");
  ("x", "fun z . z w", "fun y . x", "fun y . fun z . z w");
  ("x", "y z", "fun y . x (fun w . x)", "fun x1 . (y z) (fun w . y z)");
  ("x", "y z", "fun y . x (fun z . x)", "fun x1 . (y z) (fun x2 . y z)");
]

let%test _ =
  print_newline();
  print_endline ("*** Testing subst...");  
  List.fold_left
    (fun b (x,tx,t,ers) ->
       let ar = fst(subst x (parse tx) 1 (parse t)) in (* actual result *)
       print_string (string_of_test_subst x tx t ^ " : " ^ string_of_term ar);
       let b' = (ar = parse ers) in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_term (parse ers) ^ "]"));
       print_newline();
       b && b')
    true
    test_subst


(**********************************************************************
 trace test : (start term, number of steps, expected result up-to alpha-conversion)
 **********************************************************************)

let omega = "(fun x. x x)"

let tru = "fun t. fun f. t"
  
let iftru = "(fun l. fun m. fun n. l m n) (fun t. fun f. t) (fun v . v) (fun w . w w)"

let iffls = "(fun l. fun m. fun n. l m n) (fun t. fun f. f) (fun v . v) (fun w . w w)"
  
  
let test_trace = [
  ("fun x. x", 1, "fun z. z");
  (omega ^ omega, 1, omega ^ omega);
  ("(fun x . y) (" ^ omega ^ omega ^ ")", 1, "(fun x . y) (" ^ omega ^ omega ^ ")");
  ("(fun x. x) ((fun x. x) (fun z. (fun x. x) z))", 2, "fun z. (fun x. x) z");
  (iftru, 5, "fun v. v");
  (iffls, 5, "fun w. w w");  
]

let rec last = function
    [] -> failwith "last on empty list"
  | [x] -> x
  | _::l -> last l
              
let%test _ =
  print_newline();
  print_endline ("*** Testing trace...");  
  List.fold_left
    (fun b (ts,n,ts') ->
       let t = parse ts and t' = parse ts' in
       let ar = last (trace n t) in (* actual result *)
       print_string (ts ^ " --" ^ string_of_int n ^ "-> " ^ string_of_term ar);
       let b' = (equiv ar t') in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_term t' ^ "]"));
       print_newline();
       b && b')
    true
    test_trace
