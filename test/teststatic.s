	.file	"teststatic.c"
	.text
	.globl	f
	.type	f, @function
f:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	si.2247(%rip), %edx
	movl	sci.2248(%rip), %eax
	addl	%edx, %eax
	movl	%eax, si.2247(%rip)
	movl	si.2247(%rip), %eax
	popq	%rbp
	ret
	.size	f, .-f
	.section	.rodata
.LC0:
	.string	"%d\n"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	call	f
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	call	f
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	call	f
	movl	%eax, %esi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	popq	%rbp
	ret
	.size	main, .-main
	.local	si.2247
	.comm	si.2247,4,4
	.section	.rodata
	.align 4
	.type	sci.2248, @object
	.size	sci.2248, 4
sci.2248:
	.long	2
	.ident	"GCC: (GNU) 7.3.1 20180303 (Red Hat 7.3.1-5)"
	.section	.note.GNU-stack,"",@progbits
