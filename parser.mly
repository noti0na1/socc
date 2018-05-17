%{
  open Ast
%}

%token <int> Int
%token <char> Char
%token <string> Id
%token BraceOpen BraceClose ParenOpen ParenClose Comma
%token IntKeyword ReturnKeyword
%token EOF

%type <prog> prog
%type <fun_decl> fun_decl
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
  ReturnKeyword e = exp Comma
  { ReturnVal e }
;

exp:
  i = Int
  { Const (Int i) }
;
%%
