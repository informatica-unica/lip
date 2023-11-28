open Ast
open Types

let string_of_val = function
    Bool b -> if b then "true" else "false"
  | Nat n -> string_of_int n

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
  
let rec string_of_cmd = function
    Skip -> "skip"
  | Assign(x,e) -> x ^ ":=" ^ string_of_expr e
  | Seq(c1,c2) -> string_of_cmd c1 ^ "; " ^ string_of_cmd c2
  | If(e,c1,c2) -> "if " ^ string_of_expr e ^ " then " ^ string_of_cmd c1 ^ " else " ^ string_of_cmd c2
  | While(e,c) -> "while " ^ string_of_expr e ^ " do " ^ string_of_cmd c

let rec string_of_state_rec s dom = match dom with
    [] -> ""
  | [x] -> (try x ^ "=" ^ string_of_val (s x)
            with _ -> "")
  | x::dom' -> (try x ^ "=" ^ string_of_val (s x) ^ "," ^ string_of_state_rec s dom'
                with _ -> string_of_state_rec s dom') 

let string_of_state s dom = "[" ^ string_of_state_rec s dom ^ "]"

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
  
let rec vars_of_cmd = function
    Skip -> []
  | Assign(x,e) -> union [x] (vars_of_expr e)
  | Seq(c1,c2) -> union (vars_of_cmd c1) (vars_of_cmd c2)
  | If(e,c1,c2) -> union (vars_of_expr e) (union (vars_of_cmd c1) (vars_of_cmd c2))
  | While(e,c) -> union (vars_of_expr e) (vars_of_cmd c)
  
let string_of_conf vars = function
    St s -> string_of_state s vars
  | Cmd(c,s) -> "<" ^ string_of_cmd c ^ "," ^ string_of_state s vars ^ ">"

let rec string_of_trace vars = function
    [] -> ""
  | [x] -> (string_of_conf vars x)
  | x::l -> (string_of_conf vars x) ^ "\n -> " ^ string_of_trace vars l
              
let rec last = function
    [] -> failwith "last on empty list"
  | [x] -> x
  | _::l -> last l
