%{
  open Core
  open Ast
%}

%token <int> Int
%token <char> Char
%token <string> Id
%token BraceOpen BraceClose ParenOpen ParenClose
%token Comma Question Semicolon Colon
%token IntKeyword CharKeyword ReturnKeyword
%token IfKeyword ElseKeyword ForKeyword DoKeyword WhileKeyword BreakKeyword ContinueKeyword
%token Bang Complement
%token NMinus Plus Minus Mult Div Mod
%token Eq DoubleEq Neq Lt Le Gt Ge And Or
%token BitAnd BitOr Xor ShiftLeft ShiftRight
%token EOF

%left Plus Minus
%left Mult Div Mod
%nonassoc NMinus

%type <Ast.prog> prog
%type <fun_decl> fun_decl
%type <statement> statement
%type <exp> exp

%start prog

%%

prog:
    f = fun_decl p = prog
    { let Prog fs = p in Prog (f :: fs) }
  | EOF { Prog [] }
;

fun_decl:
  IntKeyword id = Id ParenOpen ParenClose BraceOpen st = statement BraceClose
  { Fun (id, st) }
;

statement:
  ReturnKeyword e = exp Semicolon
  { ReturnVal e }
;

exp:
    i = Int { Const (Int i) }
  | ParenOpen e = exp ParenClose { e }
  | e1 = exp Plus e2 = exp { BinOp (Add, e1, e2) }
  | e1 = exp Minus e2 = exp { BinOp (Sub, e1, e2) }
  | e1 = exp Mult e2 = exp { BinOp (Mult, e1, e2) }
  | e1 = exp Div e2 = exp { BinOp (Div, e1, e2) }
  | e1 = exp Mod e2 = exp { BinOp (Mod, e1, e2) }
  | Complement e = exp { UnOp (Complement, e) }
  | Bang e = exp { UnOp (Not, e) }
  | Minus e = exp %prec NMinus { UnOp (Negate, e) }
;
%%
