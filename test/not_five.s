	.global main
main:
	mov	$5, %eax
	cmpl	$0, %eax
	movl	$0, &eax
	sete	%al
	ret
