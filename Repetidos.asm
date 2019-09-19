			.data
array1:		.word	
array2:		.word	
			.text
start:		
			la		$a0, array1		#  Direccion de repetidos
			addi		$a1, $zero, 0#array1 Length
			la		$a3, array2		#Direccion del nuevo vector
			jal		search

search:		
			add		$t0, $zero, $a0		#Direccioin del array1
			add		$t1, $zero, $a3		#Direccion del array2
			add		$t2, $zero, $a1		#Tamaño del array1  n
			add		$t3, $zero, $zero	#i=0
			sll		$t4, $t3, 2			
			add		$t4, $t4, $t0
			lw		$t4, 0($t4)			#array1[0]
			addi		$s2, $zero, 1			#k=1
			sll		$t5, $t3, 2		
			add		$t5, $t5, $t1
			sw		$t4, 0($t5)		       #array2[0]=array1[0]
			
loopi:		
			slt		$t6, $t3, $t2		
			beq		$t6, $zero, Exit		#while(i<n)
			sll		$t4, $t3, 2			
			add		$t4, $t4, $t0
			lw		$t4, 0($t4)			#array1[i] -> Evaluado
			add		$t7, $zero, $zero	#j=0		

loopj:		
			slt		$s1, $t7, $s2		
			beq		$s1, $zero, iup		#while(j<k)
			sll		$t5, $t7, 2		
			add		$t5, $t5, $t1
			lw		$t5, 0($t5)			#array2[ j ]
			bne		$t5, $t4, jupFirst       #if(Evaluado == array2[ j ])
			add		$t7, $zero, $s2		# j=k+1

 jupFirst:		
			addi		$t7, $t7, 1			#j++
			bne		$t7, $s2, loopj		#if(j == k)
			sll		$s0, $s2, 2
			add		$s0, $s0, $t1
			sw		$t4, 0($s0)			# array2[ k ] = Evaluado
			addi		$s2, $s2, 1			#k++
			addi		$t7, $t7, 1			#j++
			j		loopj		

iup	:		
			addi		$t3, $t3, 1			#i++
			j		loopi				#Iterar


Exit:		...
