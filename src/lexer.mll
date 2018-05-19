{
  open Lexing
  open Parser
  exception Error

  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_bol = lexbuf.lex_curr_pos;
        pos_lnum = pos.pos_lnum + 1
      }

  let keyword_tabel =
    [("int", IntKeyword);
     ("char", CharKeyword);
     ("return", ReturnKeyword)]

  let find_token s =
    try List.assoc s keyword_tabel
    with Not_found -> Id s
}

let digit = ['0'-'9']

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule token = parse
  | white { token lexbuf }
  | newline  { next_line lexbuf; token lexbuf }
  | '{' { BraceOpen }
  | '}' { BraceClose }
  | '(' { ParenOpen }
  | ')' { ParenClose }
  | ',' { Comma }
  | '?' { Question }
  | ';' { Semicolon }
  | ':' { Colon }
  | '!' { Bang }
  | '~' { Complement }
  | '+' { Plus }
  | '-' { Minus }
  | '*' { Mult }
  | '/' { Div }
  | '%' { Mod }
  | digit+ as lxm { Int (int_of_string lxm) }
  | id as id { find_token id }
  | _ { token lexbuf }
  | eof { EOF }
