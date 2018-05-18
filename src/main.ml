open Ast
open Parser
open Lexer
open Generate

let _ =
  let lexbuf = Lexing.from_channel stdin in
  let result = Parser.prog Lexer.token lexbuf in
  gen_prog result
