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
	call	scanf
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

