.data
str: .asciiz "The sum is "
.text
li  $v0, 4
la  $a0, str
syscall