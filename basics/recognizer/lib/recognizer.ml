let rec lang1 l = match l with 
  []->false
  |[0]->true
  |[1]->true
  |0::tl ->lang1 tl
  |1::tl -> lang1 tl
  |_::tl ->false

;;

let rec lang2 l2 = match l2 with 
  []->true
  |[0]->true
  |[1]->true
  |1::tl -> lang2 tl 
  |0::tl -> List.for_all(fun x -> x <> 0) tl
  |_::tl ->false

;;

let rec lang3 l3 = match l3 with
  []->false
  |0::tl -> (match List.rev l3 with
              | 0::tl -> List.for_all (fun x -> x = 0 || x = 1) l3
              | _ -> false)
  |_->false

let rec lang4C l4 c = match l4 with
  []-> if c = 2 then true else false
  |0::tl -> lang4C tl c
  |1::tl -> if c < 2 then lang4C tl (c+1) else false
  |_::tl -> false

let lang4 l4 = 
  lang4C l4 0

  let rec check_lang5 l5 =  match l5 with
  []->true
  | 0::0::tl -> check_lang5 tl 
  | 1::1::tl -> check_lang5 tl
  | _ -> false

let lang5 l5 =
    if l5 = [] then false  
    else if List.length l5 mod 2 = 1 then false else check_lang5 l5 
  
    
let recognizers = [lang1;lang2;lang3;lang4;lang5]
                  
let belongsTo w = List.map (fun f -> f w) recognizers
  
