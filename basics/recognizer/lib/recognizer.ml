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
  |0::tl -> (match List.rev tl with
              | 0::tl -> List.for_all (fun x -> x = 0 || x = 1) tl
              | _ -> false)
  |_->false

let lang4 _ = failwith ""

let lang5 _ = failwith ""
    
let recognizers = [lang1;lang2;lang3;lang4;lang5]
                  
let belongsTo w = List.map (fun f -> f w) recognizers
  
