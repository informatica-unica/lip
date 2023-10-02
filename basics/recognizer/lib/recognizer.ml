let lang1 _ = failwith ""

let lang2 _ = failwith ""

let lang3 _ = failwith ""

let lang4 _ = failwith ""

let lang5 _ = failwith ""
    
let recognizers = [lang1;lang2;lang3;lang4;lang5]
                  
let belongsTo w = List.map (fun f -> f w) recognizers
  
