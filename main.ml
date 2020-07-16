open! Core
open Core_bench
open Stdint
open Batteries

let ts = "1594913710"

let int_zero = Char.code '0'
let int64_zero = Uint64.of_int int_zero
let int64_ten = Uint64.of_int 10

let hash_tabl = Hashtbl.create 10

let naive_impl s = BatString.fold_left (fun s c -> s*10+(Char.code c - int_zero)) 0 s

let to_int64_v1 c = match c with '0' -> Uint64.of_int 0
                      | '1' -> Uint64.of_int 1
                      | '2' -> Uint64.of_int 2
                      | '3' -> Uint64.of_int 3
                      | '4' -> Uint64.of_int 4
                      | '5' -> Uint64.of_int 5
                      | '6' -> Uint64.of_int 6
                      | '7' -> Uint64.of_int 7
                      | '8' -> Uint64.of_int 8
                      | '9' -> Uint64.of_int 9
                      | _ -> Uint64.of_int 0

let to_int64_v2 c = Uint64.of_int (match c with '0' ->  0
                      | '1' -> 1
                      | '2' -> 2
                      | '3' -> 3
                      | '4' -> 4
                      | '5' -> 5
                      | '6' -> 6
                      | '7' -> 7
                      | '8' -> 8
                      | '9' -> 9
                      | _ -> 0)

let naive_impl_int64 s = BatString.fold_left (fun acc c -> Uint64.(acc*int64_ten + of_int (Char.code c) - int64_zero)) Uint64.zero s
let naive_impl_int64_hash_tbl s = BatString.fold_left (fun acc c -> Uint64.(acc*int64_ten + Hashtbl.find hash_tabl c)) Uint64.zero s
let naive_impl_int64_case s = BatString.fold_left (fun acc c -> Uint64.(acc*int64_ten + to_int64_v1 c)) Uint64.zero s
let naive_impl_int64_case_2 s = BatString.fold_left (fun acc c -> Uint64.(acc*int64_ten + to_int64_v2 c)) Uint64.zero s
let naive_impl_int64_case_2_loop s =
  let ans = ref Uint64.zero in
  for i = 0 to String.length s - 1 do
    ans := Uint64.(!ans*int64_ten + to_int64_v2 s.[i])
  done ;
  !ans

let () =
  Hashtbl.add hash_tabl '0' (Uint64.of_int 0);
  Hashtbl.add hash_tabl '1' (Uint64.of_int 1);
  Hashtbl.add hash_tabl '2' (Uint64.of_int 2);
  Hashtbl.add hash_tabl '3' (Uint64.of_int 3);
  Hashtbl.add hash_tabl '4' (Uint64.of_int 4);
  Hashtbl.add hash_tabl '5' (Uint64.of_int 5);
  Hashtbl.add hash_tabl '6' (Uint64.of_int 6);
  Hashtbl.add hash_tabl '7' (Uint64.of_int 7);
  Hashtbl.add hash_tabl '8' (Uint64.of_int 8);
  Hashtbl.add hash_tabl '9' (Uint64.of_int 9);

  assert (naive_impl ts = 1594913710);
  assert (naive_impl_int64 ts = Uint64.of_int 1594913710);
  assert (naive_impl_int64_hash_tbl ts = Uint64.of_int 1594913710);
  assert (naive_impl_int64_case ts = Uint64.of_int 1594913710);
  assert (naive_impl_int64_case_2 ts = Uint64.of_int 1594913710);
  assert (naive_impl_int64_case_2_loop ts = Uint64.of_int 1594913710);

  Command.run (Bench.make_command [
    Bench.Test.create ~name:"Stdint uint32" (fun () ->
      Uint32.of_string ts);
    Bench.Test.create ~name:"Stdint uint64" (fun () ->
      Uint64.of_string ts);
    Bench.Test.create ~name:"standard int" (fun () ->
      Int.of_string ts);
    Bench.Test.create ~name:"naive imp" (fun () ->
      naive_impl ts);
    Bench.Test.create ~name:"naive imp int64" (fun () ->
      naive_impl_int64 ts);
    Bench.Test.create ~name:"naive imp int64 with hash_tabl" (fun () ->
      naive_impl_int64_hash_tbl ts);
    Bench.Test.create ~name:"naive imp int64 with match" (fun () ->
      naive_impl_int64_case ts);
    Bench.Test.create ~name:"naive imp int64 with match v2" (fun () ->
      naive_impl_int64_case_2 ts);
    Bench.Test.create ~name:"naive imp int64 with match v2 with loop" (fun () ->
      naive_impl_int64_case_2_loop ts);
  ])
