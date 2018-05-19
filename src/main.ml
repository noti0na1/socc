open Core
open Ast
open Generate

let _ =
  let lexbuf = Lexing.from_channel In_channel.stdin in
  let result = Parser.prog Lexer.token lexbuf in
  (* gen_prog result *)
  result |> string_of_prog |> print_string
