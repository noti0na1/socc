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
