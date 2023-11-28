open SarithexprLib.Main

type wexprval = exprtype option

let string_of_wtype = function 
    Some t -> string_of_type t
  | _ -> "Error"

let wtypecheck e = try Some (typecheck e) 
  with _ -> None

(**********************************************************************
 Test type checker
 **********************************************************************)

let test_type expr exp_result =
  (expr |> parse |> wtypecheck) = exp_result
  
let%test "test_type1" = test_type "if true then true else false and false" (Some BoolT)

let%test "test_type2" = test_type "if true then false else false or true" (Some BoolT)

let%test "test_type3" = test_type "if iszero 0 then iszero succ 0 else false or true" (Some BoolT)

let%test "test_type4" = test_type "succ 0" (Some NatT)

let%test "test_type5" = test_type "succ succ succ pred pred succ succ pred succ pred succ 0" (Some NatT)

let%test "test_type6" = test_type "iszero pred succ 0" (Some BoolT)

let%test "test_type7" = test_type "iszero pred succ 0 and not iszero succ pred succ 0" (Some BoolT)

let%test "test_type8" = test_type "pred 0" (Some NatT)

let%test "test_type9" = test_type "pred pred succ 0" (Some NatT)
    
let%test "test_type10" = test_type "iszero true" None

let%test "test_type11" = test_type "succ iszero 0" None

let%test "test_type12" = test_type "not 0" None

let%test "test_type13" = test_type "if 0 then true else false" None

let%test "test_type14" = test_type "if succ 0 then true else false" None

let%test "test_type15" = test_type "if iszero 0 then true else 0" None

let%test "test_type16" = test_type "if iszero 0 then 0 else true" None

let%test "test_type17" = test_type "iszero 0 and succ 0" None

let%test "test_type18" = test_type "succ 0 and iszero 0" None

let%test "test_type19" = test_type "iszero 0 or succ 0" None

let%test "test_type20" = test_type "succ 0 or iszero 0" None

       
