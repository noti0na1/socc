{
  open Core
  open Lexing
  open Parser

  exception SyntaxError of string

  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_bol = lexbuf.lex_curr_pos;
        pos_lnum = pos.pos_lnum + 1
      }

  (* TODO: change to hashmap *)
  let keyword_tabel =
    [("int", IntKeyword);
     ("char", CharKeyword);
     ("return", ReturnKeyword);
     ("if", IfKeyword);
     ("else", ElseKeyword);
     ("for", ForKeyword);
     ("do", DoKeyword);
     ("while", WhileKeyword);
     ("break", BreakKeyword);
     ("continue", ContinueKeyword)]

  let find_token s =
    match List.Assoc.find keyword_tabel s ~equal:String.equal with
    | Some kw -> kw
    | None -> Id s
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
  | '<' { Lt }
  | "<=" { Le }
  | '>' { Gt }
  | ">=" { Ge }
  | '=' { Eq }
  | "==" { DoubleEq }
  | "!=" { Neq }
  | "&&" { And }
  | "||" { Or }
  | digit+ as lxm { Int (int_of_string lxm) }
  | id as id { find_token id }
  | _ as c
    (* TODO: add more info *)
    { raise (SyntaxError ("Unknown char: " ^ (Char.escaped c))) }
  | eof { EOF }
