type const =
  | Int of int
  | Char of char
  | String of string

type unop = Negate | Pos | Complement | Not

type binop =
  | Add
  | Sub
  | Mult
  | Div
  | Mod
  | Lt
  | Gt
  | Le
  | Ge
  | Neq
  | Eq
  | And
  | Or
  | BitAnd
  | BitOr
  | Xor
  | ShiftL
  | ShiftR

type exp =
  | Const of const
  | UnOp of unop * exp

type statement =
  | ReturnVal of exp

type fun_decl =
  | Fun of string * statement

type prog = Prog of fun_decl list

let print_const c =
  match c with
  | Int i -> print_int i
  | Char c -> print_char c
  | String s -> print_string s

let print_unop uop =
  match uop with
  | Negate -> print_char '-'
  | Pos -> print_char '+' (* ? *)
  | Complement -> print_char '~'
  | Not -> print_char '!'

let rec print_exp e =
  match e with
  | Const c -> print_const c
  | UnOp (uop, e) -> print_unop uop; print_exp e

let print_statement s =
  match s with
  | ReturnVal e ->
    print_string "\treturn ";
    print_exp e;
    print_string ";\n"

let print_fun f =
  match f with
  | Fun (id, bdy) ->
    print_string ("INT " ^ id ^ "() {\n");
    print_statement bdy;
    print_string "}\n"

let rec print_prog p =
  match p with
  | Prog [] -> ();
  | Prog (f :: fs) ->
    print_fun f; print_prog (Prog fs)
