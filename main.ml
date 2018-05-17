open Ast
open Parser
open Lexer

let print_token tk =
  match tk with
  | BraceOpen -> print_string "BraceOpen"
  | BraceClose -> print_string "BraceClose"
  | ParenOpen -> print_string "ParenOpen"
  | ParenClose -> print_string "ParenClose"
  | Comma -> print_string "Comma"
  | IntKeyword -> print_string "IntKeyword"
  | ReturnKeyword -> print_string "ReturnKeyword"
  | Id i -> print_string "ID "; print_string i
  | Int i -> print_string "Int "; print_int i
  | EOF -> print_string "EOF"
  | _ -> print_string "unknown"

let print_ast p =
  match p with
  | Prog [f] ->
    (match f with
     | Fun (id, st) ->
       print_string ("INT " ^ id ^ " () {");
       print_newline ();
       (match st with
        | ReturnVal (Const (Int c)) ->
          print_string ("    return " ^ (string_of_int c) ^ ";");
          print_newline ()
        | _ ->print_newline ());
       print_string "}";
       print_newline ();
     | _ -> print_newline ())
  | _ -> print_newline ()

let generate p =
  match p with
  | Prog [f] ->
    print_string "\t.globl main\n";
    (match f with
     | Fun (id, st) ->
       print_string (id ^ ":\n");
       (match st with
        | ReturnVal (Const (Int c)) ->
          print_string ("\tmovl\t$" ^ (string_of_int c) ^ ", %eax\n");
          print_string "\tret\n"
        | _ -> print_newline ())
     | _ -> print_newline ())
  | _ -> print_newline ()



let _ =
  let lexbuf = Lexing.from_channel stdin in
  let result = Parser.prog Lexer.token lexbuf in
  generate result
