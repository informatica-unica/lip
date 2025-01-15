let pr = Printf.printf

let spr = Printf.sprintf

(**
  Replace the string below with the absolute path of the examples
  directory in your file system.

  To get this path, [cd] into the examples directory and run [pwd].
*)
let examples_dir = "/absolute/path/to/tinyrust/examples/"

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

(** associative array, mapping filename to content *)
let examples_dict : (string * string) array =
  let examples = Sys.readdir examples_dir in
  Array.sort String.compare examples;
  Array.map (fun e -> (e, read_file (examples_dir ^ e))) examples
