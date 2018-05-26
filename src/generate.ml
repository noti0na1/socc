open Core
open Ast
open Fn

let (>>) f g a = g (f a)

exception CodeGenError of string

type context = {
  fun_name : string;
  block_level : int;
  labelc : int;
  startlb : string list;
  endlb : string list;
  index : int;
  vars : (string * (int * int)) list;
  out : Out_channel.t;
} [@@deriving fields]

let add_var id ctx =
  { fun_name = ctx.fun_name;
    index = ctx.index - 8; (* 64-bit *)
    block_level = ctx.block_level;
    labelc = ctx.labelc;
    startlb = ctx.startlb;
    endlb = ctx.endlb;
    vars = (id, (ctx.index, ctx.block_level)) :: ctx.vars;
    out = ctx.out }

let find_var id ctx =
  match List.Assoc.find ctx.vars id ~equal:String.equal with
  | Some (i, _) -> i
  | None -> raise (CodeGenError ("can't find " ^ id ^ " in the context"))

(* TODO *)
let get_var_level id ctx =
  match List.Assoc.find ctx.vars id ~equal:String.equal with
  | Some (_, l) -> Some l
  | None -> None

let add_block_level l ctx=
  { fun_name = ctx.fun_name;
    index = ctx.index;
    block_level = ctx.block_level + l;
    labelc = ctx.labelc;
    startlb = ctx.startlb;
    endlb = ctx.endlb;
    vars = ctx.vars;
    out = ctx.out }

let inc_block_level = add_block_level 1

let get_new_label ?name ctx =
  match name with
  | Some n -> "L" ^ ctx.fun_name ^ n ^ (string_of_int ctx.labelc)
  | None -> "L" ^ ctx.fun_name ^ (string_of_int ctx.labelc)

let inc_labelc ctx =
  { fun_name = ctx.fun_name;
    index = ctx.index;
    block_level = ctx.block_level;
    labelc = ctx.labelc + 1;
    startlb = ctx.startlb;
    endlb = ctx.endlb;
    vars = ctx.vars;
    out = ctx.out }

let cint i =  "$" ^ (string_of_int i)

let off i a =
  String.concat [string_of_int i; "("; a; ")"]

let my_print_string s ctx = Out_channel.output_string ctx.out s; ctx

let nacmd c =
  String.concat ["\t";  c;  "\n"] |> my_print_string

let slcmd c a =
  String.concat ["\t"; c; "\t"; a; "\n"] |> my_print_string

let bicmd c a b =
  String.concat ["\t"; c; "\t"; a; ", "; b; "\n"] |> my_print_string

let globl f =
  "\t.globl " ^ f ^ "\n" |> my_print_string

let label f =
  f ^ ":\n" |> my_print_string

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

let addq = bicmd "addq"

let subl = bicmd "subl"

let subq = bicmd "subq"

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

let gen_const c =
  match c with
  | Int i -> movl ("$" ^ string_of_int i) "%eax"
  | Char c -> movl ("$" ^ string_of_int (Char.to_int c)) "%eax"
  | String s -> my_print_string s

let gen_unop uop  =
  match uop with
  | Negate -> neg "%eax"
  | Pos -> id
  | Complement -> nnot "%eax"
  | Not -> id
    >> cmpl "$0" "%eax"
    >> movl "$0" "%eax"
    >> sete "%al"

let gen_compare (inst : string -> context -> context) ctx =
  ctx
  |> cmpl "%ecx" "%eax"
  |> movl "$0" "%eax"
  |> inst "%al"

let gen_binop bop =
  match bop with
  | Add -> addl "%ecx" "%eax"
  | Sub -> subl "%ecx" "%eax"
  | Mult -> imul "%ecx" "%eax"
  | Div -> id
    >> movl "$0" "%eax"
    >> idivl "%ecx"
  | Mod -> id
    >> movl "$0" "%edx"
    >> idivl "%ecx"
    >> movl "%edx" "%eax"
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
  | Or -> id
    >> orl "%ecx" "%eax"
    >> movl "$0" "%eax"
    >> setne "%al"
  | And -> id
    >> cmpl "$0" "%eax"
    >> movl "$0" "%eax"
    >> setne "%al"
    >> cmpl "$0" "%ecx"
    >> movl "$0" "%ecx"
    >> setne "%cl"
    >> andb "%cl" "%al"

