open Core
open Fn
open Ast
open Context
open X64

let (>>) f g a = g (f a)

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
  | Assign (_, var, vexp) -> (* TODO *)
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
  | Call (f, _) -> (* TODO *)
    call f ctx
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
  keep_labelc ctx1 ctx2

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
  | For f ->
    gen_for (gen_exp f.init) f.cond f.post f.body ctx
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
