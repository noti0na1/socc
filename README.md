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

## Usage

```bash
# use gcc to preprocess the source code
gcc -E test.c -o test.e.c
./main.native < test.e.c > test.s
gcc test.s -o test
./test
```

## Example

```c
int factorial(int n) {
    if (n < 0) return 0;
    int c = 1;
    for (int i = 1; i <= n; i += 1) {
        c *= i;
    }
    return c;
}

int main() {
    return factorial(5);
}
```

```assembly
	.globl factorial
factorial:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	movl	-8(%rbp), %eax
	pushq	%rax
	movl	$0, %eax
	movl	%eax, %ecx
	popq	%rax
	cmpl	%ecx, %eax
	movl	$0, %eax
	setl	%al
	cmpl	$0, %eax
	je	LfactorialIFA0
	movl	$0, %eax
	leave
	ret
	jmp	LfactorialIFB0
LfactorialIFA0:
LfactorialIFB0:
	movl	$1, %eax
	pushq	%rax
	movl	$1, %eax
	pushq	%rax
LfactorialFORA1:
	movl	-24(%rbp), %eax
	pushq	%rax
	movl	-8(%rbp), %eax
	movl	%eax, %ecx
	popq	%rax
	cmpl	%ecx, %eax
	movl	$0, %eax
	setle	%al
	cmpl	$0, %eax
	je	LfactorialFORC1
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	-24(%rbp), %eax
	movl	%eax, %ecx
	popq	%rax
	imul	%ecx, %eax
	movl	%eax, -16(%rbp)
	addq	$0, %rsp
LfactorialFORB1:
	movl	-24(%rbp), %eax
	pushq	%rax
	movl	$1, %eax
	movl	%eax, %ecx
	popq	%rax
	addl	%ecx, %eax
	movl	%eax, -24(%rbp)
	jmp	LfactorialFORA1
LfactorialFORC1:
	addq	$8, %rsp
	movl	-16(%rbp), %eax
	leave
	ret

	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$5, %eax
	movq	%rax, %rdi
	call	factorial
	leave
	ret
```

## Structure

- `occ/src` source code
    - `ast.ml` abstract syntax tree
    - `parser.mly` parser
    - `lexer.mll` lexer
	- `context.ml`
	- `x64.ml` X64 assembly
    - `generate.ml` code generator
	- `util.ml` utils
    - `main.ml` program entry
- `occ/test` some test files

## Note

`Core` is used across the project

The output assembly is for x64 platform

## TODO

### Short Term

- [ ] implement `++` and `--`
- [ ] optimize stack usage
- [ ] support comments
- [ ] implement pointer
- [ ] implement struct
- [ ] improve parser further more

### Long Term

- [ ] add error, warning print ...
- [ ] add check pass
- [ ] add intermediate lang

## Licence

OCC is distributed under the terms of [MIT License](LICENSE)

Copyright (c) 2018 noti0na1
