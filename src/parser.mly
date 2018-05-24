%{
  open Core
  open Ast
%}

%token <int> INT
%token <char> CHAR
%token <string> ID
%token BRACE_OPEN BRACE_CLOSE PAREN_OPEN PAREN_CLOSE
%token COMMA QUESTION SEMICOLON COLON
%token INT_KW CHAR_KW RETURN_KW
%token IF_KW ELSE_KW FOR_KW DO_KW WHILE_KW BREAK_KW CONTINUE_KW
%token BANG COMPLEMENT
%token PLUS MINUS NEG_MINUS MULT DIV MOD
%token EQ DOUBLE_EQ NEQ LT LE GT GE AND OR
%token BIT_AND BIT_OR XOR SHIFT_LEFT SHIFT_RIGHT
%token EOF

%right EQ
%right QUESTION COLON
%left OR
%left AND
%left BIT_OR
%left XOR
%left BIT_AND
%left DOUBLE_EQ NEQ
%left LE LT GE GT
%left SHIFT_LEFT SHIFT_RIGHT
%left PLUS MINUS
%left MULT DIV MOD
%nonassoc NEG_MINUS

%type <Ast.prog> program
%type <fun_decl> fun_decl
%type <exp> exp

%start program

%%

program:
  | f = fun_decl p = program
    { let Prog fs = p in Prog (f :: fs) }
  | EOF { Prog [] }
;

fun_decl:
  INT_KW id = ID PAREN_OPEN PAREN_CLOSE
  b = block
  { Fun (id, b) }
;

block:
  | BRACE_OPEN sts = statements BRACE_CLOSE
    { sts }

statements:
  | { [] }
  | s = statement ss = statements
    { s :: ss }
;

statement:
  | INT_KW id = ID e = decl_exp SEMICOLON
    { Decl { var_type = IntType; name = id; init = e } }
  | RETURN_KW e = exp SEMICOLON
    { ReturnVal e }
  | e = exp SEMICOLON
    { Exp e}
  | IF_KW PAREN_OPEN cond = exp PAREN_CLOSE
    tstat = statement fstat = if_fstat
    { If { cond = cond; tstat = tstat; fstat = fstat } }
  | b = block
    { Block b }
;

decl_exp:
  | { None }
  | EQ e = exp { Some e }

if_fstat:
  | { None }
  | ELSE_KW fstat = statement { Some fstat }

exp:
  | i = INT { Const (Int i) }
  | PAREN_OPEN e = exp PAREN_CLOSE { e }
  | e1 = exp PLUS e2 = exp { BinOp (Add, e1, e2) }
  | e1 = exp MINUS e2 = exp { BinOp (Sub, e1, e2) }
  | e1 = exp MULT e2 = exp { BinOp (Mult, e1, e2) }
  | e1 = exp DIV e2 = exp { BinOp (Div, e1, e2) }
  | e1 = exp MOD e2 = exp { BinOp (Mod, e1, e2) }
  | e1 = exp LT e2 = exp { BinOp (Lt, e1, e2) }
  | e1 = exp LE e2 = exp { BinOp (Le, e1, e2) }
  | e1 = exp GT e2 = exp { BinOp (Gt, e1, e2) }
  | e1 = exp GE e2 = exp { BinOp (Ge, e1, e2) }
  | e1 = exp DOUBLE_EQ e2 = exp { BinOp (Eq, e1, e2) }
  | e1 = exp NEQ e2 = exp { BinOp (Neq, e1, e2) }
  | e1 = exp AND e2 = exp { BinOp (And, e1, e2) }
  | e1 = exp OR e2 = exp { BinOp (Or, e1, e2) }
  | e1 = exp BIT_AND e2 = exp { BinOp (BitAnd, e1, e2) }
  | e1 = exp BIT_OR e2 = exp { BinOp (BitOr, e1, e2) }
  | e1 = exp XOR e2 = exp { BinOp (Xor, e1, e2) }
  | e1 = exp SHIFT_LEFT e2 = exp { BinOp (ShiftL, e1, e2) }
  | e1 = exp SHIFT_RIGHT e2 = exp { BinOp (ShiftR, e1, e2) }
  | COMPLEMENT e = exp { UnOp (Complement, e) }
  | BANG e = exp { UnOp (Not, e) }
  | MINUS e = exp %prec NEG_MINUS { UnOp (Negate, e) }
  | id = ID EQ e = exp { Assign (id, e) }
  | id = ID { Var id }
  | cond = exp QUESTION texp = exp COLON fexp = exp
    { Condition (cond, texp, fexp) }
;
%%
