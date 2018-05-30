{
  open Core
  open Lexing
  open Parser

  exception SyntaxError of string

  (* TODO: add skip comment *)

  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_bol = lexbuf.lex_curr_pos;
        pos_lnum = pos.pos_lnum + 1
      }

  (* TODO: change to hashmap *)
  let keyword_tabel =
    [("void", VOID_KW);
     ("int", INT_KW);
     ("char", CHAR_KW);
     ("long", LONG_KW);
     ("unsigned", UNSIGNED_KW);
     ("float", FLOAT_KW);
     ("double", DOUBLE_KW);
     ("struct", STRUCT_KW);
     ("const", CONST_KW);
     ("static", STATIC_KW);
     ("sizeof", SIZEOF_KW);
     ("return", RETURN_KW);
     ("goto", GOTO_KW);
     ("if", IF_KW);
     ("else", ELSE_KW);
     ("switch", SWITCH_KW);
     ("for", FOR_KW);
     ("do", DO_KW);
     ("while", WHILE_KW);
     ("break", BREAK_KW);
     ("continue", CONTINUE_KW)]

  let find_token s =
    match List.Assoc.find keyword_tabel s ~equal:String.equal with
    | Some kw -> kw
    | None -> ID s
}

let digit = ['0'-'9']

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule token = parse
  | white { token lexbuf }
  | newline  { next_line lexbuf; token lexbuf }
  | '{' { BRACE_OPEN }
  | '}' { BRACE_CLOSE }
  | '(' { PAREN_OPEN }
  | ')' { PAREN_CLOSE }
  | '[' { BRACKET_OPEN }
  | ']' { BRACKET_CLOSE }
  | ',' { COMMA }
  | '?' { QUESTION }
  | ';' { SEMICOLON }
  | ':' { COLON }
  | '!' { BANG }
  | '~' { COMPLEMENT }
  | '+' { PLUS }
  | '-' { MINUS }
  | '*' { MULT }
  | '/' { DIV }
  | '%' { MOD }
  | '&' { BIT_AND }
  | '|' { BIT_OR }
  | '^' { XOR }
  | '<' { LT }
  | "<=" { LE }
  | '>' { GT }
  | ">=" { GE }
  | '=' { EQ }
  | "==" { DOUBLE_EQ }
  | "!=" { NEQ }
  | "&&" { AND }
  | "||" { OR }
  | "<<" { SHIFT_LEFT }
  | ">>" { SHIFT_RIGHT }
  | "+=" { PLUS_EQ }
  | "-=" { MINUS_EQ }
  | "*=" { MULT_EQ }
  | "/=" { DIV_EQ }
  | "%=" { MOD_EQ }
  | "&=" { BIT_AND_EQ }
  | "|=" { BIT_OR_EQ }
  | "^=" { XOR_EQ }
  | "<<=" { SHIFT_LEFT_EQ }
  | ">>=" { SHIFT_RIGHT_EQ }
  | "->" { ARROW }
  | digit+ as lxm { INT (int_of_string lxm) }
  | id as id { find_token id }
  | _ as c
    (* TODO: add more info *)
    { raise (SyntaxError ("Unknown char: " ^ (Char.escaped c))) }
  | eof { EOF }
