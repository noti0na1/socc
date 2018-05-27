open Core

let count = ref 0

let unique_string s =
  count := !count + 1;
  s ^ (string_of_int !count)
