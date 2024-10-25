type token =
  | LPAREN
  | RPAREN
  | ASSIGN
  | PLUS
  | SEQ
  | ATOK of string
  | BTOK of string
  | CTOK of string
  | DTOK of string
  | ETOK of string
  | ID of string
  | CONST of string
  | EOF
  
(* aggiungi token es2 qui sopra *)

let string_of_token = function
  | LPAREN -> "LPAREN"
  | RPAREN -> "RPAREN"
  | ASSIGN -> "ASSIGN"
  | PLUS -> "PLUS"
  | SEQ -> "SEQ"
  | ATOK(s) -> "ATOK(" ^ s ^ ")"
  | BTOK(s) -> "BTOK(" ^ s ^ ")"
  | CTOK(s) -> "CTOK(" ^ s ^ ")"
  | DTOK(s) -> "DTOK(" ^ s ^ ")"
  | ETOK(s) -> "ETOK(" ^ s ^ ")"
  | ID(s) -> "ID(" ^ s ^ ")"
  | CONST(s) -> "CONST(" ^ s ^ ")"
  | EOF -> "EOF"
  
