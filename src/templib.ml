open Core
open X64

let gen_println ctx =
  ctx
  |> label ".LC0"
  |> dot_string "%d\\n"
  |> globl "println"
  |> label "println"
  |> movq "%rdi" "%rsi"
  |> movq "$0" "%rax"
  |> movl "$.LC0" "%edi"
  |> jmp "printf"

let gen_readi ctx =
  ctx
  |> label ".LC1"
  |> dot_string "%d"
  |> globl "readi"
  |> label "readi"
  |> subq "$24" "%rsp"
  |> movl "$.LC1" "%edi"
  |> movq "$0" "%rax"
  |> leaq "12(%rsp)" "%rsi"
  |> movl "$0" "12(%rsp)"
  |> call "scanf"
  |> movl "12(%rsp)" "%eax"
  |> addq "$24" "%rsp"
  |> ret

let gen_lib ctx =
  ctx |> gen_println |> gen_readi
