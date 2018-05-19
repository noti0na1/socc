	.global main
main:
	movl	$7, %eax
	push	%eax
	movl	$3, %eax
	movl	%eax, %ecx
	pop	%eax
	subl	%ecx, %eax
	ret

