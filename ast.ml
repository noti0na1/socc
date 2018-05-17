type const =
  | Int of int
  | Char of char
  | String of string

type exp =
  | Const of const

type statement =
  | ReturnVal of exp

type fun_decl =
  | Fun of string * statement

type prog = Prog of fun_decl list
