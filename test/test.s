	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$1, %eax
	pushq	%rax
	movl	-8(%rbp), %eax
	cmpl	$0, %eax
	je	LmainCD00
	movl	$2, %eax
	movl	%eax, -8(%rbp)
	jmp	LmainCD11
LmainCD00:
	movl	$3, %eax
	movl	%eax, -8(%rbp)
LmainCD11:
	movl	-8(%rbp), %eax
	leave
	ret

