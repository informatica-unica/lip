{
  open Token
}

let white = [' ' '\t']+
let letter = ['a'-'z' 'A'-'Z']
let chr = ['a'-'z' 'A'-'Z' '0'-'9']
let id = letter chr*
let num = ['0'-'9']|['1'-'9']['0'-'9']*

let regExpFirstUP = ['A'-'Z']['a'-'z' 'A'-'Z' '0'-'9']*
let vowelLC = ['a''e''i''o''u']
let vowelUC = ['A''E''I''O''U']
let noVowels = ['a'-'z' 'A'-'Z' '0'-'9'] # (vowelLC | vowelUC)
let onlyOneVowel = noVowels* (vowelLC | vowelUC)? noVowels*
let dtok = ['-']?['0'-'9']*['.']?['0'-'9']+
let etok = '0'('X'|'x')['0'-'9''A'-'F''a'-'f']*
rule read_token =
  parse
  | white { read_token lexbuf }  
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "=" { ASSIGN }
  | "+" { PLUS }
  | ";" { SEQ }  
  | id { ID (Lexing.lexeme lexbuf) }
  | num { CONST (Lexing.lexeme lexbuf) }    
  | eof { EOF }
  | etok {ETOK}
  | regExpFirstUP {ATOK}
  | vowelLC* {BTOK}
  | onlyOneVowel {CTOK}
  | dtok {DTOK}
  
  
  