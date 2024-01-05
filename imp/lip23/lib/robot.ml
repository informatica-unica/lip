let robot_speed = 7
let turn_speed = 50
let turn_incr = 1
let accel = 10
let collision = 5

let click = 10
let max_x = 1000
let max_y = 1000

let scan_duration = 5

let trig_scale = 100_000.
let res_limit = 10

let deg2rad = Float.pi /. 180.
let rad2deg = 180. /. Float.pi

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
  mutable turret_heading : int;
  mutable last_heading : int;
  mutable d_heading : int;
  mutable scan_degrees : int;
  mutable scan_cycles : int;
  mutable scan_res : int;
  mutable reload : int;
  mutable program : Ast.program;
  mutable ep : Ast.expression;
  mutable env : Memory.env_stack;
  mutable mem : Memory.memory;
  mutable missiles : Missile.t array;
}

let init () =
  {
    status = ALIVE;
    name = "foo";
    x = 0;
    y = 0;
    org_x = 0;
    org_y = 0;
    range = 0;
    last_x = 0;
    last_y = 0;
    damage = 0;
    last_damage = 0;
    speed = 0;
    last_speed = 0;
    d_speed = 0;
    accel = 0;
    heading = 0;
    turret_heading = 0;
    last_heading = 0;
    d_heading = 0;
    scan_degrees = 0;
    scan_cycles = 0;
    scan_res = 0;
    reload = 0;
    missiles = Array.init 2 (fun _ -> Missile.init ());
    program = EMPTY;
    ep = CALL ("main", []);
    env = Memory.init_stack ();
    mem = Memory.init_memory ();
  }

let cur_robot = ref (init ())
let all_robots = ref [||]

let degree_of_int d = abs d mod 360
let perc_of_int n = max 0 n |> min 100

let scan degree resolution =
  let res = if abs resolution > res_limit then res_limit else resolution in
  let degree = degree_of_int degree in
  let close_dist = ref 0. in
  !cur_robot.scan_cycles <- scan_duration;
  !cur_robot.scan_degrees <- degree;
  !cur_robot.scan_res <- res;
  Array.iter
    (fun r ->
      if r.status <> DEAD then (
        let x = (!cur_robot.x / click) - (r.x / click) |> float_of_int in
        let y = (!cur_robot.y / click) - (r.y / click) |> float_of_int in
        let d = ref 0 in

        if x <> 0. then
          let d' = Float.atan (y /. x) *. rad2deg |> int_of_float in
          match (r.x >= !cur_robot.x, r.y >= !cur_robot.y) with
          | true, true -> d := d' (* 1st quadrant *)
          | true, false -> d := 360 + d' (* 4th quadrant *)
          | _ -> d := 180 + d' (* 2nd - 3rd quadrant *)
        else d := if r.y > !cur_robot.y then 90 else 270;

        let b = if degree > res && degree < 360 - res then 0 else 180 in
        let dd = b + degree in
        let d1 = b + !d - res in
        let d2 = b + !d + res in

        if dd >= d1 && dd <= d2 then
          let distance = Float.sqrt ((x *. x) +. (y *. y)) in
          if distance < !close_dist || !close_dist = 0. then
            close_dist := distance))
    !all_robots;
  !close_dist |> int_of_float

let cannon degree range =
  let range = if range > Missile.mis_range then Missile.mis_range else range in
  let degree = degree_of_int degree in
  if range <= 0 then 1
  else if !cur_robot.reload > 0 then 0
  else
    try
      Array.iter
        (fun (m : Missile.t) ->
          if m.status = AVAIL then (
            !cur_robot.turret_heading <- degree;
            !cur_robot.reload <- Missile.reload_cycles;
            m.status <- FLYING;
            m.beg_x <- !cur_robot.x;
            m.beg_y <- !cur_robot.y;
            m.cur_x <- !cur_robot.x;
            m.cur_y <- !cur_robot.y;
            m.heading <- degree;
            m.range <- range * click;
            m.travelled <- 0;
            m.count <- Missile.explosion_cycles;
            raise Exit))
        !cur_robot.missiles;
      0
    with Exit -> 1

let drive degree speed =
  !cur_robot.d_heading <- degree_of_int degree;
  !cur_robot.d_speed <- perc_of_int speed

let damage () = !cur_robot.damage

let speed () = !cur_robot.speed

let loc_x () = !cur_robot.x / click

let loc_y () = !cur_robot.y / click

let rand = Random.int

let sqrt x = abs x |> float_of_int |> Float.sqrt |> Float.round |> int_of_float

let int_trig ?(fact = 1.) f x =
  degree_of_int x |> float_of_int |> ( *. ) deg2rad |> f |> ( *. ) fact
  |> Float.round |> int_of_float

let sin = int_trig Float.sin ~fact:trig_scale

let cos = int_trig Float.cos ~fact:trig_scale

let tan = int_trig Float.tan ~fact:trig_scale

let atan x =
  x |> float_of_int
  |> ( *. ) (1. /. trig_scale)
  |> Float.atan |> ( *. ) rad2deg |> Float.round |> int_of_float
