let parse' parser text =
  let lexbuf = Lexing.from_string text in
  try parser Lexer.read_token lexbuf
  with exn ->
    let pos = lexbuf.lex_start_p
    and errstr =
      match exn with
      | Lexer.Error chr -> Printf.sprintf "unexpected character '%s'" chr
      | Parser.Error -> "syntax error"
      | _ -> "unexpected error"
    in
    failwith
      (Printf.sprintf "line %d, column %d: %s%!" (pos.pos_lnum - 1)
         (pos.pos_cnum - pos.pos_bol)
         errstr)

let parse = parse' Parser.main
