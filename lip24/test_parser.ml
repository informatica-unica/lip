open Tinyrust

(**
  The absolute path of the examples directory in your file system.

  To get this path, [cd] into the examples directory and run [pwd].
*)
let examples_dir = "/home/dalpi/tinyrust/test/examples/"

let examples =
  let full_name name = examples_dir ^ name in
  let files = Sys.readdir examples_dir in
  Array.sort String.compare files;
  Array.map full_name files

let read_file filename =
  let ch = open_in filename in
  let len = in_channel_length ch in
  let str = really_input_string ch len in
  close_in ch;
  str

let pr = Printf.printf

(** ------------------------------------------
    Start of parser tests
    ------------------------------------------ *)

let%test_unit "test_parser" =
  Array.iter
    (fun ex ->
      let p = read_file ex in
      try
        Parser.parse_string p |> ignore;
        pr "✔ %s\n" ex
      with _ ->
        pr "✘ Couldn't parse %s\n" ex)
    examples
