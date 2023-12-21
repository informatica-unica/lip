exception IntrinsicOverride
exception WrongArguments of int * int (* number given, number expected *)
exception UndeclaredVariable of string

type loc = int
type ide = string
type memval = loc
type envval =
  | Loc of memval
  | Fun of (Ast.parameters * Ast.instruction)
  | Intrinsic of Ast.intrinsic

type memory = (* your memory type here *)
type environment = (* your environment type here *)
type env_stack = (* your stack type here *)

val find_mem : memory -> loc -> memval
val add_mem : memory -> loc -> memval -> unit
val update_mem : memory -> loc -> memval -> unit

val find_env : env_stack -> ide -> envval
val add_env : env_stack -> ide -> envval -> unit

val add_frame : env_stack -> unit
val pop_frame : env_stack -> environment

val add_var : env_stack -> memory -> ide -> unit
val add_var_init :env_stack -> memory -> ide -> int -> unit
val read_var : env_stack -> memory -> ide -> memval
val update_var : env_stack -> memory -> ide -> memval -> unit
val add_fun : env_stack -> ide -> Ast.parameters * Ast.instruction -> unit
val read_fun : env_stack -> ide -> Ast.parameters * Ast.instruction