let gen_fun_end =
  (* movq "%rbp" "%rsp";
     popq "%rbp"; *)
  leave >> ret

let rec gen_exp e (ctx : context) =
  match e with
  | Assign (var, vexp) ->
    let ctx0 = gen_exp vexp ctx in
    let i = find_var var ctx0 in
    movl "%eax" (off i "%rbp") ctx0
  | Var var ->
    let i = find_var var ctx in
    movl (off i "%rbp") "%eax" ctx
  | Const c ->
    gen_const c ctx
  | UnOp (uop, e) ->
    ctx
    |> gen_exp e
    |> gen_unop uop
  | BinOp (bop, e1, e2) ->
    ctx
    |> gen_exp e1
    |> pushq "%rax"
    |> gen_exp e2
    |> movl "%eax" "%ecx"
    |> popq "%rax"
    |> gen_binop bop
  | Condition (cond, texp, fexp) ->
    let lb0 = get_new_label ~name:"CDA" ctx in
    let lb1 = get_new_label ~name:"CDB" ctx in
    ctx
    |> inc_labelc
    |> gen_exp cond
    |> cmpl "$0" "%eax"
    |> je lb0
    |> gen_exp texp
    |> jmp lb1
    |> label lb0
    |> gen_exp fexp
    |> label lb1
  | Nop -> ctx

let gen_decl_exp de ctx =
  (* TODO *)
  (* check if var has been define in the same block *)
  (match get_var_level de.name ctx with
   | Some l ->
     if l = ctx.block_level
     then raise (CodeGenError
                   (de.name ^ " has already been defined in the same block"))
     else ()
   | None -> ());
  (match de.init with
   | Some iexp ->
     gen_exp iexp ctx
   | None ->
     (* init default value *)
     movl "$0" "%eax" ctx)
  |> pushq "%rax"
  |> add_var de.name

let deallocate_vars ctx1 ctx2 =
  ignore @@ addq (cint (ctx1.index - ctx2.index)) "%rsp" ctx2;
  { fun_name = ctx1.fun_name;
    index = ctx1.index;
    block_level = ctx1.block_level;
    labelc = ctx2.labelc;
    startlb = ctx1.startlb;
    endlb = ctx1.endlb;
    vars = ctx1.vars;
    out = ctx1.out }

let set_labels lb0 lb1 ctx =
  (* print_string "!set"; *)
  { fun_name = ctx.fun_name;
    index = ctx.index;
    block_level = ctx.block_level;
    labelc = ctx.labelc;
    startlb = lb0 :: ctx.startlb;
    endlb = lb1:: ctx.endlb;
    vars = ctx.vars;
    out = ctx.out }

let unset_labels ctx =
  (* print_string "!unset"; *)
  match ctx.startlb, ctx.endlb with
  | (_ :: sls), (_ :: els) ->
    { fun_name = ctx.fun_name;
      index = ctx.index;
      block_level = ctx.block_level;
      labelc = ctx.labelc;
      startlb = sls;
      endlb = els;
      vars = ctx.vars;
      out = ctx.out }
  | _ -> raise (CodeGenError "unable to unset labels")

(* let rec replace_statement lb0 lb1 s =
   match s with
   | Decl _ | Exp _ | ReturnVal _
   | While _ | Do _ | For _
   | Label _ | Goto _ -> s
   | Break -> Goto lb1
   | Continue -> Goto lb0
   | If ifs ->
    let tstat = replace_statement lb0 lb1 ifs.tstat in
    let fstat =
      (match ifs.fstat with
       | Some fs -> Some (replace_statement lb0 lb1 fs)
       | None -> None) in
    If { cond = ifs.cond; tstat; fstat }
   | Compound ss -> replace_statements lb0 lb1 ss
   and replace_statements lb0 lb1 ss =
   Compound (List.map ss ~f:(replace_statement lb0 lb1)) *)

