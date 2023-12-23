type status = ALIVE | DEAD

type t = {
  mutable status : status;
  mutable name : string;
  mutable x : int;
  mutable y : int;
  mutable org_x : int;
  mutable org_y : int;
  mutable range : int;
  mutable last_x : int;
  mutable last_y : int;
  mutable damage : int;
  mutable last_damage : int;
  mutable speed : int;
  mutable last_speed : int;
  mutable d_speed : int;
  mutable accel : int;
  mutable heading : int;
  mutable last_heading : int;
  mutable d_heading : int;
  mutable scan_degrees : int;
  mutable reload : int;
  mutable program : Ast.program;
  mutable ep : Ast.expression;
  mutable env : Memory.env_stack;
  mutable mem : Memory.memory;
  mutable missiles : Missile.t array;
}
(* the type of a robot *)

val init : unit -> t
(* creates a new robot *)

val cur_robot : t ref
val all_robots : t array ref

val update_robot : int -> t -> unit
val update_all_robots : t array -> unit

val scan : int -> int -> int
(* invokes the robot's scanner, at a specified
   degree and resolution.
   returns 0 if no robots are within the scan
   range or a positive integer representing
   the range to the closest robot *)

val cannon : int -> int -> int
(* fires a missile heading a specified range
   and direction.
   returns 1 (true) if a missile was fired,
   or 0 (false) if the cannon is reloading *)

val drive : int -> int -> unit
(* activates the robot's drive mechanism, on
   a specified heading and speed *)

val damage : unit -> int
(* returns the current percent of damage incurred *)

val speed : unit -> int
(* returns the current percent of speed *)

val loc_x : unit -> int
(* returns the robot's current x axis location *)

val loc_y : unit -> int
(* returns the robot's current y axis location *)

val rand : int -> int
(* returns a random number between 0 and limit *)

val sqrt : int -> int
(*returns the square root of a number, made
  positive if necessary *)

val sin : int -> int
val cos : int -> int
val tan : int -> int
(* trigonometric values.
   sin(), cos(), and tan(), take a degree
   argument, 0-359, and returns the trigonometric
   value times 100,000 *)

val atan : int -> int
(* takes a ratio argument that has been scaled up
   by 100,000, and returns a degree value,
   between -90 and +90. *)
