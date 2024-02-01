exception IntrinsicOverride
(* raised when a user program attempts to redefine an intrinsic function *)

exception UndeclaredVariable of string
(* [UndeclaredVariable x] is raised when a user program attempts to use the
   undeclared variable [x] *)

type loc = int
(* the type of memory locations or addresses *)

type ide = string
(* the type of variable names *)

type memval = int
(* the type of memory items *)

type envval =
  | Loc of loc
  | Fun of (Ast.parameters * Ast.instruction)
  | Intrinsic of Ast.intrinsic
(* the type of environment items *)

type memory
(* a map from loc to memval *)

type environment
(* a map from ide to envval *)

type stackval
(* the type of stack items *)

type env_stack
(* a stack of stackval *)

(* you may expose these types for debugging/convenience *)

val init_memory : unit -> memory
(* initializes an empty memory *)

val init_stack : unit -> env_stack
(* initializes a stack with an environment defining the intrinsic functions *)

val find_mem : memory -> loc -> memval
(* memory lookup *)

val add_mem : memory -> loc -> memval -> unit (* return type depends on your memory type *)
(* [add_mem mem loc n] binds the memory location [loc] to the value [n] *)

val update_mem : memory -> loc -> memval -> unit (* return type depends on your memory type *)
(* [update_mem mem loc n] updates the value bound to [loc] to [n] *)

val find_env : env_stack -> ide -> envval
(* [find_env env x] reads the environemnt value bound to the name [x] in the
   current environment *)

val add_env : env_stack -> ide -> envval -> unit (* return type depends on your stack type *)
(* [add_env env x v] binds the name [x] to the environment value [v] in the
   current environment *)

val add_frame : env_stack -> unit (* return type depends on your stack type *)
(* pushes a copy of the top environment to the stack *)

val pop_frame : env_stack -> stackval
(* pops and returns the top environment *)

(* add your own types and values below *)
