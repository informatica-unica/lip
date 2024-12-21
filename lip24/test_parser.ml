open Tinyrust

(**
  The absolute path of the examples directory in your file system.

  To get this path, [cd] into the examples directory and run [pwd].
*)
let examples_dir = "/home/dalpi/tinyrust/test/examples/"

let abs_path name = examples_dir ^ name

let examples =
  let dirs = Sys.readdir examples_dir in
  Array.sort String.compare dirs;
  dirs

let pr = Printf.printf

(** ------------------------------------------
    Start of parser tests
    ------------------------------------------ *)

let read_file filename =
  let ch = open_in filename in
  let str = really_input_string ch (in_channel_length ch) in
  close_in ch;
  str

let%test_unit "test_parser" =
  Array.iteri
    (fun _ ex ->
      let p = read_file (abs_path ex) in
      try
        Parser.parse_string p |> ignore;
        pr "[OK] %s" ex
      with _ ->
        pr "[ERROR] couldn't parse %s" ex;
        print_newline ())
    examples
