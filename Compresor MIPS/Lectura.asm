
.data
file_in:		.asciiz "input.txt"	# Archivo Comprimido Entrada
file_out:	.asciiz "output.txt"	#  Archivo Descomprimido Salida
file_dic:		.asciiz "dic.txt"		# Diccionario

sentence:	.byte	# 0x0D: Ascii para retorno de carro. 0x0A: Ascii para salto de línea  0x0D, 0x0A, 0x0D, 0x0A
sentence_cont:	.asciiz "?"

.align 2
input_buffer_in:		.space 20000
.align 2
input_buffer_dic:	.space 20000

.text

# Open (for reading) a file
	li $v0, 13		# System call for open file
	la $a0, file_in		# Input file name
	li $a1, 0		# Open for reading (flag = 0)
	li $a2, 0		# Mode is ignored
	syscall			# Open a file (file descriptor returned in $v0)
	move $s0, $v0		# Copy file descriptor

 # Open (for writing) a file that does not exist
	li $v0, 13		# System call for open file
	la $a0, file_dic	# Output file name
	li $a1, 9		# Open for writing and appending (flag = 9)
	li $a2, 0		# Mode is ignored
	syscall			# Open a file (file descriptor returned in $v0)
	move $s2, $v0		# Copy file descriptor

# Open (for writing) a file that does not exist
	li $v0, 13		# System call for open file
	la $a0, file_out	# Output file name
	li $a1, 9		# Open for writing and appending (flag = 9)
	li $a2, 0		# Mode is ignored
	syscall			# Open a file (file descriptor returned in $v0)
	move $s1, $v0		# Copy file descriptor

# Read from previously opened file
	li $v0, 14	# System call for reading from file
	move $a0, $s0		# File descriptor
	la $a1, input_buffer_in	# Address of input buffer
	li $a2, 20000		# Maximum number of characters to read
	syscall			# Read from file
	move $t1, $v0		# Copy number of characters read

# Copy the file loaded in memory into the output file

	li $v0, 15		# System call for write to a file
	move $a0, $s1		# Restore file descriptor (open for writing)
	la $a1, input_buffer_in	# Address of buffer from which to write
	move $a2, $t1		# Number of characters to write
	syscall


# Read from previously opened file
	li $v0, 14		# System call for reading from file
	move $a0, $s0		# File descriptor
	la $a1, input_buffer_in	# Address of input buffer
	li $a2, 20000		# Maximum number of characters to read
	syscall			# Read from file
	move $t2, $v0		# Copy number of characters read

# Copy the file loaded in memory into the output file

	li $v0, 15		# System call for write to a file
	move $a0, $s2		# Restore file descriptor (open for writing)
	la $a1, input_buffer_in	# Address of buffer from which to write
	move $a2, $t1		# Number of characters to write
	syscall
	
# Append a sentence to the output file file
#	li $v0, 15		# System call for write to a file
#	move $a0, $s1		# Restore file descriptor (open for writing)
#	la $a1, sentence	# Address of buffer from which to write
#	li $a2, 32		# Number of characters to write
#	syscall

# Close the files
  	li   $v0, 16       # system call for close file
	move $a0, $s0      # file descriptor to close
	syscall            # close file
	
	li   $v0, 16       # system call for close file
	move $a0, $s1      # file descriptor to close
	syscall            # close file
	
	li   $v0, 16       # system call for close file
	move $a0, $s2      # file descriptor to close
	syscall    
			
Exit:	li   $v0, 10	# System call for exit
	syscall
