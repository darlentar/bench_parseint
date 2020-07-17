open! Core
open Core_bench
open Stdint
open Batteries

let ts = "1594913710"
let ts_ans = Uint64.of_int 1594913710
let small = "2"
let small_ans = Uint64.of_int 2
let big = "18446744073709551615"
let big_ans = Uint64.of_string "18446744073709551615"
let hex = "0xFF"
let hex_ans = Uint64.of_int 255
let big_hex = "0xffffffffffffffff"
let big_hex_ans = Uint64.max_int

let check f = assert (f ts = (Uint64.of_int 2))

let int64_ten_pow_9 = Uint64.of_int 1000000000
let int64_sixteen_pow_8 = Uint64.of_int 4294967296

let to_int_case c = (match c with '0' ->  0
                      | '1' -> 1
                      | '2' -> 2
                      | '3' -> 3
                      | '4' -> 4
                      | '5' -> 5
                      | '6' -> 6
                      | '7' -> 7
                      | '8' -> 8
                      | '9' -> 9
                      | 'f' | 'F' -> 15
                      | _ -> 0)

let naive_impl_loop s base start stop =
  let ans = ref 0 in
  for i = start to stop - 1 do
    ans := !ans*base + to_int_case s.[i] done ;
  !ans

let optimized_ s off base block_size pow =
  let start = ref off in
  let base_i = Uint64.of_int base in
  let stop = ref (min (block_size+off) (String.length s)) in
  let n = (String.length s - off) / block_size + 1 in
  let res = ref Uint64.zero in
  for i = 0 to n - 2 do
    let ans = Uint64.of_int (naive_impl_loop s base !start !stop) in
    res := Uint64.(ans + !res * pow) ;
    start := !start + block_size ;
    stop := min (String.length s) (!stop + block_size) ;
  done;
  let ans = Uint64.of_int (naive_impl_loop s base !start !stop) in
  for i = !start to !stop - 1 do
    res := Uint64.(!res * base_i)
  done;
  res := Uint64.(ans + !res) ;
  !res

let optimized s =
  (* divided by a 9 length block taht is 2**31 bits -1 lenth *)
  let start = ref 0 in
  if s.[0] = '0' then (
    if s.[1] = 'x' || s.[1] = 'X' then
      start := 2; optimized_ s 2 16 8 int64_sixteen_pow_8
  ) else optimized_ s 0 10 9 int64_ten_pow_9

external optimized_c : string -> Uint64.t = "optimized"

let () =
  assert (optimized ts =  ts_ans) ;
  assert (optimized small =  small_ans) ;
  assert (optimized big = big_ans) ;
  assert (optimized hex = hex_ans) ;
  assert (optimized big_hex = big_hex_ans) ;
  assert (optimized_c big = big_ans) ;
  assert (optimized_c ts = ts_ans) ;
  assert (optimized_c big_hex = big_hex_ans);

  Command.run (Bench.make_command [
    Bench.Test.create ~name:"Stdint uint64 ts" (fun () ->
      Uint64.of_string ts);
    Bench.Test.create ~name:"optimized ts" (fun () ->
      optimized ts);
    Bench.Test.create ~name:"Stdint uint64 small" (fun () ->
      Uint64.of_string small);
    Bench.Test.create ~name:"optimized small" (fun () ->
      optimized small);
    Bench.Test.create ~name:"Stdint uint64 big" (fun () ->
      Uint64.of_string big);
    Bench.Test.create ~name:"optimized big" (fun () ->
      optimized big);
    Bench.Test.create ~name:"Stdint uint64 hex" (fun () ->
      Uint64.of_string hex);
    Bench.Test.create ~name:"optimized hex" (fun () ->
      optimized hex);
    Bench.Test.create ~name:"Stdint uint64 big_hex" (fun () ->
      Uint64.of_string big_hex);
    Bench.Test.create ~name:"optimized big_hex" (fun () ->
      optimized big_hex);
    Bench.Test.create ~name:"optimized_c big" (fun () ->
      optimized_c big);
    Bench.Test.create ~name:"optimized_c ts" (fun () ->
      optimized_c ts);
    Bench.Test.create ~name:"optimized_c big_hex" (fun () ->
      optimized_c big_hex);
  ])
