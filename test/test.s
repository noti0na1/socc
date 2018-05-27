	.globl f
f:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$1, %eax
	leave
	ret

	.globl main
main:
	pushq	%rbp
	movq	%rsp, %rbp
	call	f
	leave
	ret

