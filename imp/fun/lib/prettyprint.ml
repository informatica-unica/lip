open Ast
open Types

let string_of_val = function
  | n -> string_of_int n

let rec string_of_expr = function
    True -> "true"
  | False -> "false"
  | Var x -> x
  | Const n -> string_of_int n
  | Not e -> "not " ^ string_of_expr e
  | And(e1,e2) -> string_of_expr e1 ^ " and " ^ string_of_expr e2
  | Or(e1,e2) -> string_of_expr e1 ^ " or " ^ string_of_expr e2
  | Add(e1,e2) -> string_of_expr e1 ^ "+" ^ string_of_expr e2
  | Sub(e1,e2) -> string_of_expr e1 ^ "-" ^ string_of_expr e2
  | Mul(e1,e2) -> string_of_expr e1 ^ "*" ^ string_of_expr e2
  | Eq(e1,e2) -> string_of_expr e1 ^ "=" ^ string_of_expr e2
  | Leq(e1,e2) -> string_of_expr e1 ^ "<=" ^ string_of_expr e2
  | Call(f,e) -> f ^ "(" ^ string_of_expr e ^ ")"
  | CallExec(c,e) -> "exec{" ^ string_of_cmd c ^ "; ret " ^ string_of_expr e ^ "}"
  | CallRet(e) -> "{ret " ^ string_of_expr e ^ "}"

and string_of_cmd = function
    Skip -> "skip"
  | Assign(x,e) -> x ^ ":=" ^ string_of_expr e
  | Seq(c1,c2) -> string_of_cmd c1 ^ "; " ^ string_of_cmd c2
  | If(e,c1,c2) -> "if " ^ string_of_expr e ^ " then " ^ string_of_cmd c1 ^ " else " ^ string_of_cmd c2
  | While(e,c) -> "while " ^ string_of_expr e ^ " do " ^ string_of_cmd c

let string_of_decl = function
  | IntVar(x) -> "int " ^ x
  | Fun(f,x,c,e) -> "fun " ^ f ^ "(" ^ x ^ ") {" ^ string_of_cmd c ^ "return " ^ string_of_expr e ^ "}"

let string_of_env1 s x = match topenv s x with
  | IVar l -> string_of_int l ^ "/" ^ x
  | IFun(y,c,e) -> "fun(" ^ y ^ "){" ^ string_of_cmd c ^ "; return " ^ string_of_expr e ^ "}/" ^ x

let rec string_of_env s = function
    [] -> ""
  | [x] -> (try string_of_env1 s x with _ -> "")
  | x::dom' -> (try string_of_env1 s x ^ "," ^ string_of_env s dom'
                with _ -> string_of_env s dom')

let string_of_mem1 (m,l) i =
  assert (i<l);
  string_of_val (m i) ^ "/" ^ string_of_int i

let rec range a b = if b<a then [] else a::(range (a+1) b);;

let string_of_mem (m,l) =
  List.fold_left (fun str i -> str ^ (try string_of_mem1 (m,l) i ^ "," with _ -> "")) "" (range 0 (l - 1))

let rec getlocs e = function
    [] -> []
  | x::dom -> try (match e x with
    | IVar l -> l::(getlocs e dom)
    | IFun(_,_,_) -> [])
    with _ -> getlocs e dom

let string_of_state st dom =
  "[" ^ string_of_env st dom ^ "], " ^
  "[" ^ string_of_mem (getmem st,getloc st) ^ "]" ^ ", " ^
  string_of_int (getloc st)

let rec union l1 l2 = match l1 with
    [] -> l2
  | x::l1' -> (if List.mem x l2 then [] else [x]) @ union l1' l2

let rec vars_of_expr = function
    True
  | False
  | Const _ -> []
  | Var x -> [x]
  | Not e -> vars_of_expr e
  | And(e1,e2)
  | Or(e1,e2)
  | Add(e1,e2)
  | Sub(e1,e2)
  | Mul(e1,e2)
  | Eq(e1,e2)
  | Leq(e1,e2) -> union (vars_of_expr e1) (vars_of_expr e2)
  | Call(f,e) -> union [f] (vars_of_expr e)
  | CallExec(c,e) -> union (vars_of_cmd c) (vars_of_expr e)
  | CallRet(e) -> vars_of_expr e

and vars_of_cmd = function
    Skip -> []
  | Assign(x,e) -> union [x] (vars_of_expr e)
  | Seq(c1,c2) -> union (vars_of_cmd c1) (vars_of_cmd c2)
  | If(e,c1,c2) -> union (vars_of_expr e) (union (vars_of_cmd c1) (vars_of_cmd c2))
  | While(e,c) -> union (vars_of_expr e) (vars_of_cmd c)

let vars_of_decl = function
  | IntVar(x) -> [x]
  | Fun(f,x,c,e) -> union [x;f] (union (vars_of_cmd c) (vars_of_expr e))

let vars_of_prog (Prog(ds,_)) = List.concat_map vars_of_decl ds

let string_of_conf vars = function
    St st -> string_of_state st vars
  | Cmd(c,st) -> "<" ^ string_of_cmd c ^ ", " ^ string_of_state st vars ^ ">"

let rec string_of_trace vars = function
    [] -> ""
  | [x] -> (string_of_conf vars x)
  | x::l -> (string_of_conf vars x) ^ "\n -> " ^ string_of_trace vars l

let rec last = function
    [] -> failwith "last on empty list"
  | [x] -> x
  | _::l -> last l
