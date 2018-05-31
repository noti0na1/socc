# OCC

C Compiler in OCaml using ocamllex and menhir

[Writing a C Compiler](https://norasandler.com/2017/11/29/Write-a-Compiler.html)

[Parsing with OCamllex and Menhir](https://dev.realworldocaml.org/parsing-with-ocamllex-and-menhir.html)

[Lexer and parser generators (ocamllex, ocamlyacc)](https://caml.inria.fr/pub/docs/manual-ocaml/lexyacc.html)

[The OCamlbuild Manual](https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc)

[x64_cheatsheet]()

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

There are 4 buildin functions for test:

* `void println(int)`
* `int readi()`
* `void *malloc(size_t)`
* `void free(void *)`

```c
int main() {
    int *pi = malloc(sizeof(int));
    int max = readi();
    for (int i = 0; i < max; i += 2) {
        println(i);
        *pi += i;
    }
    println(*pi);
    free(pi);
    return 0;
}
```

```assembly
.LC0:
	.string "%d\n"
	.globl println
println:
	movq	%rdi, %rsi
	movq	$0, %rax
	movl	$.LC0, %edi
	jmp	printf
.LC1:
	.string "%d"
	.globl readi
readi:
	subq	$24, %rsp
	movl	$.LC1, %edi
	movq	$0, %rax
	leaq	12(%rsp), %rsi
	movl	$0, 12(%rsp)
	call	__isoc99_scanf
	movl	12(%rsp), %eax
	addq	$24, %rsp
	ret
	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$4, %rax
	movq	%rax, %rdi
	call	malloc
	pushq	%rax
	call	readi
	pushq	%rax
	movl	$0, %eax
	pushq	%rax
LmainFORA0:
	movq	-24(%rbp), %rax
	pushq	%rax
	movq	-16(%rbp), %rax
	movq	%rax, %rcx
	popq	%rax
	cmpl	%ecx, %eax
	movl	$0, %eax
	setl	%al
	cmpl	$0, %eax
	je	LmainFORC0
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	println
	movq	-8(%rbp), %rax
	pushq	%rax
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	pushq	%rax
	movq	-24(%rbp), %rax
	movq	%rax, %rcx
	popq	%rax
	addl	%ecx, %eax
	movq	%rax, %rcx
	popq	%rax
	movl	%ecx, (%rax)
	addq	$0, %rsp
LmainFORB0:
	movq	-24(%rbp), %rax
	pushq	%rax
	movl	$2, %eax
	movq	%rax, %rcx
	popq	%rax
	addl	%ecx, %eax
	movq	%rax, -24(%rbp)
	jmp	LmainFORA0
LmainFORC0:
	addq	$8, %rsp
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	println
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movl	$0, %eax
	leave
	ret

```

In: `23`

Out:

```
0
2
4
6
8
10
12
14
16
18
20
22
132
```

## Structure

- `occ/src` source code
    - `ast.ml` abstract syntax tree
    - `parser.mly` parser
    - `lexer.mll` lexer
	- `context.ml`
	- `x64.ml` X64 assembly
	- `templib.ml` temporery lib (`println`, `readi`)
    - `generate.ml` code generator
	- `util.ml` utils
    - `main.ml` program entry
- `occ/test` some test files

## Note

`Core` is used across the project

The output assembly is for x64 platform

## TODO

### Short Term

- [ ] add array type and array operate
- [ ] implement `++` and `--`
- [ ] support comments
- [ ] add more type, implement struct, union, enum
- [ ] complete type system
- [ ] optimize stack usage
- [ ] improve parser further more

### Long Term

- [ ] add error, warning print ...
- [ ] add semantic check pass
- [ ] add intermediate lang

## Licence

OCC is distributed under the terms of [MIT License](LICENSE)

Copyright (c) 2018 noti0na1
