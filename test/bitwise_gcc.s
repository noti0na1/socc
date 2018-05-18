	.file	"bitwise.c"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
	xorl	%eax, %eax
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 7.2.1 20170829 (Red Hat 7.2.1-1)"
	.section	.note.GNU-stack,"",@progbits
