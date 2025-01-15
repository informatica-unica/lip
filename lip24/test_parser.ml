open Tinyrust
open Common

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
