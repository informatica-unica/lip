{
open Parser
}

let white = [' ' '\t']+
let letter = ['a'-'z' 'A'-'Z']
let chr = ['a'-'z' 'A'-'Z' '0'-'9']
let id = letter chr*

rule read =
  parse
  | white { read lexbuf }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "true" { TRUE }
  | "false" { FALSE }
  | "not" { NOT }
  | "and" { AND }
  | "or" { OR }    
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "0" { ZERO }
  | "succ" { SUCC }  
  | "pred" { PRED }
  | "iszero" { ISZERO }  
  | "fun" { ABS }
  | "bool" { BOOL }
  | "nat" { NAT }
  | "->" { ARR } 
  | "." { DOT }
  | ":" { COLON }
  | id { VAR (Lexing.lexeme lexbuf) } 
  | eof { EOF }
