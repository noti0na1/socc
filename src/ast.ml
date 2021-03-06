open Core

type type_def =
  | VoidType
  | IntType
  | ShortIntType
  | LongIntType
  | LongLongIntType
  | CharType
  | FloatType
  | DoubleType
  | ArrayType of int * type_def
  | ConstType of type_def
  | PointerType of type_def
[@@deriving sexp]

type const =
  | Int of int
  | Char of char
  | Float of float
  | String of string
[@@deriving sexp]

type assign_op =
  | AssignEq (* = *)
  | AddEq (* += *)
  | SubEq (* -= *)
  | MultEq (* *= *)
  | DivEq (* /= *)
  | ModEq (* %= *)
  | BitAndEq (* &= *)
  | BitOrEq (* |= *)
  | XorEq (* ^= *)
  | ShiftLEq (* <<= *)
  | ShiftREq (* >>= *)
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
  | Assign of assign_op * exp * exp
  | Var of string
  | Const of const
  | UnOp of unop * exp
  | BinOp of binop * exp * exp
  | Condition of exp * exp * exp
  | Call of string * exp list
  | AddressOf of exp
  | Dereference of exp
  | SizeofType of type_def
  | SizeofExp of exp
[@@deriving sexp]

type decl_exp = {
  var_type: type_def;
  name: string;
  init: exp option;
} [@@deriving sexp]

type block = statement list
and statement =
  | Compound of block
  | Decl of decl_exp
  | Exp of exp
  | ReturnVal of exp
  | If of {
      cond : exp;
      tstat : statement;
      fstat : statement option;
    }
    (* TODO: option inti, cond, post *)
  | For of {
      init : exp;
      cond : exp;
      post : exp;
      body : statement;
    }
  | ForDecl of {
      init : decl_exp;
      cond : exp;
      post : exp;
      body : statement;
    }
  | While of exp * statement
  | Do of exp * statement
  | Break | Continue
  | Label of string
  | Goto of string
  | Nop
[@@deriving sexp]

type fun_decl = {
  name : string;
  fun_type : type_def;
  params : (string option * type_def) list;
  body : block;
}
[@@deriving sexp]

type prog = Prog of fun_decl list
[@@deriving sexp]

let string_of_prog p = p |> sexp_of_prog |> Sexp.to_string_hum ~indent:4
