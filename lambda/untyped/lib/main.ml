open Ast

let rec string_of_term = function
    Var x -> x
  | Abs(x,t) -> "fun " ^ x ^ ". " ^ string_of_term t
  | App(Var x,Var y) -> x ^ " " ^ y
  | App(Var x,t2) -> x ^ " (" ^ string_of_term t2 ^ ")"
  | App(t1,Var x) -> "(" ^ string_of_term t1 ^ ") " ^ x
  | App(t1,t2) -> "(" ^ string_of_term t1 ^ ") (" ^ string_of_term t2 ^ ")"

let parse (s : string) : term =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast


(**********************************************************************
 size : term -> int
 **********************************************************************)

let rec size = function
    Var _ -> 1
  | Abs(_,t) -> 1 + size t
  | App(t1,t2) -> size t1 + size t2


(**********************************************************************
 max_nat : term -> int

 max_nat t computes the least n such that: 
 for all i : xi in vars_of_term t => i < n
  **********************************************************************)

let rec vars_of_term = function
    Var x -> [x]
  | Abs(x,t) -> x::(vars_of_term t)
  | App(t1,t2) -> (vars_of_term t1) @ (vars_of_term t2)

let rec pow a = function
  | 0 -> 1
  | 1 -> a
  | n -> let b = pow a (n / 2) in
    b * b * (if n mod 2 = 0 then 1 else a)
            
let is_digit = function '0' .. '9' -> true | _ -> false

let explode s = List.map (fun x -> String.make 1 x |> int_of_string) (List.filter is_digit (List.init (String.length s) (String.get s)))

let nat_of_var xl = List.fold_left (fun x y -> x + y) 0 (List.mapi (fun i x -> x * (pow 10 i)) (List.rev (explode xl)))

let rec max_of_list = function 
  | [] -> 0
  | x::xs -> max x (max_of_list xs)
                
let max_nat t =
  let xl = vars_of_term t in
  let nl = List.map nat_of_var xl in
  1 +  max_of_list nl


(**********************************************************************
 is_free : string -> term -> bool

 Usage: is_free x t = true iff the variable x occurs free in t
 **********************************************************************)
let rec is_free x = function
    Var y when y=x -> true
  | Var _ -> false
  | Abs(y,_) when y=x -> false
  | Abs(_,t) -> is_free x t
  | App(t1,t2) -> is_free x t1 || is_free x t2


(**********************************************************************
 rename : string -> string -> term -> term

 Usage: rename x x' t replaces all free occurrences of x in t as x'

 Pre: x' does not occur (free or bound) in t
 **********************************************************************)

let rec rename x x' = function
    Var y when y=x  -> Var x'
  | Var y when y=x' -> failwith ("name " ^ x' ^ " must be fresh!")
  | Var y -> Var y
  | App(t1,t2) -> App(rename x x' t1,rename x x' t2)
  | Abs(y,t1) when y=x -> Abs(y,t1)
  | Abs(y,_) when y=x' -> failwith ("name " ^ x' ^ " must be fresh!")
  | Abs(y,t1) -> Abs(y,rename x x' t1)


(**********************************************************************
 equiv : term -> term -> bool

 Usage: equiv t1 t2 = true iff t1 and t2 are alpha-equivalent
 **********************************************************************)

let rec equiv_rec t1 t2 vars = match (t1,t2) with
    (Var x1,Var x2) when x1=x2 -> (true,vars)
  | (App(t11,t12),App(t21,t22)) ->
    let (b1,vars1) = equiv_rec t11 t21 vars in
    if not b1 then (false,vars1)
    else equiv_rec t12 t22 vars1
  | (Abs(x1,t1'),Abs(x2,t2')) when x1=x2 -> equiv_rec t1' t2' vars
  | (Abs(x1,t1'),Abs(x2,t2')) ->
    let x' = "x" ^ (string_of_int vars) in
    let t1'' = rename x1 x' t1'
    and t2'' = rename x2 x' t2' in equiv_rec t1'' t2'' (vars+1)
  | _ -> (false,vars)
                   
let equiv t1 t2 = fst (equiv_rec t1 t2 (max (max_nat t1) (max_nat t2)))
                   
(* bugged: ("fun x . (fun y . x)", "fun y . (fun x . y)", true);
 * Exception: Failure "name f must be fresh!"
let rec equiv t1 t2 = match (t1,t2) with
    (Var x1,Var x2) when x1=x2 -> true
  | (App(t11,t12),App(t21,t22)) -> equiv t11 t21 && equiv t12 t22
  | (Abs(x1,t1'),Abs(x2,t2')) when x1=x2 -> equiv t1' t2'
  | (Abs(x1,t1'),Abs(x2,t2')) -> let t2'' = rename x2 x1 t2' in equiv t1' t2''
  | _ -> false
*)

(**********************************************************************
 subst : string -> term -> int -> term -> term * int

 Usage: subst x t1 vars t2 = ([x -> t1] t2,vars')  
        where vars is the index of the next variable to be used for renaming
        and vars' is the next available index after the substitution
 **********************************************************************)

let rec subst x t vars = function
    Var y when x=y -> (t,vars)
  | Var y -> (Var y,vars)
  | App(t1,t2) -> let (t1',vars1) = subst x t vars t1 in
    let (t2',vars2) = subst x t vars1 t2 in (App(t1',t2'),vars2)
  | Abs(y,t1) when y=x -> (Abs(y,t1),vars)
  | Abs(y,t1) when  not (is_free y t) ->
    let (t1',vars1) = subst x t vars t1 in (Abs(y,t1'),vars1)
  | Abs(y,t1) -> (* y free in t: rename y in t and then subst *)
    let y' = "x" ^ (string_of_int vars) in 
    let t1' = rename y y' t1 in
    let (t1'',vars1) = subst x t (vars+1) t1' in (Abs(y',t1''),vars1)

(**********************************************************************
 is_val : term -> bool

 Usage: is_val t = true iff t is a value (i.e., a lambda-abstraction)
 **********************************************************************)

let is_val = function
    Abs(_,_) -> true
  | _ -> false


exception NoRuleApplies

(**********************************************************************
 trace1 : int -> term -> term * int

 Usage: trace1 vars t performs 1 step of the small-step call-by-value semantics,
 returning the obtained term and the index of the first fresh variable

 Pre:  xk does not occur in t, for all k>=vars

 Post: if trace1 i t = (t',i') then xk does not occur in t', for all k>=i'
 **********************************************************************)

let rec trace1 vars = function
  | App(t1,t2) when not (is_val t1) ->
    let (t1',vars') = trace1 vars t1 in (App(t1',t2),vars')
  | App(v1,t2) when not (is_val t2) ->
    let (t2',vars') = trace1 vars t2 in (App(v1,t2'),vars')
  | App(Abs(x,t12),v2) -> subst x v2 vars t12
  | _ -> raise NoRuleApplies


(**********************************************************************
 trace_rec : int -> int -> term -> term list

 Usage: trace_rec n i t performs n steps of the small-step semantics,

 Pre:  xk does not occur in t, for all k>=i
 **********************************************************************)

let rec trace_rec n vars t =
  if n<=0 then [t]
  else try
      let (t',vars') = trace1 vars t
      in t::(trace_rec (n-1) vars' t')
    with NoRuleApplies -> [t]

(**********************************************************************
 trace : int -> term -> term list

 Usage: trace n t performs n steps of the small-step semantics
 **********************************************************************)

let trace n t = trace_rec n (max_nat t) t
