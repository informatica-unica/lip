open Ast

type loc = int

type envval = BVar of loc | IVar of loc
type memval = Bool of bool | Int of int

type env = ide -> envval
type mem = loc -> memval

exception TypeError of string
exception UnboundVar of ide
exception UnboundLoc of loc
exception NoRuleApplies

(* The third component of the state is the first free location.
   We assume that the store is unbounded *)
type state = { envstack : env list; memory : mem; firstloc : loc }

let getenv st = st.envstack
let getmem st = st.memory
let getloc st = st.firstloc

let setenv st envstack =
  { envstack; memory = st.memory; firstloc = st.firstloc }

let setmem st memory =
  { envstack = st.envstack; memory; firstloc = st.firstloc }

let setloc st firstloc =
  { envstack = st.envstack; memory = st.memory; firstloc }

let topenv st =
  match st.envstack with
  | [] -> failwith "empty environment stack"
  | e :: _ -> e

let popenv st =
  match st.envstack with
  | [] -> failwith "empty environment stack"
  | _ :: el' -> el'

let make_state envstack memory firstloc = { envstack; memory; firstloc }

let bind_env f x v y = if String.equal x y then v else f y
let bind_mem f x v y = if Int.equal x y then v else f y

let bottom_env : env = fun x -> raise (UnboundVar x)
let bottom_mem : mem = fun l -> raise (UnboundLoc l)

let state0 = make_state [bottom_env] bottom_mem 0

type conf = St of state | Cmd of cmd * state
