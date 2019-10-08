 .data  
   string1:    .space 32  
   string2:    .space 32  
   finalStr:   .space 32       # A 256 bytes buffer

 .text  
 main:  
   la $s1, finalStr  
   la $s2, string1  
	addi $s4,$zero,67
	sw	$s4,0($s2)
   la $s3, string2  
	addi $s4,$zero,65
	sw	$s4,0($s3)

 copyFirstString:  
   lb $t0, ($s2)                  # get character at address  
   beqz $t0, copySecondString
   sb $t0, ($s1)                  # else store current character in the buffer  
   addi $s2, $s2, 1               # string1 pointer points a position forward  
   addi $s1, $s1, 1               # same for finalStr pointer  
   j copyFirstString              # loop  

 copySecondString:  
   lb $t0, ($s3)                  # get character at address  
   beqz $t0, Exit
   sb $t0, ($s1)                  # else store current character in the buffer  
   addi $s3, $s3, 1               # string1 pointer points a position forward  
   addi $s1, $s1, 1               # same for finalStr pointer  
   j copySecondString              # loop  

Exit: add $a0,$zero,$s1
	li	$v0,4
	syscall

