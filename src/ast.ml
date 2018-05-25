open Core

type type_def =
  | IntType
  | CharType
[@@deriving sexp]

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
  | Assign of string * exp
  | Var of string
  | Const of const
  | UnOp of unop * exp
  | BinOp of binop * exp * exp
  | Condition of exp * exp * exp
  | Nop
[@@deriving sexp]

type block = statement list
and statement =
  | Compound of block
  | Decl of {
      var_type: type_def;
      name: string;
      init: exp option;
    }
  | Exp of exp
  | ReturnVal of exp
  | If of {
      cond : exp;
      tstat : statement;
      fstat : statement option;
    }
  | For of {
      init : exp;
      cond : exp;
      post : exp;
      body : statement;
    }
  | While of exp * statement
  | Do of exp * statement
  | Break | Continue
[@@deriving sexp]

type fun_decl = Fun of string * block
[@@deriving sexp]

type prog = Prog of fun_decl list
[@@deriving sexp]

let string_of_prog p = p |> sexp_of_prog |> Sexp.to_string_hum ~indent:4
