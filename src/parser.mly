%{
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
%type <unop> unary_op

%start prog

%%

prog:
  fun_decl EOF
  { Prog [$1] }
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
  | uop = unary_op e = exp { UnOp (uop, e) }
;

unary_op:
    Minus %prec NMinus { Negate }
  | Complement { Complement }
  | Bang { Not }
;
%%
