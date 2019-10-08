.text
main:
	li $t0, 1
	jal procedure # call procedure
	li  $v0, 1           # service 1 is print integer
	add $a0, $t0, $zero  # load desired value into argument register $a0, using pseudo-op
	syscall
	li  $v0, 10         # out
	syscall

procedure:
	li $t0, 3
	jr $ra # return
