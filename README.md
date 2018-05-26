# OCC

C Compiler in OCaml using ocamllex and menhir

[Writing a C Compiler](https://norasandler.com/2017/11/29/Write-a-Compiler.html)

[Parsing with OCamllex and Menhir](https://dev.realworldocaml.org/parsing-with-ocamllex-and-menhir.html)

[Lexer and parser generators (ocamllex, ocamlyacc)](https://caml.inria.fr/pub/docs/manual-ocaml/lexyacc.html)

[The OCamlbuild Manual](https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc)

## Install

Dependences: `core, ppx_jane`

```bash
git clone git@github.com:noti0na1/occ.git
cd occ
make
```

The executable file is `main.native`

## Use

```bash
# use gcc to preprocess the source code
gcc -E test.c -o test.e.c
./main.native < test.e.c > test.s
gcc test.s -o test
./test
```

## Example

```c
int main() {
    int a = 1;
    for (int i = 1; i <= 5; i = i + 1)
        a = a * i;
    return a;
}
```

```assembly
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$1, %eax
	pushq	%rax
	movl	$1, %eax
	pushq	%rax
LmainFORA0:
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	$5, %eax
	movl	%eax, %ecx
	popq	%rax
	cmpl	%ecx, %eax
	movl	$0, %eax
	setle	%al
	cmpl	$0, %eax
	je		LmainFORC0
	movl	-8(%rbp), %eax
	pushq	%rax
	movl	-16(%rbp), %eax
	movl	%eax, %ecx
	popq	%rax
	imul	%ecx, %eax
	movl	%eax, -8(%rbp)
LmainFORB0:
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	$1, %eax
	movl	%eax, %ecx
	popq	%rax
	addl	%ecx, %eax
	movl	%eax, -16(%rbp)
	jmp		LmainFORA0
LmainFORC0:
	addq	$8, %rsp
	movl	-8(%rbp), %eax
	leave
	ret
```

## Structure

- `occ/src` source code
    - `ast.ml` abstract syntax tree
    - `parser.mly` parser
    - `lexer.mll` lexer
    - `gen.ml` code generator
    - `main.ml` program start
- `occ/test` some test files

## Note

`Core` is used across the project

The output assembly is for x64 platform

## TODO

- [ ] implement more assignments += -= ...
- [ ] support comment
- [ ] implement function call
- [ ] implement struct
- [ ] implement pointer
- [ ] improve parser more
- [ ] add error, warning print ...

## Licence

OCC is distributed under the terms of [MIT License](LICENSE)

Copyright (c) 2018 noti0na1
