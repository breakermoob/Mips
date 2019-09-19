# Punto 6B
#División apatir de restas
			.data
array1:		.word	10
array2:		.word	3	#  declare 12 bytes of storage to hold array of 3 integers
			.text
start:		la		$s0, array1		#  load base address of array into register $t0
			lw		$s0, 0($s0)
			la		$s1, array2		#  load base address of array into register $t0
			lw		$s1, 0($s1)
			add		$a0, $zero, $s0	# X
			add		$a1, $zero, $s1	# Y
			jal		resta
					#Llamado al procedimiento


#Procedimiento
resta:		add		$t0, $a0, $zero   #X
			add		$t1, $a1, $zero   #Y
			add		$t2, $zero, $zero #count=0
loop:		sub		$t3, $t0, $t1		# $t3 = $t0 - $t1
			beq		$t0, $t1, fix
			slt		$t4, $zero, $t3	# 0 < X-Y
equals:		beq		$t4, $zero, Exit	# if $t4 == $zero then Exit
			sub		$t0, $t0, $t1		# $t0 = $t0 - $t1
			addi		$t2, $t2, 1			# $t2 = $t2 + 1
			j		loop					# jump to loop
fix:			addi		$t4, $zero, 1
			j		equals
Exit:		add		$v1, $t0, $zero		# $v1 = $t0 + $zero
			add		$v0, $t2, $zero		# $v0 = $t2 + $zero
			jr		$ra						# jump to $ra

#Punto 6C - Cuando el Y es 0 el modulo seria igual a igual que X
#Y la división da 0q