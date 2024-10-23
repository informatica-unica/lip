type token =
  | LPAREN
  | RPAREN
  | ASSIGN
  | PLUS
  | SEQ
  | ID of string
  | CONST of string
  | EOF
  | ATOK
  | BTOK
  | CTOK
  | DTOK
  | ETOK

let string_of_token = function
  | LPAREN -> "LPAREN"
  | RPAREN -> "RPAREN"
  | ASSIGN -> "ASSIGN"
  | PLUS -> "PLUS"
  | SEQ -> "SEQ"
  | ID(s) -> "ID(" ^ s ^ ")"
  | CONST(s) -> "CONST(" ^ s ^ ")"
  | EOF -> "EOF"
  | ATOK -> "ATOK"
  | BTOK -> "BTOK"
  | CTOK -> "CTOK"
  | DTOK -> "DTOK"
  | ETOK -> "ETOK"