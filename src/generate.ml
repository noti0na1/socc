open Core
open Ast

let nacmd c () =
  "\t" ^ c ^ "\n" |> print_string

let slcmd c a =
  "\t" ^ c ^ "\t" ^ a ^ "\n" |> print_string

let bicmd c a b =
  "\t" ^ c ^ "\t" ^ a ^ ", " ^ b ^ "\n" |> print_string

let global f =
  "\t.global " ^ f ^ "\n" |> print_string

let label f =
  f ^ ":\n" |> print_string

let movl = bicmd "movl"

let push = slcmd "push"

let pop = slcmd "pop"

let sete = slcmd "sete"

let setne = slcmd "setne"

let setl = slcmd "setl"

let setle = slcmd "setle"

let setg = slcmd "setg"

let setge = slcmd "setge"

let cmpl = bicmd "cmpl"

let addl = bicmd "addl"

let subl = bicmd "subl"

let imul = bicmd "imul"

let idivl = slcmd "idivl"

let ands = bicmd "and"

let andb = bicmd "andb"

let ors = bicmd "or"

let orl = bicmd "orl"

let xor = bicmd "xor"

let sall = bicmd "sall"

let sarl = bicmd "sarl"

let neg = slcmd "neg"

let nnot = slcmd "nnot"

let jz = slcmd "jz"

let je = slcmd "je"

let jmp = slcmd "jmp"

let nop = nacmd "nop"

let ret = nacmd "ret"

let gen_const c =
  match c with
  | Int i -> movl ("$" ^ string_of_int i) "%eax"
  | Char c -> movl ("$" ^ string_of_int (Char.to_int c)) "%eax"
  | String s -> print_string s

let gen_unop uop =
  match uop with
  | Negate -> neg "%eax"
  | Pos -> ()
  | Complement -> nnot "%eax"
  | Not ->
    cmpl "$0" "%eax";
    movl "$0" "%eax";
    sete "%al"

let gen_compare (inst : string -> unit) =
  cmpl "%ecx" "%eax" ;
  movl "$0" "%eax";
  inst "%al"

let gen_binop bop =
  match bop with
  | Add -> addl "%ecx" "%eax"
  | Sub -> subl "%ecx" "%eax"
  | Mult -> imul "%ecx" "%eax"
  | Div ->
    xor "%edx" "%edx";
    idivl "%ecx"
  | Mod -> xor "%edx" "%edx";
    idivl "%ecx";
    movl "%edx" "%eax"
  | Xor -> xor "%ecx" "%eax"
  | BitAnd -> ands "%ecx" "%eax"
  | BitOr -> ors "%ecx" "%eax"
  | ShiftL -> sall "%cl" "%eax"
  | ShiftR -> sarl "%cl" "%eax"
  | Eq -> gen_compare sete
  | Neq -> gen_compare setne
  | Lt -> gen_compare setl
  | Le -> gen_compare setle
  | Gt -> gen_compare setg
  | Ge -> gen_compare setge
  | Or ->
    orl "%ecx" "%eax";
    movl "$0" "%eax";
    setne "%al"
  | And ->
    cmpl "$0" "%eax";
    movl "$0" "%eax";
    setne "%al";
    cmpl "$0" "%ec/x";
    movl "$0" "%ecx";
    setne "%cl";
    andb "%cl" "%al"

let rec gen_exp e =
  match e with
  | Const c -> gen_const c
  | UnOp (uop, e) -> gen_exp e; gen_unop uop
  | BinOp (bop, e1, e2) ->
    gen_exp e1;
    push "%eax";
    gen_exp e2;
    movl "%eax" "%ecx";
    pop "%eax";
    gen_binop bop

let gen_statement s =
  match s with
  | ReturnVal e ->
    gen_exp e; ret ()

let gen_fun f =
  match f with
  | Fun (id, bdy) ->
    global id; label id;
    gen_statement bdy

let rec gen_prog p =
  match p with
  | Prog [] -> ();
  | Prog (f :: fs) ->
    gen_fun f;
    Out_channel.newline stdout;
    gen_prog (Prog fs)
