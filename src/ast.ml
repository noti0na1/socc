open Core

type const =
  | Int of int
  | Char of char
  | String of string
[@@deriving sexp]

type unop = Negate | Pos | Complement | Not
[@@deriving sexp]

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
[@@deriving sexp]

type exp =
  | Const of const
  | UnOp of unop * exp
  | BinOp of binop * exp * exp
[@@deriving sexp]

type statement =
  | ReturnVal of exp
[@@deriving sexp]

type fun_decl =
  | Fun of string * statement
[@@deriving sexp]

type prog = Prog of fun_decl list
[@@deriving sexp]


let string_of_prog p = p |> sexp_of_prog |> Sexp.to_string_hum ~indent:4

(*
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

(* TODO *)
let rec print_exp e =
  match e with
  | Const c -> print_const c
  | UnOp (uop, e) -> print_unop uop; print_exp e
  | BinOp (bop, e1, e2) -> print_exp e1; print_exp e2

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
*)
