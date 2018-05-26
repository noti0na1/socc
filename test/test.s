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
	je	LmainFORC0
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
	jmp	LmainFORA0
LmainFORC0:
	addq	$8, %rsp
	movl	-8(%rbp), %eax
	leave
	ret