let rec gen_statement sta ctx =
  match sta with
  | Decl de ->
    gen_decl_exp de ctx
  | Exp e ->
    gen_exp e ctx
  | ReturnVal e ->
    ctx
    |> gen_exp e
    |> gen_fun_end
  | Compound ss ->
    ctx
    |> inc_block_level
    |> gen_statements ss
    |> deallocate_vars ctx
  | If ifs ->
    let lb0 = get_new_label ~name:"IFA" ctx in
    let lb1 = get_new_label ~name:"IFB" ctx in
    ctx
    |> inc_labelc
    |> gen_exp ifs.cond
    |> cmpl "$0" "%eax"
    |> je lb0
    |> gen_statement ifs.tstat
    |> jmp lb1
    |> label lb0
    |> (match ifs.fstat with
        | Some fs -> gen_statement fs
        | None -> id)
    |> label lb1
  | While (cond, body) ->
    let lb0 = get_new_label ~name:"WHA" ctx in
    let lb1 = get_new_label ~name:"WHB" ctx in
    ctx
    |> inc_labelc
    |> set_labels lb0 lb1
    |> label lb0
    |> set_labels lb0 lb1
    |> gen_exp cond
    |> cmpl "$0" "%eax"
    |> je lb1
    |> gen_statement body
    |> jmp lb0
    |> label lb1
    |> unset_labels
  | Do (cond, body) ->
    let lb0 = get_new_label ~name:"DOA" ctx in
    let lb1 = get_new_label ~name:"DOB" ctx in
    ctx
    |> inc_labelc
    |> set_labels lb0 lb1
    |> label lb0
    |> gen_statement body
    |> gen_exp cond
    |> cmpl "$0" "%eax"
    |> je lb1
    |> jmp lb0
    |> label lb1
    |> unset_labels
  (* TODO *)
  | For f ->
    gen_for (gen_exp f.init) f.cond f.post f.body ctx
  (* TODO *)
  | ForDecl f ->
    gen_for (gen_decl_exp f.init) f.cond f.post f.body ctx
  | Break ->
    (match ctx.endlb with
     | l :: _ -> jmp l ctx
     | [] -> raise (CodeGenError "not in a loop"))
  | Continue ->
    (match ctx.startlb with
     | l :: _ -> jmp l ctx
     | [] -> raise (CodeGenError "not in a loop"))
  | Label l -> label l ctx
  | Goto l -> jmp l ctx

and gen_for gen_init cond post body ctx =
  let lb0 = get_new_label ~name:"FORA" ctx in
  let lb1 = get_new_label ~name:"FORB" ctx in
  let lb2 = get_new_label ~name:"FORC" ctx in
  ctx
  |> inc_block_level
  |> inc_labelc
  |> set_labels lb0 lb2
  |> gen_init
  |> label lb0
  |> gen_exp cond
  |> cmpl "$0" "%eax"
  |> je lb2
  |> gen_statement body
  |> label lb1
  |> gen_exp post
  |> jmp lb0
  |> label lb2
  |> unset_labels
  |> deallocate_vars ctx

(* TODO *)
and gen_statements stas =
  match stas with
  (* | [ReturnVal e] ->
      gen_statement (ReturnVal e)
     | [s] -> (* when function doesn't have return, return 0 *)
      gen_statement s >>
      gen_statement @@ ReturnVal (Const (Int 0)) *)
  | s :: ss ->
    gen_statement s >>
    gen_statements ss
  | [] -> id

let gen_fun f out =
  match f with
  | Fun (id, bdy) ->
    { fun_name = id; index= -8;
      block_level = 0; labelc = 0;
      startlb = [];  endlb = [];
      vars = []; out = out }
    |> globl id
    |> label id
    |> pushq "%rbp"
    |> movq "%rsp" "%rbp"
    |> gen_statements bdy

let rec gen_prog p out=
  match p with
  | Prog [] -> ();
  | Prog (f :: fs) ->
    let _ = gen_fun f out in
    Out_channel.newline out;
    gen_prog (Prog fs) out
