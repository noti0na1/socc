	.file	"test.c"
	.text
	.globl	f
	.type	f, @function
f:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	-4(%rbp), %eax
	imull	-8(%rbp), %eax
	popq	%rbp
	ret
	.size	f, .-f
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$16, %rsp
	movl	$5, -12(%rbp)
	movl	$4, %esi
	movl	$3, %edi
	call	f
	movl	%eax, %ebx
	movl	-12(%rbp), %eax
	movl	%eax, %esi
	movl	$1, %edi
	call	f
	movl	%ebx, %esi
	movl	%eax, %edi
	call	f
	addq	$16, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 7.3.1 20180303 (Red Hat 7.3.1-5)"
	.section	.note.GNU-stack,"",@progbits
