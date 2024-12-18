open Ast

type loc = int

type envval =
  | IVar of loc  (** location in memory *)
  | IFun of ide * cmd * expr  (** parameter name, body, return expr *)

type memval = int

type env = ide -> envval
(** The {b environment} maps identifiers to memory locations or functions. *)

type mem = loc -> memval
(** The {b memory} maps locations (addresses) to values. *)

exception TypeError of string
(** Raised when an operation is performed on an incompatible value. *)

exception UnboundVar of ide
(** Raised when trying to access an unknown identifier. *)

exception UnboundLoc of loc
(** Raised when trying to access an unknown location. *)

exception NoRuleApplies
(** Raised when an expression cannot take a step. *)

type state = { envstack : env list; memory : mem; firstloc : loc }
(** The type of states.
  The third component of the state is the first free location.
  We assume that the store is unbounded. *)

(** Constructor for state values. *)
let make_state envstack memory firstloc = { envstack; memory; firstloc }

(** Get the environment stack of a state. *)
let getenv st = st.envstack

(** Get the memory of a state. *)
let getmem st = st.memory

(** Get the location of a state. *)
let getloc st = st.firstloc

(** Replace the environment stack of a state. *)
let setenv st envstack = { st with envstack }

(** Replace the memory of a state *)
let setmem st memory = { st with memory }

(** Replace the first location of a state. *)
let setloc st firstloc = { st with firstloc }

(** [topenv st] is the topmost environment of [st]. *)
let topenv st =
  match st.envstack with
  | [] -> failwith "empty environment stack"
  | e :: _ -> e

(** [popenv st] is the environment stack of [st] without the top environment. *)
let popenv st =
  match st.envstack with
  | [] -> failwith "empty environment stack"
  | _ :: el' -> el'

(** [pushenv st env] is the environment stack of [st] with [env] on top. *)
let pushenv st env = env :: st.envstack

(** [bind_env env x v] returns a new environment where [x] is bound to [v] on top of [env]. *)
let bind_env (old_env : env) (x : ide) (v : envval) : env =
 fun y -> if String.equal x y then v else old_env y

(** Like [bind_env] but for binding on top of [mem]. *)
let bind_mem (old_mem : mem) (x : loc) (v : memval) : mem =
 fun y -> if Int.equal x y then v else old_mem y

(** The environment where every identifier is unbound. *)
let bottom_env : env = fun x -> raise (UnboundVar x)

(** The memory where every location is unbound. *)
let bottom_mem : mem = fun l -> raise (UnboundLoc l)

(** The initial state, from which all computations begin. *)
let state0 = make_state [ bottom_env ] bottom_mem 0

(** [apply st x] is the value bound to the identifier [x] in the current state.
  @raise TypeError if [x] is bound to a function.
*)
let apply (st : state) (x : ide) : memval =
  match (topenv st) x with
  | IVar l -> (getmem st) l
  | IFun _ -> raise (TypeError "%d is a function, but I expected a value here.")

(** [apply_fun st f] is the function data bound to the identifier [f] in the current state.
  @raise TypeError if [f] is bound to a value.
*)
let apply_fun (st : state) (x : ide) : ide * cmd * expr =
  match (topenv st) x with
  | IFun (par, body, e) -> (par, body, e)
  | IVar _ -> raise (TypeError "%d is a value, but I expected a function here.")

(** [bind_ivar st x v] returns a new state where the integer variable [x] points to the value [v].
  @raise TypeError if [x] is bound to a function.
*)
let bind_ivar (st : state) x v =
  let env = topenv st in
  match env x with
  | IVar l ->
      let mem' = bind_mem st.memory l v in
      setmem st mem'
  | IFun (f, _, _) ->
      raise
        (TypeError
           (Printf.sprintf
              "Can't assign %d to %s because %s was declared a function." v f f))

(** The type of small-step semantics configurations. *)
type conf = St of state | Cmd of cmd * state
