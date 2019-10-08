.include "Leer.asm"

.data
archivoDiccionario:	.asciiz "diccionario.txt"
input:			.asciiz "input.txt"

.align 2
input_buffer:	.space 20000
.align 2
output_buffer:	.space 20000	
.align 0
diccionario:	.space 20000
.align 2
diccionarioDinamico:	.space 20000

.text
# Creo el diccionario DINAMICO
	la $s7,diccionarioDinamico # Inicializo un apuntador a la base del vector dinamico


# Leo el diccionario
	openFileRead(archivoDiccionario) 
	readFile($t9,diccionario,20000)
	closeFile($t9)
	move $s0,$a1	# s0 tiene la direccion inicial del diccionario
	move $s2,$t0	# s2 tiene la cantidad de caracteres del diccionario
#	move $a1,$a1	# s4 tiene la direccion inicial del diccionario	
	
# Leo archivo de caracteres
	openFileRead(input) 
	readFile($t9,input_buffer,20000)
	closeFile($t9)
	# El texto a comprimir tendra como maximo 10000 caracteres
	move $s1,$a1	# s4 tiene la direccion inicial del texto a comprimir
	move $s3,$t1	# s5 tiene la cantidad de caracteres leido del archivo
	move $a3,$s1	# s4 tiene la direccion inicial del texto a comprimir	

# Inicializar variables y apuntadores
	li $t0,2		# Inicializo W
	li $t1,0		# Inicializo un apuntador para W
	li $t2,0		# Inicializo una variable para la longitud de W
	li $t3,0		# Inicializo una variable para la longitud de K
	li $t4,0		# Inicializo una variable para recorrer el numero de caracteres
	li $s4,0		# Inicializo la longitud del vector dinamico en 0
	move $s5,$s7		# Copio la base del vector dinamico en s5

Loop:
# Comparar si aun hay caracteres para leer
	slt $t5,$t4,$s3		# Si la variable t4 es menor que el numero de variables llevo 1
	bne $t5,1,Exit		# Si la variable $t5 no es igual a 1 voy a Final
	
# Leer caracter del archivo de caracteres
	lb $t6,0($a3)		# Cargo en t6 el caracter en la posicion 0 de a3
	addi $t3,$t3,1		# Agrego 1 a la longitud de K
	addi $t4,$t4,1		# Le sumo 1 a el contador t4
	move $a0,$t2		# Copio la longitud de W en un parametro a0 
	move $a2,$t3		# Copio la longitud de K en un parametro a2
	jal Buscar		# Salto al procedimiento para buscar una cadena en el diccionario
	move $t1,$v1		# Copio el resultado de buscar de a0 en el indice W
	li $t5,-1		# Inicializo t5 en -1
	bne $t1,$t5,Avanzar	# Si el Indice W es diferente de -1, voy a la etiqueta Avanzar
	beq $t1,$t5,Agregar	# Si el Indice W es igual a -1, voy a la etiqueta Agregar


Avanzar:
# Concateno W y K y modifico las longitudes
	
	sll $t8,$t6,8		# Corro K 8 posiciones para concatenar con W
	or  $s6,$t0,$t8		# Concateno W y K
	add $t2,$t2,$t3		# A longitud de W le llevo longitud w + longitud k
	addi $a3,$a3,1		# Aumento la poicion en el vector a3 
	addi $t4,$t4,1		# Aumento la variable para recorrer el arcivo
	j Loop			# Vuelvo al ciclo principal

Agregar:

# Imprimo el apuntador de W y agrego W+K al diccionario	
	sll $t8,$t6,8		# Corro K 8 posiciones para concatenar con W
	or  $s6,$t0,$t8		# Concateno W y K
# Comparo a cual diccionario agregar
	beq $t8,1,AgregarDiccionario	#Si LongitudW + Longitud K es igual a 1, voy a la etiqueta AgregarDiccionarioInicial
	
#Agrego en el diccionario dinamico
	sw $s6,0($s5)
	addi $s5,$s5,4	
	
# Muevo las longitudes y los caracteres	
	move $t0,$t6		# A W le llevo K
	addi $t2,$t3,0		# A longitud de W le llevo la longitud de K
	add $t8,$t2,$t3		# Llevo longitud W + longitud K a t8
	addi $t1,$s2,1		# Muevo el indice W a la posicion donde agrego
	add $s4,$s4,$t8		# Le adiciono t8  al numero de caracteres del diccionario dinamico
	#IMPRIMIR APUNTADOR
	#--------------
	li  $v0, 1           # service 1 is print integer
	add $a0, $t1, $zero  # load desired value into argument register $a0, using pseudo-op
	syscall
	#--------------
	addi $a3,$a3,1		# Aumento la poicion en el vector a3 
	addi $t4,$t4,1		# Aumento la variable para recorrer el arcivo
	j Loop			# Vuelvo al ciclo principal

