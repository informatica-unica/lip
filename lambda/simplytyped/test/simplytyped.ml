open SimplytypedLib.Ast
open SimplytypedLib.Main

(**********************************************************************
 parse test : (variable, term, expected result)
 **********************************************************************)

let test_parse = [
  ("fun x:bool. x y", Abs("x", TBool, App(Var "x",Var "y")));
  ("fun x1:bool. x1 y2", Abs("x1", TBool, App(Var "x1",Var "y2")));
  ("fun x:bool. x (fun y:bool. x y)", Abs("x",TBool,App(Var "x",Abs("y",TBool,App(Var "x", Var "y")))));
  ("(x y) z", App(App(Var "x",Var "y"),Var "z"));
  ("x (y z)", App(Var "x",App(Var "y",Var "z")));
  ("x y z", App(App(Var "x",Var "y"),Var "z"));
  ("x y z w", App(App(App(Var "x",Var "y"),Var "z"),Var "w"));
  ("fun x:bool. x y z", Abs("x",TBool,App(App(Var "x",Var "y"),Var "z")));
  ("fun x:bool. fun y:nat. x y z", Abs("x",TBool,Abs("y",TNat,App(App(Var "x",Var "y"),Var "z"))));
  ("fun x:nat->bool. x 0", Abs("x", TFun(TNat,TBool), App(Var "x",Zero)));
  ("fun x:bool. fun y:nat. fun z:bool->nat. x y z", Abs("x",TBool,Abs("y",TNat,Abs("z",TFun(TBool,TNat),App(App(Var "x",Var "y"),Var "z")))));
  ("(fun x:bool. x) (fun y:nat. y)", App(Abs("x",TBool,Var("x")),Abs("y",TNat,Var("y"))));
  ("(fun x:bool. x) (fun y:nat. y) (fun z:nat->bool. z)", App(App(Abs("x",TBool,Var("x")),Abs("y",TNat,Var("y"))),Abs("z",TFun(TNat,TBool),Var("z"))));
  ("fun x:bool->bool->bool. x", Abs("x", TFun(TFun(TBool,TBool),TBool), Var("x")));
  ("fun x:(bool->bool)->bool. x", Abs("x", TFun(TFun(TBool,TBool),TBool), Var("x")));  
  ("fun x:bool->(bool->bool). x", Abs("x", TFun(TBool,TFun(TBool,TBool)), Var("x")));
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
 typecheck test : (variable, term, expected type)
 **********************************************************************)

let test_typecheck = [
  ("fun x:bool. x", Some (TFun(TBool,TBool)));
  ("(fun x:bool. x) true", Some TBool);
  ("fun x:bool. y", None);
  ("fun x:nat. iszero x", Some (TFun(TNat,TBool)));
  ("fun x:nat. succ iszero x", None);
  ("fun x:nat. fun y: bool. y and iszero x", Some (TFun(TNat,TFun(TBool,TBool))));  
]

let string_of_typeoption = function
    Some t -> string_of_type t
  | _ -> "TypeError"
    
let%test _ =
  print_newline();
  print_endline ("*** Testing typecheck...");  
  List.fold_left
    (fun b (ts,er) ->
       let t = parse ts in
       let ar = (try Some(typecheck bot t) with _ -> None) in (* actual result *)
       print_string (ts ^ " |- " ^ string_of_typeoption ar);
       let b' = (ar = er) in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_typeoption er ^ "]"));
       print_newline();
       b && b')
    true
    test_typecheck


(**********************************************************************
 trace test : (start term, number of steps, expected result up-to alpha-conversion)
 **********************************************************************)

let test_trace = [
  ("fun x:bool. x", "fun z:bool. z");
  ("(fun x:bool. x) true", "true");    
  ("(fun x:bool. not x) true", "false");
  ("if true then (fun x:bool. x) else (fun x:bool. not x)", "fun z:bool. z");  
  ("(if true then (fun x:bool. x) else (fun x:bool. not x)) true", "true");
  ("(fun x:bool. fun y:bool. x and y) true true", "true");
  ("(fun x:bool. fun y:bool. x and y) true false", "false");
  ("(fun f:bool->bool. fun x:bool. not (f x)) (fun x:bool. not x) true", "true");
  ("(fun f:bool->(bool->bool). fun x:bool. fun y:bool. not (f x y)) (fun x:bool. fun y:bool. x and y) true true", "false");
  ("(fun f:nat->nat. fun x:nat. f x) (fun x:nat. succ x) (pred succ 0)", "succ 0");  
  ("(fun f:nat->nat. fun x:nat. f (f x)) (fun x:nat. succ x) (pred succ 0)", "succ succ 0");
  ("(fun f:nat->nat. fun g:nat->nat. fun x:nat. f (g x)) (fun x:nat. succ x) (fun x:nat. succ (succ x)) (succ 0)", "succ succ succ succ 0");
  ("(fun f:nat->bool. fun g:nat->nat. fun x:nat. f (g x)) (fun x:nat. iszero x) (fun x:nat. succ (succ x)) (succ 0)", "false");        
]

let rec last = function
    [] -> failwith "last on empty list"
  | [x] -> x
  | _::l -> last l
              
let%test _ =
  print_newline();
  print_endline ("*** Testing trace...");  
  List.fold_left
    (fun b (ts,ts') ->
       let t = parse ts and t' = parse ts' in
       let ar = last (trace t) in (* actual result *)
       print_string (ts ^ " ->* " ^ string_of_term ar);
       let b' = (equiv ar t') in
       print_string (" " ^ (if b' then "[OK]" else "[NO : expected " ^ string_of_term t' ^ "]"));
       print_newline();
       b && b')
    true
    test_trace
