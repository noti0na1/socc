	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$2, %eax
	pushq	%rax
	movl	-8(%rbp), %eax
	pushq	%rax
	movl	$2, %eax
	movl	%eax, %ecx
	popq	%rax
	cmpl	%ecx, %eax
	xor		%eax, %eax
	setge	%al
	cmpl	$0, %eax
	je	LmainIFA0
	movl	$3, %eax
	pushq	%rax
	movl	-16(%rbp), %eax
	pushq	%rax
	movl	$1, %eax
	movl	%eax, %ecx
	popq	%rax
	addl	%ecx, %eax
	pushq	%rax
	movl	-24(%rbp), %eax
	pushq	%rax
	movl	$2, %eax
	movl	%eax, %ecx
	popq	%rax
	imul	%ecx, %eax
	movl	%eax, -8(%rbp)
	addq	$16, %rsp
	jmp	LmainIFB0
LmainIFA0:
	movl	-8(%rbp), %eax
	cmpl	$0, %eax
	je	LmainCDA1
	movl	$7, %eax
	jmp	LmainCDB1
LmainCDA1:
	movl	$9, %eax
LmainCDB1:
	movl	%eax, -8(%rbp)
	addq	$0, %rsp
LmainIFB0:
	movl	-8(%rbp), %eax
	pushq	%rax
	movl	$0, %eax
	movl	%eax, -8(%rbp)
	movl	-16(%rbp), %eax
	leave
	ret
