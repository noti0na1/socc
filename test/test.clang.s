	.file	"test.c"
	.text
	.globl	fun
	.type	fun, @function
fun:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$3, -4(%rbp)
	movl	$1, -8(%rbp)
	movl	-4(%rbp), %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	popq	%rbp
	ret
	.size	fun, .-fun
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	$1, -4(%rbp)
	cmpl	$1, -4(%rbp)
	jle	.L4
	movl	$2, -8(%rbp)
	movl	-8(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	.L5
.L4:
	movl	$0, %eax
	call	fun
	movl	%eax, -4(%rbp)
.L5:
	movl	-4(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 7.2.1 20170829 (Red Hat 7.2.1-1)"
	.section	.note.GNU-stack,"",@progbits
