{
  open Parser
  exception Error

  let keyword_tabel =
    [("int", IntKeyword);
     ("return", ReturnKeyword)]

  let find_token s =
    try List.assoc s keyword_tabel
    with Not_found -> Id s
}

rule token = parse
  | [' ' '\t'] { token lexbuf }
  | '{' { BraceOpen }
  | '}' { BraceClose }
  | '(' { ParenOpen }
  | ')' { ParenClose }
  | ';' { Comma }
  | ['0'-'9']+ as lxm { Int (int_of_string lxm) }
  | ['A'-'Z' 'a'-'z'] ['A'-'Z' 'a'-'z' '0'-'9' '_'] * as id
    { find_token id }
  | _ { token lexbuf }
  | eof { EOF }
