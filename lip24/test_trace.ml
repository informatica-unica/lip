(**

  ⚠️ READ THIS ⚠️

  This file is a template for testing the provided examples of Tiny Rust.

  These tests make a lot of assumptions about your code, therefore you have
  the option to freely change them to work with your code, or vice versa.

  The test routine depends on a library called `ppx_expect`.
  To install `ppx_expect` run the command:

  ```
  opam install ppx_expect
  ```

  And add `ppx_expect` next to `ppx_inline_test` in `test/dune`

  Here we assume that the `trace` function returns a `result` and
  never raises an exception.

*)

open Tinyrust
open Ast
open Common

(** ------------------------------------------
    Types & definitions
    ------------------------------------------ *)

type mut = Mutable | Immutable

type trace_error =
  | TypeError of string
  | UnboundVar of ide
  | CannotMutate of ide
  | MovedValue of ide
  | MutBorrowOfNonMut of ide
  | DataRace of ide * mut * mut
  | OutOfGas of int
  | NotInLoop

type 'output trace_result = ('output, trace_error) result
(** ['output] is a type parameter for successful executions *)

(** ------------------------------------------
    Helper functions
    ------------------------------------------ *)

let string_of_mut = function
  | Mutable -> "mutable"
  | Immutable -> "immutable"

let string_of_trace_error = function
  | TypeError s ->
      spr "[TypeError] %s" s
  | CannotMutate x ->
      spr "[CannotMutate] cannot mutate immutable variable %s" x
  | UnboundVar x ->
      spr "[UnboundVar] %s not defined in this scope" x
  | MovedValue x ->
      spr "[MovedValue] borrow of moved value %s" x
  | OutOfGas i ->
      spr "[OutOfGas] trace run out of gas (%d)" i
  | NotInLoop ->
    "[NotInLoop] cannot break outside of a loop"
  | MutBorrowOfNonMut x ->
      spr
        "[MutBorrowOfNonMut] cannot borrow %s as mutable, as it is not \
         declared as mutable"
        x
  | DataRace (x, mut1, mut2) ->
      spr "[DataRace] cannot borrow %s as %s because it is also borrowed as %s"
        x (string_of_mut mut1) (string_of_mut mut2)

    (* Note: a data race is when:
        - there are two or more references defined on
          the same variable, in the same scope,
        - one of them is mutable
    *)
[@@ocamlformat "disable"]

(** ------------------------------------------
    Definition of tests
    ------------------------------------------ *)

(* Feel free to increase or decrease the amount of steps (gas) *)
let tests : (string * int * string trace_result) array =
  [|
    ("01-print.rs",           25, Ok "3\n4\n");
    ("02-intError.rs",        25, Error (CannotMutate "x"));
    ("03-intOk.rs",           25, Ok "7\n");
    ("04-stringError.rs",     25, Error (UnboundVar "x"));
    ("05-stringOk.rs",        25, Ok "Ciao, mondo\n");
    ("06-scopeOk.rs",         25, Ok "6\n3\n");
    ("07-scopeError.rs",      25, Error (UnboundVar "y"));
    ("08-func.rs",            25, Ok "7\n");
    ("09-proc.rs",            25, Ok "7\n");
    ("10-ifThenElse.rs",      25, Ok "dispari\n");
    ("11-ownError.rs",        25, Error (MovedValue "x"));
    ("12-ownFnError.rs",      25, Error (MovedValue "x"));
    ("13-borrow.rs",          25, Ok "Ciao\nCiao\n");
    ("14-borrowFn.rs",        25, Ok "il parametro x: Ciao\nil parametro prestato: Ciao\n" );
    ("15-borrowError.rs",     25, Error (DataRace ("x", Mutable, Immutable)));
    ("16-borrowMut.rs",       25, Ok "Ciao, mondo\nCiao, mondo\n");
    ("17-borrowMutError.rs",  40, Error (MutBorrowOfNonMut "x"));
    ("18-loop.rs",            50, Error (OutOfGas 50));
    ("19-loopBreak.rs",       50, Ok "3\n2\n1\n0\n");
    ("20-loopNested.rs",      50, Ok "0,0\n0,1\n1,0\n1,1\n2,0\n2,1\n");
    ("21-exprBlock.rs",       25, Ok "7\n");
    ("22-funExpr.rs",         25, Error (UnboundVar "interna"));
    ("23-scopeCheck.rs",      25, Error (UnboundVar "y"));
  |] [@@ocamlformat "disable"]

(** ------------------------------------------
    Start of trace tests
    ------------------------------------------ *)

let%expect_test "test_trace" =
  Array.iter2
    (fun (name, prog) (_, gas, expected) ->
      let prog : Ast.prog = Parser.parse_string prog in

      (* We're assuming the return type of [Trace.trace_prog] is:

         [(Ast.expression list) * (string trace_result)]

         We run the program and ignore the trace, as we only care about
         the program's textual output (and whether it is Ok or Error).

         If you used exceptions, use the [try .. with] construct here
         and convert the exception to a result.
      *)
      let _, (actual : string trace_result) = Trace.trace_prog gas prog in

      let icon =
        match (actual, expected) with
        | Ok _, Ok _ | Error _, Error _ -> "✔"
        | Ok _, Error _ | Error _, Ok _ -> "✘"
      in

      pr "------------------------\n%s %s\n------------------------\n" icon name;

      List.iter
        (fun (title, result) ->
          let kind, output =
            match result with
            | Ok output -> ("Ok", output)
            | Error err -> ("Error", string_of_trace_error err)
          in
          pr "%-9s %-9s\n%s\n\n" title kind output)
        [ ("Actual output:", actual); ("Expected:", expected) ])
    examples_dict tests
