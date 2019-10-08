# String concatenate

.text

# Copy first string to result buffer
la $a0, str2
addi $t0,$zero,67
sw $t0,0($a0)
la $a1, str1
addi $t0,$zero,65
sw $t0,0($a1)
jal loop

j finish

loop:
lb $t2, 0($a0)
beq $t2, $zero, end
addiu $t0, $a0, 1
sb $t2, 0($a1)
addiu $a1, $a1, 1
b loop


end:
jr $ra


finish:
la $a0, str1
li  $v0, 4
syscall

.data
str1:	.word

.align 2
str2:	.space 200
