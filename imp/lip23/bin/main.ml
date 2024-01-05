open Crobots

let usage_msg = "crobots <robot-programs>"

module Cmd = struct
  let parse () =
    let input_files = ref [] in

    let speclist = [] in
    let anon_fun filename = input_files := !input_files @ [ filename ] in
    Arg.parse speclist anon_fun usage_msg;

    match !input_files with
    | [] ->
        Arg.usage speclist usage_msg;
        print_endline "missing program, goodbye";
        exit 0
    | l -> l
end

let read_file filename =
  let ic = open_in filename in
  let out = ref "" in
  (try
     while true do
       let line = input_line ic in
       out := !out ^ "\n" ^ line
     done
   with End_of_file -> close_in_noerr ic);
  !out

let motion_cycles = 15
let movement = ref motion_cycles

let rec loop () =
  let open Robot in
  let robots_left =
    Array.fold_left
      (fun n r -> n + if r.status = ALIVE then 1 else 0)
      0 !all_robots
  in
  if robots_left > 1 then (
    Array.iter
      (fun r ->
        try
          match r.status with
          | ALIVE ->
              cur_robot := r;
              r.ep <- Trace.trace1_expr (r.env, r.mem) r.ep
          | DEAD -> ()
        with Trace.NoRuleApplies ->
          r.ep <- CALL ("main", []);
          r.env <- Memory.init_stack ();
          r.mem <- Memory.init_memory ();
          Trace.trace_instr (r.env, r.mem) (Instr r.program) |> ignore)
      !all_robots;

    decr movement;
    if !movement <= 0 then (
      Motion.update_all_robots !all_robots;
      movement := motion_cycles);

    flush stdout;
    loop ())

let rand_pos () =
  let lt2 x = if x < 2 then 1 else 0 in
  let a =
    Array.init 4 (fun k ->
        ( Random.int (Robot.max_x / 2) + (Robot.max_x / 2 * (k mod 2)),
          Random.int (Robot.max_y / 2) + (Robot.max_y / 2 * lt2 k) ))
  in
  Array.sort (fun _ _ -> -1 + Random.int 3) a;
  a

let _ =
  Printexc.record_backtrace true;
  Random.init (Unix.time () |> int_of_float);

  let filenames = Cmd.parse () in
  let programs = List.map (fun f -> (f, read_file f)) filenames in
  let programs =
    match programs with
    | [ p ] -> [ p; p ]
    | ps -> ps
  in
  let programs =
    List.map
      (fun (f, p) ->
        let p = Main.parse p in
        Printf.printf "%s compiled with no errors.\n" f;
        (f, p))
      programs
  in
  let open Robot in
  let init_pos = rand_pos () in
  let robots =
    List.mapi
      (fun i (f, p) ->
        let r = init () in
        let init_x, init_y = init_pos.(i) in
        cur_robot := r;
        Trace.trace_instr (r.env, r.mem) (Instr p) |> ignore;
        r.name <- f;
        r.program <- p;
        r.x <- init_x * click;
        r.last_x <- r.x;
        r.org_x <- r.x;
        r.y <- init_y * click;
        r.last_y <- r.y;
        r.org_y <- r.y;
        r)
      programs
  in
  all_robots := Array.of_list robots;

  Printexc.print loop ();

  (* allow any flying missile to explode *)
  while
    Array.exists
      (fun r ->
        Array.exists (fun (m : Missile.t) -> m.status <> AVAIL) r.missiles)
      !all_robots
  do
    decr movement;
    if !movement <= 0 then (
      Motion.update_all_robots !all_robots;
      movement := motion_cycles)
  done;

  let winner =
    Array.fold_left
      (fun acc r ->
        match r.status with
        | ALIVE -> Some r
        | _ -> acc)
      None !all_robots
  in

  let winner_msg =
    Option.fold ~none:"It's a tie"
      ~some:(fun r -> Printf.sprintf "%s is the winner" r.name)
      winner
  in

  print_endline winner_msg
