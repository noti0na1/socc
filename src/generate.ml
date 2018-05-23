open Core
open Ast

let off i a =
  (string_of_int i) ^ "(" ^ a ^ ")"

let nacmd c () =
  "\t" ^ c ^ "\n" |> print_string

let slcmd c a =
  "\t" ^ c ^ "\t" ^ a ^ "\n" |> print_string

let bicmd c a b =
  "\t" ^ c ^ "\t" ^ a ^ ", " ^ b ^ "\n" |> print_string

let globl f =
  "\t.globl " ^ f ^ "\n" |> print_string

let label f =
  f ^ ":\n" |> print_string

let movl = bicmd "movl"

let movq = bicmd "movq"

(*
let push = slcmd "push"

let pushl = slcmd "pushl"
*)

let pushq = slcmd "pushq"

(*
let pop = slcmd "pop"

let popl = slcmd "popl"
*)

let popq = slcmd "popq"

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

(*
  enter n,0 is equivalent to:
  push  %ebp
  mov   %esp, %ebp
  sub   $n, %esp   # allocate space on the stack. Omit if n=0
  enter is very slow and compilers don't use it
*)
let enter = bicmd "enter"

(*
  leave is equivalent to:
  mov   %ebp, %esp
  pop   %ebp
  If esp is already equal to ebp, it's most efficient to just pop ebp.
*)
let leave = nacmd "leave"

let ret = nacmd "ret"

let retq = nacmd "retq"

exception CodeGenError of string

type context =
  {
    index : int;
    block_level : int;
    vars : (string * (int * int)) list;
  }

let add_var ctx id =
  { index = ctx.index - 8; (* 64-bit *)
    block_level = ctx.block_level;
    vars = (id, (ctx.index, ctx.block_level)) :: ctx.vars }

let find_var ctx id =
  match List.Assoc.find ctx.vars id ~equal:String.equal with
  | Some (i, _) -> i
  | None -> raise (CodeGenError ("can't find " ^ id ^ " in the context"))

(* TODO *)
let get_var_level ctx id =
  match List.Assoc.find ctx.vars id ~equal:String.equal with
  | Some (_, l) -> Some l
  | None -> None

let add_block_level ctx l =
  { index = ctx.index;
    block_level = ctx.block_level + l;
    vars = ctx.vars }

let inc_block_level ctx = add_block_level ctx 1

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
    xor "%eax" "%eax";
    sete "%al"

let gen_compare (inst : string -> unit) =
  cmpl "%ecx" "%eax" ;
  xor "%eax" "%eax";
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
    xor "%eax" "%eax";
    setne "%al"
  | And ->
    cmpl "$0" "%eax";
    xor "%eax" "%eax";
    setne "%al";
    cmpl "$0" "%ecx";
    xor "%ecx" "%ecx";
    setne "%cl";
    andb "%cl" "%al"

let gen_fun_end () =
  (* movq "%rbp" "%rsp";
     popq "%rbp"; *)
  leave ();
  ret ()

let rec gen_exp (ctx : context) e =
  match e with
  | Assign (var, vexp) ->
    let _ = gen_exp ctx vexp in
    let i = find_var ctx var in
    movl "%eax" (off i "%rbp")
  | Var var ->
    let i = find_var ctx var in
    movl (off i "%rbp") "%eax"
  | Const c ->
    gen_const c
  | UnOp (uop, e) ->
    gen_exp ctx e;
    gen_unop uop;
  | BinOp (bop, e1, e2) ->
    gen_exp ctx e1;
    pushq "%rax";
    gen_exp ctx e2;
    movl "%eax" "%ecx";
    popq "%rax";
    gen_binop bop
(* | _ -> () *)

let rec gen_statement ctx sta =
  match sta with
  | Decl var ->
    (* TODO *)
    (* check if var has been define in the same block *)
    (match get_var_level ctx var.name with
     | Some l ->
       if l = ctx.block_level
       then raise (CodeGenError (var.name ^ " has already been defined in the same block"))
       else ()
     | None -> ());
    (match var.init with
     | Some iexp ->
       gen_exp ctx iexp; ()
     | None ->
       (* init default value *)
       xor "%eax" "%eax"; );
    pushq "%rax";
    add_var ctx var.name
  | Exp e ->
    gen_exp ctx e; ctx
  | ReturnVal e ->
    gen_exp ctx e;
    gen_fun_end ();
    ctx
  | Block ss ->
    let _ = gen_statements (add_block_level ctx 1) ss in
    ctx
  | _ -> ctx

(* TODO *)
and gen_statements ctx stas =
  match stas with
  | [ReturnVal e] ->
    gen_statement ctx (ReturnVal e)
  | [s] -> (* when function doesn't have return, return 0 *)
    let ctx0 = gen_statement ctx s in
    gen_statement ctx0 (ReturnVal (Const (Int 0)))
  | s :: ss ->
    let ctx0 = gen_statement ctx s in
    gen_statements ctx0 ss
  | [] -> ctx

let gen_fun f =
  match f with
  | Fun (id, bdy) ->
    globl id;
    label id;
    pushq "%rbp";
    movq "%rsp" "%rbp";
    gen_statements { index= -8; block_level = 0; vars = [] } bdy

let rec gen_prog p =
  match p with
  | Prog [] -> ();
  | Prog (f :: fs) ->
    let _ = gen_fun f in
    Out_channel.newline stdout;
    gen_prog (Prog fs)
