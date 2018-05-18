{
  open Parser
  exception Error

  let keyword_tabel =
    [("int", IntKeyword);
     ("char", CharKeyword);
     ("return", ReturnKeyword)]

  let find_token s =
    try List.assoc s keyword_tabel
    with Not_found -> Id s
}

rule token = parse
  | [' ' '\t' '\n'] { token lexbuf }
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
  | ['0'-'9']+ as lxm { Int (int_of_string lxm) }
  | ['A'-'Z' 'a'-'z'] ['A'-'Z' 'a'-'z' '0'-'9' '_'] * as id
    { find_token id }
  | _ { token lexbuf }
  | eof { EOF }