AgregarDiccionario:
#Agrego en el diccionario Inicial
	sw $s6,0($a1)
	addi $a1,$a1,1	
	
# Muevo las longitudes y los caracteres	
	move $t0,$t6		# A W le llevo K
	addi $t2,$t3,0		# A longitud de W le llevo la longitud de K
	addi $t1,$s2,1		# Muevo el indice W a la posicion donde agrego
	addi $s2,$s2,1		# Le agrego uno a la variable longitud del diccionario inicial
	#IMPRIMIR APUNTADOR
	#--------------
	li  $v0, 1           # service 1 is print integer
	add $a0, $t1, $zero  # load desired value into argument register $a0, using pseudo-op
	syscall
	#--------------
	addi $a3,$a3,1		# Aumento la poicion en el vector a3 
	addi $t4,$t4,1		# Aumento la variable para recorrer el arcivo
	j Loop			# Vuelvo al ciclo principal


# Procedimiento para buscar una cadena en el diccionario
Buscar:
	
	li $t5,0		# Inicializo un contador i en 0
	li $t7,0		# Inicializo un indice en 0
	add $t8,$a0,$a2		# Sumo Longitud de W y Longitud de K en t8
	
	# Busco en el diccionario inicial
	beq $t8,1,MeDevuelvo	#Si LongitudW + Longitud K es igual a 1, voy a la etiqueta BuscarDiccionarioInicial
	
LoopDinamico:	
	# Busco en el diccionario dinamico
	slt $t8,$t5,$s4		# Si el indice i es menor que el tamaño del diccionario dinamico, llevo 1
	bne $t8,1,SalidaLoopDinamico	# si i no es menor que el tamaño, salgo del loop dinamico
	add $t8,$s5,$t7		# Agrego en t8 la base del vector dinamico y el indice
	lw $t8,0($t8)		# Llevo a t8 lo que contiene t8 en la posicion 0
	beq $t8,$s6,SalidaLoopDinamico	# si lo que contiene t8 es igual a la cadena W+K salgo
	addi $t5,$t5,1		# Avanzo con el contador en 1
	addi $t7,$t7,4		# Avanzo con el indice en 4
	move $a0,$t5		# Muevo el indice de w
	subi $a0,$zero,1	# Llevo -1 a a0 mientras no se encuentre el caracter en el diccionario
	j LoopDinamico
	
SalidaLoopDinamico:

	addi $t5,$t5,1		# Avanzo con el contador en 1
#	add $a0,$t5,$s2
#	jr $ra
	j Buscar

MeDevuelvo:
	move $v1,$a0
	jr $ra
	
LoopInicial:
	# Busco en el diccionario inicial
	slt $t8,$t5,$s2		# Si el indice i es menor que el tamaño del diccionario inicial, llevo 1
	bne $t8,1,SalidaLoopInicial	# si i no es menor que el tamaño, salgo del loop dinamico
	add $t8,$s0,$t5		# Agrego en t8 la base del diccionario inicial y el contador
	lb $t8,0($t8)		# Llevo a t8 lo que contiene t8 en la posicion 0
	beq $t8,$s6,SalidaLoopInicial	# si lo que contiene t8 es igual a la cadena W+K salgo
	addi $t5,$t5,1		# Avanzo con el contador en 1
	move $a0,$t5		# Muevo el indice de w
	subi $a0,$zero,1	# Llevo -1 a a0 mientras no se encuentre el caracter en el diccionario
	j LoopInicial
	
SalidaLoopInicial:	


#	addi $a0,$t5,0
#	jr $ra
	j Buscar



Exit:	
	#IMPRIMIR APUNTADOR DE W
	#------------
	li  $v0, 1           # service 1 is print integer
	add $a0, $t1, $zero  # load desired value into argument register $a0, using pseudo-op
	syscall
	#-------------
	closeFile($t9)
	
	# Close the files
#  	li   $v0, 16       # system call for close file
#	move $a0, $s0      # file descriptor to close
#	syscall            # close file
	
#	li   $v0, 16       # system call for close file
#	move $a0, $s1      # file descriptor to close
#	syscall            # close file

	li   $v0, 10	# System call for exit
	syscall
