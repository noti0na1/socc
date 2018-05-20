(Prog
    ((Fun main
         (ReturnVal
             (BinOp Add
                 (BinOp Sub (UnOp Negate (Const (Int 7)))
                     (BinOp Div (Const (Int 3)) (Const (Int 2))))
                 (BinOp Mult (Const (Int 7))
                     (BinOp Add (Const (Int 2)) (Const (Int 0)))))))))
	.global main
main:
	movl	$7, %eax
	neg	%eax
	push	%eax
	movl	$3, %eax
	push	%eax
	movl	$2, %eax
	movl	%eax, %ecx
	pop	%eax
	xor	%edx, %edx
	idivl	%ecx
	movl	%eax, %ecx
	pop	%eax
	subl	%ecx, %eax
	push	%eax
	movl	$7, %eax
	push	%eax
	movl	$2, %eax
	push	%eax
	movl	$0, %eax
	movl	%eax, %ecx
	pop	%eax
	addl	%ecx, %eax
	movl	%eax, %ecx
	pop	%eax
	imul	%ecx, %eax
	movl	%eax, %ecx
	pop	%eax
	addl	%ecx, %eax
	ret

