open Ast

type exprval = Bool of bool | Nat of int

let string_of_val = function
    Bool b -> if b then "True" else "False"
  | Nat n -> string_of_int n
;;

let rec string_of_expr = function
    True -> "True"
  | False -> "False"
  | Not(e) -> "Not(" ^ (string_of_expr e) ^ ")"
  | And(e1,e2) -> "And(" ^ (string_of_expr e1) ^ "," ^ (string_of_expr e2) ^ ")"
  | Or(e1,e2) -> "Or(" ^ (string_of_expr e1) ^ "," ^ (string_of_expr e2) ^ ")"
  | If(e0,e1,e2) -> "If(" ^ (string_of_expr e0) ^ "," ^ (string_of_expr e1) ^ "," ^ (string_of_expr e2) ^ ")"
  | Zero -> "0"
  | Succ(e) -> "Succ(" ^ (string_of_expr e) ^ ")"
  | Pred(e) -> "Pred(" ^ (string_of_expr e) ^ ")"
  | IsZero(e) -> "IsZero(" ^ (string_of_expr e) ^ ")"
;;

let parse (s : string) : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
ast

exception NoRuleApplies
  
let rec trace1 = function
    Not(True) -> False
  | Not(False) -> True
  | Not(e) -> let e' = trace1 e in Not(e')
  | And(True,e2) -> e2
  | And(False,_) -> False
  | And(e1,e2) -> let e1' = trace1 e1 in And(e1',e2)
  | Or(True,_) -> True
  | Or(False,e2) -> e2
  | Or(e1,e2) -> let e1' = trace1 e1 in Or(e1',e2)
  | If(True,e1,_) -> e1
  | If(False,_,e2) -> e2
  | If(e0,e1,e2) -> let e0' = trace1 e0 in If(e0',e1,e2)
  | Succ(e) -> let e' = trace1 e in Succ(e')
  | Pred(Succ(e)) -> e
  | Pred(e) -> let e' = trace1 e in Pred(e')
  | IsZero(Zero) -> True
  | IsZero(Succ(e)) -> if e=Zero then False else False
  | IsZero(e) -> let e' = trace1 e in IsZero(e')
  | _ -> raise NoRuleApplies
;;

let rec trace e = try
    let e' = trace1 e
    in e::(trace e')
  with NoRuleApplies -> [e]
;;

let rec eval = function
    True -> Bool true
  | False -> Bool false
  | Not(e) -> (match eval e with
      Bool b -> Bool (not b)
    | _ -> failwith "eval not error")
  | And(e1,e2) -> (match (eval e1, eval e2) with
      (Bool b1, Bool b2) -> Bool (b1 && b2)
    | _ -> failwith "eval and error")
  | Or(e1,e2) -> (match (eval e1, eval e2) with
      (Bool b1, Bool b2) -> Bool (b1 || b2)
    | _ -> failwith "eval or error")
  | If(e0,e1,e2) -> (match eval e0 with
      Bool true -> eval e1
    | Bool false -> eval e2
    | _ -> failwith "eval if error")
  | Zero -> Nat 0
  | Succ(e) -> (match eval e with
      Nat n -> Nat (n+1)
    | _ -> failwith "eval succ error")
  | Pred(e) -> (match eval e with
      Nat 0 -> failwith "eval pred error, cannot substract 0"
    | Nat n -> Nat (n-1)
    | _ -> failwith "eval pred error")
  | IsZero(e) -> (match eval e with
      Nat 0 -> Bool true
    | Nat n -> if n=0 then Bool false else Bool false
    | _ -> failwith "eval iszero error")
;;