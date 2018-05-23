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

