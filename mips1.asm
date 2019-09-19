			.data
array1:		.word	3, 2, 1, 0, 1, 2
array2:		.word
			.text
start:		la		$t0, array1		#  load base address of array into register $t0
			la		$t3, array2
			add 		$t2, $zero, $zero # i = 0
loop:		sll 		$t1, $t2, 2
			sll 		$t4, $t2, 2
			add		 $t1, $t1, $t0
			add		 $t4, $t4, $t3
			lw 		$t1, 0($t1) 
			addi 	$t5, $t1,1
			sw		$t5, 0($t4)
			addi		 $t2, $t2, 1
			j 		loop
		