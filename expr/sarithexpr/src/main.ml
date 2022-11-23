open Ast

type exprtype = BoolT | NatT;;

type exprval = Bool of bool | Nat of int

let string_of_val = function
    Bool b -> if b then "true" else "false"
  | Nat n -> string_of_int n
;;

let rec string_of_expr = function
    True -> "true"
  | False -> "false"
  | Not(e) -> "not " ^ string_of_expr e
  | And(e1,e2) -> string_of_expr e1 ^ " and " ^ string_of_expr e2
  | Or(e1,e2) -> string_of_expr e1 ^ " or " ^ string_of_expr e2                    
  | If(e0,e1,e2) -> "If(" ^ (string_of_expr e0) ^ "," ^ (string_of_expr e1) ^ "," ^ (string_of_expr e2) ^ ")"
  | Zero -> "0"
  | Succ(e) -> "succ(" ^ string_of_expr e ^ ")"
  | Pred(e) -> "pred(" ^ string_of_expr e ^ ")"
  | IsZero(e) -> "iszero(" ^ string_of_expr e ^ ")"
;;

let string_of_type = function
      BoolT -> "Bool"
    | NatT -> "Nat"
;;

let parse (s : string) : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast

(******************************************************************************)
(*                                Type checking                               *)
(******************************************************************************)

exception TypeError of string;;

let rec typecheck = function
    True -> BoolT
  | False -> BoolT
  | Not(e) -> (match typecheck e with
        BoolT -> BoolT
      | NatT -> raise (TypeError (string_of_expr e ^ " has type Nat, but type Bool was expected")))
  | And(e1,e2) | Or(e1,e2) ->
    (match (typecheck e1,typecheck e2) with
       (BoolT,BoolT) -> BoolT
     | (NatT,_) -> raise (TypeError (string_of_expr e1 ^ " has type Nat, but type Bool was expected"))
     | (_,NatT) -> raise (TypeError (string_of_expr e2 ^ " has type Nat, but type Bool was expected")))
  | If(e0,e1,e2) -> (match (typecheck e0,typecheck e1,typecheck e2) with
        (NatT,_,_) -> raise (TypeError (string_of_expr e0 ^ " has type Nat, but type Bool was expected"))
      | (BoolT,t1,t2) when t1=t2 -> t1
      | (BoolT,t1,t2) -> raise (TypeError (string_of_expr e2 ^ " has type " ^ string_of_type t2 ^ ", but type " ^ string_of_type t1 ^ " was expected"))
)
  | Zero -> NatT
  | Succ(e) | Pred(e) ->
    (match typecheck e with
       NatT -> NatT
     | BoolT -> raise (TypeError (string_of_expr e ^ " has type Bool, but type Nat was expected")))
  | IsZero(e) -> (match typecheck e with
       NatT -> BoolT
     | BoolT -> raise (TypeError (string_of_expr e ^ " has type Bool, but type Nat was expected")))
;;

(******************************************************************************)
(*                            Small-step semantics                            *)
(******************************************************************************)

exception NoRuleApplies
exception PredOfZero

let rec is_succ = function
    Zero -> true
  | Succ(e) -> is_succ e
  | _ -> false
;;
  
let rec trace1 = function
    If(True,e1,_) -> e1
  | If(False,_,e2) -> e2
  | If(e0,e1,e2) -> let e0' = trace1 e0 in If(e0',e1,e2)
  | Not(True) -> False
  | Not(False) -> True
  | Not(e) -> let e' = trace1 e in Not(e')
  | And(True,e) -> e
  | And(False,_) -> False
  | And(e1,e2) -> let e1' = trace1 e1 in And(e1',e2)
  | Or(True,_) -> True
  | Or(False,e) -> e
  | Or(e1,e2) -> let e1' = trace1 e1 in Or(e1',e2)
  | Succ(e) -> let e' = trace1 e in Succ(e')
  | Pred(Zero) -> raise NoRuleApplies
  | Pred(Succ(e)) when is_succ e -> e
  | Pred(e) -> let e' = trace1 e in Pred(e')
  | IsZero(Zero) -> True
  | IsZero(Succ(e)) when is_succ e -> False    
  | IsZero(e) -> let e' = trace1 e in IsZero(e')    
  | _ -> raise NoRuleApplies
;;

let rec trace e = try
    let e' = trace1 e
    in e::(trace e')
  with NoRuleApplies -> [e]
;;

(******************************************************************************)
(*                              Big-step semantics                            *)
(******************************************************************************)

let rec eval = function
    True -> Bool true
  | False -> Bool false
  | Not(e) -> (match eval e with
        Bool b -> Bool(not b)
      | _ -> raise (TypeError "Not on nat")
    )
  | And(e1,e2) -> (match (eval e1,eval e2) with
        (Bool b1,Bool b2) -> Bool (b1 && b2)
      | _ -> raise (TypeError "Or on nat")
    )
  | Or(e1,e2) -> (match (eval e1,eval e2) with
        (Bool b1,Bool b2) -> Bool (b1 || b2)
      | _ -> raise (TypeError "Or on nat")
    ) 
  | If(e0,e1,e2) -> (match eval e0 with
        Bool b -> if b then eval e1 else eval e2
      | _ -> raise (TypeError "If on nat guard")
    )
  | Zero -> Nat 0
  | Succ(e) -> (match eval e with
        Nat n -> Nat (n+1)
      | _ -> raise (TypeError "Succ on bool")
    )
  | Pred(e) -> (match eval e with
      | Nat n when n>0 -> Nat (n-1)
      | _ -> raise (TypeError "pred on 0")
    )
  | IsZero(e) -> (match eval e with
      | Nat n -> Bool (n=0)
      | _ -> raise (TypeError "IsZero on bool")
    )
;;
