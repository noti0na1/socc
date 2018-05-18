open Ast

let gen_const c =
  match c with
  | Int i -> string_of_int i
  | Char c -> String.make 1 c
  | String s -> s

let gen_unop uop =
  match uop with
  | Negate -> print_string "\tneg\t%eax\n"
  | Pos -> ()
  | Complement -> print_string "\nnot\t%eax\n"
  | Not ->
    print_string "\tcmpl\t$0, %eax\n";
    print_string "\tmovl\t$0, %eax\n";
    print_string "\tsete\t%al\n"

let rec gen_exp e =
  match e with
  | Const c ->
    print_string ("\tmov\t$" ^ (gen_const c) ^ ", %eax\n")
  | UnOp (uop, e) -> gen_exp e; gen_unop uop

let gen_statement s =
  match s with
  | ReturnVal e ->
    gen_exp e;
    print_string "\tret\n"

let gen_fun f =
  match f with
  | Fun (id, bdy) ->
    print_string ("\t.global " ^ id ^ "\n");
    print_string (id ^ ":\n");
    gen_statement bdy

let rec gen_prog p =
  match p with
  | Prog [] -> ();
  | Prog (f :: fs) ->
    gen_fun f; gen_prog (Prog fs)
