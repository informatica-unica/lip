open Recognizer
    
(* read one line from standard input, and output it to a string *)

let read_line () =
  try Some(read_line())
  with End_of_file -> None

(* convert a string to a list of char *)

let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []

let string_of_list s l =
  assert (List.length l = 5);
  if List.for_all (fun x -> x=false) l
  then s ^ " does not belong to any of the languages"
  else s ^ " belongs to languages: " ^ (List.fold_left (fun s i -> s ^ (if s="" then "" else ",") ^ string_of_int (i+1)) "" ((List.filter (fun i -> i>=0) (List.mapi (fun i b -> if b then i else -1) l))))
    
(* main routine *)
    
let () = match read_line () with
    Some s -> let l = belongsTo (explode s) in
    print_endline (string_of_list s l)
  | None -> print_endline "no winner"
