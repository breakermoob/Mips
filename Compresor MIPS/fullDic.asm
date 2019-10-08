			.data
dic:			.word		
			.text
start:		
				addi	$t0, $zero,32		#i=0
				addi	$t1, $zero, 126		#n=256
				la		$s1, dic
				add	$t4,$zero,$s1
Loop:			slt		$t2, $t0, $t1
				beq	$t2, $zero, Exit
				sll		$t3, $t0,2				
				add	$t3,$t3,$t4				#Avanza la direccion del vector
				sw		$t0,0($t3)				#add dic
				addi	$t0,$t0,1				#i++
				j		Loop



Exit:			
				addi	$t5,$zero,50
				sll		$t6,$t5,2
				add	$t6,$t6,$s1
				lw		$a0,0($t6)
				lb		$a1,4($t6)
				li		$v0,1
				syscall
