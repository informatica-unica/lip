type term =
    Var of string
  | Abs of string * term
  | App of term * term
;;

let t_id = Abs("x",Var "x")
let t_omega = Abs("x",App(Var "x",Var "x"))
  
let t_tru = Abs("t",Abs("f",Var "t"))
let t_fls = Abs("t",Abs("f",Var "f"))
let t_ift = Abs("g",Abs("t",Abs("e",App(App(Var "g",Var "t"),Var "e"))))
let t_and = Abs("b",Abs("c",App(App(Var "b",Var "c"),t_fls)))

let t_pair = Abs("f",Abs("s",Abs("b",App(App(Var "b",Var "f"),Var "s"))))
let t_fst = Abs("p",App(Var "p",t_tru))
let t_snd = Abs("p",App(Var "p",t_fls))    

let rec t_nat_rec = function
    0 -> Var "z"
  | n -> App(Var "s",t_nat_rec (n-1))
    
let t_nat n = Abs("s",Abs("z",t_nat_rec n))

let t_scc = Abs("n",Abs("s",Abs("z",App(Var "s",App(App(Var "n",Var "s"),Var "z")))))

let s_id  = "(fun x . x)"
let s_omega = "(fun x. x x)"

let s_tru = "(fun t. fun f. t)"
let s_fls = "(fun t. fun f. f)"
let s_ift = "(fun g. fun t. fun e. g t e)"
let s_and = "(fun b. fun c. b c fls)"  
 
let s_pair = "fun f . fun s . fun b . b f s"
let s_fst = "fun p . p tru"
let s_snd = "fun p . p fls"    
    
