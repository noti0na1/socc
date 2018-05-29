	.globl f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	movl	-8(%rbp), %eax
	pushq	%rax
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	-24(%rbp), %eax
	movl	%eax, %ecx
	popq	%rax
	imul	%ecx, %eax
	movl	%eax, %ecx
	popq	%rax
	addl	%ecx, %eax
	pushq	%rax
	movl	-32(%rbp), %eax
	pushq	%rax
	movl	$1, %eax
	movl	%eax, %ecx
	popq	%rax
	addl	%ecx, %eax
	leave
	ret

	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	pushq	%rax
	movl	-8(%rbp), %eax
	pushq	%rax
	movl	-8(%rbp), %eax
	movl	%eax, %ecx
	popq	%rax
	imul	%ecx, %eax
	movl	%eax, -8(%rbp)
	movl	$2, %eax
	pushq	%rax
	movl	$0, %eax
	movq	%rax, %rdi
	movl	-8(%rbp), %eax
	pushq	%rax
	movl	$1, %eax
	movl	%eax, %ecx
	popq	%rax
	addl	%ecx, %eax
	movq	%rax, %rsi
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	$2, %eax
	movl	%eax, %ecx
	popq	%rax
	addl	%ecx, %eax
	movq	%rax, %rdx
	call	f
	pushq	%rax
	movl	-24(%rbp), %eax
	leave
	ret

