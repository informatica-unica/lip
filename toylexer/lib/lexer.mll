{
  open Token
}

(* espressioni regolari *)
let white = [' ' '\t']+
let capital = ['A'-'Z']
let letter = ['a'-'z' 'A'-'Z']
let chr = ['a'-'z' 'A'-'Z' '0'-'9']
let low_vowels = ['a']|['e']|['i']|['o']|['u']
let vowels = ['a']|['e']|['i']|['o']|['u']|['A']|['E']|['I']|['O']|['U']
let consonant = ['b'-'d' 'f'-'h' 'j'-'n' 'p'-'t' 'v'-'z' 'B'-'D' 'F'-'H' 'J'-'N' 'P'-'T' 'V'-'Z']
let num = ['0'-'9']|['1'-'9']['0'-'9']*
let atok = capital chr*
let btok = low_vowels+ 
let ctok = consonant* vowels? consonant*
let dtok = ['-']? num ['.']? num
let etok = ['0'] (['x']|['X']) chr*
let id = letter chr* 

(* associazioni simboli con token *)
(* lavora come questo *)  
rule read_token =
  parse
  | white { read_token lexbuf }  
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "=" { ASSIGN }
  | "+" { PLUS }
  | ";" { SEQ }  
  | atok { ATOK (Lexing.lexeme lexbuf) }
  | btok { BTOK (Lexing.lexeme lexbuf) }
  | ctok { CTOK (Lexing.lexeme lexbuf) }
  | dtok { DTOK (Lexing.lexeme lexbuf) }
  | etok { ETOK (Lexing.lexeme lexbuf) }
  | id { ID (Lexing.lexeme lexbuf) }
  | num { CONST (Lexing.lexeme lexbuf) }  
  | eof { EOF }
  
