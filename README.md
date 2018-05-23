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
    int a = 3 / 2;
    int b = 2 * a;
    return -b + 5;
}
```

```assembly
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$3, %eax
	pushq	%rax
	movl	$2, %eax
	movl	%eax, %ecx
	popq	%rax
	xor	%edx, %edx
	idivl	%ecx
	pushq	%rax
	movl	$2, %eax
	pushq	%rax
	movl	-8(%rbp), %eax
	movl	%eax, %ecx
	popq	%rax
	imul	%ecx, %eax
	pushq	%rax
	movl	-16(%rbp), %eax
	neg	%eax
	pushq	%rax
	movl	$5, %eax
	movl	%eax, %ecx
	popq	%rax
	addl	%ecx, %eax
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

- [ ] implement if
- [ ] implement ?:
- [ ] implement while
- [ ] implement for
- [ ] implement more assignments += -= ...
- [ ] implement function call
- [ ] improve parser
- [ ] change code generation to output
- [ ] add error, warning ...

## Licence

MIT License

Copyright (c) 2018 noti0na1
