let rec lang1 (l : char list)= match l with
  [] -> false
  |['1'] -> true
  |['0'] -> true
  | a :: tail -> if(a=='0' || a=='1') then lang1 tail else false;;

let rec lang2 (l : char list)= match l with
  [] -> true
  |['0'] -> true
  |['1'] -> true
  | a :: tail -> if(a=='1' || a=='0') then lang2 tail else false;;

let rec lang3_1 (l : char list) = match l with
  [] -> false
  |['0'] -> true
  |['1'] -> false
  | a :: tail -> if(a=='0' || a=='1') then lang3_1 tail else false;;
let lang3 (l : char list)= match l with
  [] -> false
  | a :: tail -> if(a=='0') then lang3_1 tail else false;;

let rec lang4_2 (l : char list) = match l with
  [] -> false
  |['0'] -> true
  | a :: tail -> if(a=='0') then lang4_2 tail else false;;
let rec lang4_1 (l : char list) = match l with
  [] -> false
  | a :: tail -> if(a=='1') then lang4_2 tail else if(a=='0') then lang4_1 tail else false;;
let rec lang4 (l : char list) = match l with
  [] -> false
  | a :: tail -> if(a=='1') then lang4_1 tail else if(a=='0') then lang4 tail else false;;

let rec lang5 (l : char list) = match l with
  [] -> false
  | a :: tail -> if(a=='0') then lang5_0 tail else if (a=='1') then lang5_1 tail else false
and lang5_0 (l : char list) = match l with
  [] -> false
  | a :: tail -> if(a=='0') then lang5_2 tail else false
and lang5_1 (l : char list) = match l with
  [] -> false
  | a :: tail -> if(a=='1') then lang5_2 tail else false
and lang5_2 (l : char list) = match l with
  [] -> true
  | a :: tail -> if(a=='0') then lang5_0 tail else if(a=='1') then lang5_1 tail else false;;
    
let recognizers = [lang1;lang2;lang3;lang4;lang5]
                  
let belongsTo w = List.map (fun f -> f w) recognizers
  
