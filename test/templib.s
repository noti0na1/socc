	.file	"templib.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%d\n"
	.text
	.p2align 4,,15
	.globl	println
	.type	println, @function
println:
	movl	%edi, %esi
	xorl	%eax, %eax
	movl	$.LC0, %edi
	jmp	printf
	.size	println, .-println
	.section	.rodata.str1.1
.LC1:
	.string	"%d"
	.text
	.p2align 4,,15
	.globl	readi
	.type	readi, @function
readi:
	subq	$24, %rsp
	movl	$.LC1, %edi
	xorl	%eax, %eax
	leaq	12(%rsp), %rsi
	movl	$0, 12(%rsp)
	call	__isoc99_scanf
	movl	12(%rsp), %eax
	addq	$24, %rsp
	ret
	.size	readi, .-readi
	.p2align 4,,15
	.globl	alloc
	.type	alloc, @function
alloc:
	movslq	%edi, %rdi
	jmp	malloc
	.size	alloc, .-alloc
	.p2align 4,,15
	.globl	freep
	.type	freep, @function
freep:
	jmp	free
	.size	freep, .-freep
	.ident	"GCC: (GNU) 7.3.1 20180303 (Red Hat 7.3.1-5)"
	.section	.note.GNU-stack,"",@progbits
