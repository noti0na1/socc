open Core
open Context

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

let call = slcmd "call"

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
