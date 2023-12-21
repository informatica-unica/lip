open Crobots

let usage_msg = "crobots <robot-program>"

module Cmd = struct
  let parse () =
    let input_files = ref [] in

    let speclist = [] in
    let anon_fun filename = input_files := filename :: !input_files in
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
   with _ -> close_in_noerr ic);
  !out

let loop () =
  let instr_per_update = 20 in
  let clock = ref 0 in
  let open Robot in
  while true do
    Array.iter
      (fun r ->
        cur_robot := r;
        r.ep <- Trace.trace1_expr r.ep;
        Memory.janitor r.env r.mem)
      !all_robots;
    Prettyprint.string_of_all_robots !all_robots |> print_endline;

    if !clock = instr_per_update then (
      update_all_robots !all_robots;
      clock := 0);

    clock := !clock + 1;

    (* Unix.sleepf 0.01 *)
  done

let _ =
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
  let robots =
    List.map
      (fun (f, p) ->
        let r = init () in
        cur_robot := r;
        r.mem <- Memory.init_memory ();
        r.env <- Memory.init_stack ();
        Trace.trace_instr (Instr p) |> ignore;
        r.name <- f;
        r.program <- p;
        r.x <- Random.int 1000;
        r.last_x <- r.x;
        r.org_x <- r.x;
        r.y <- Random.int 1000;
        r.last_y <- r.y;
        r.org_y <- r.y;
        r)
      programs
  in
  all_robots := Array.of_list robots;
  loop ()
