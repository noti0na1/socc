open Core
open X64

let gen_print ctx =
  ctx
  |> label ".LC0"
  |> dot_string "%d\\n"
  |> globl "println"
  |> label "println"
  |> pushq "%rbp"
  |> movq "%rsp" "%rbp"
  |> subq "$16" "%rsp"
  |> movl "%edi" "-4(%rbp)"
  |> movl "-4(%rbp)" "%eax"
  |> movl "%eax" "%esi"
  |> movl "$.LC0" "%edi"
  |> movl "$0" "%eax"
  |> call "printf"
  |> leave
  |> ret
