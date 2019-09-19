# Punto 6B
#División apatir de restas
#Breakermoob

#Suponiendo que:
#$s0 = x
#$s1 = y

main:
add		$a0, $zero, $s0	# X
add		$a1, $zero, $s1	# Y
jal		resta					#Llamado al procedimiento


#Procedimiento
resta:
add		$t0, $a0, $zero   #X
add		$t1, $a1, $zero   #Y
add		$t2, $zero, $zero #count=0
loop:
sub		$t3, $t0, $t1		# $t3 = $t0 - $t1
slt		$t4, $zero, $t3	# 0 < X-Y
beq		$t4, $zero, Exit	# if $t4 == $zero then Exit
sub		$t0, $t0, $t1		# $t0 = $t0 - $t1
addi		$t2, $t2, 1			# $t2 = $t2 + 1
j			loop					# jump to loop
Exit:
#$v1 es X % Y
add		$v1, $t0, $zero		# $v1 = $t0 + $zero
add		$v0, $t2, $zero		# $v0 = $t2 + $zero
jr			$ra						# jump to $ra

#Punto 6C - Cuando el Y es 0 el modulo seria igual a igual que X
#Y la división da 0q