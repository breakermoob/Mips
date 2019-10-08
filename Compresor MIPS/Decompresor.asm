.include "readFile.asm"    

.data
.align 2
str1:    .space 32  
str2:    .space 32  
result:   .space 32       # A 32 bytes buffer
file_out:	.asciiz "output.txt"	#  Archivo Descomprimido Salida

.align 2
dic:			.space 20000	

.text
 	readFile("input.txt",20000)				#Macro para leer el archivo
	move	$s0, $v0
	la	    	$s0,0($s0)							#$s0 Apuntador input  
	add    	$s4, $zero, $a3						#Tamaño de input en $s4
	add	$a2,$zero,$s0						#apuntador cod_viejo

#Vars
#$a0  -> prints
#$a1  -> Result
#$a2  -> apuntador cod_viejo
#$a3  -> apuntador cod_nuevo
#$t0  -> i	
#$t1  -> Resp
#$t2  -> n-1
#$t3  -> cadena
#$t4  -> j
#$t5  -> caracter
#$t6  -> aux
#$t7  -> aux
#$t8  -> aux
#$t9  -> cod_viejo
#$s0  -> apuntador input
#$s1  -> apuntador dic
#$s2  -> m len input
#$s3  -> cod_nuevo
#$s4  -> n len dic
#$s5  -> aux
#$s6  ->  aux apuntadores
#$s7  -> direccion traducir palabra



LlenarDic:		li		$t0, 32					#i=0
				li		$s2,126				#m=126
				la		$s1, dic
				add	$a3, $zero, $s1			#Apuntador cod_nuevo

				add	$t4,$zero,$s1
Loop:			slt		$t2, $t0, $s2			#Llenamos el diccionario en memoria
				beq	$t2, $zero, FinDic
				sll		$t3, $t0,2				
				add	$t3,$t3,$t4				#Avanza la direccion del vector
				sw		$t0,0($t3)				#add dic
				addi	$t0,$t0,1				#i++
				j		Loop

FinDic:	

				
StartDeco:		add	$t0, $zero, $zero		#i=0 $to	
				jal		buscarLetra			#=cod_viejo = file[0]
				add	$t9,$zero,$s5
				add	$a2, $s6, 1				#apuntador cod_viejo
				jal 		Traducir
				add	$t5,$s5,$zero			#caracter
				add	$t5,$s5,$zero			#caracter
				la 		$a0, str2
				sw		$t5,0($a0)							
   				li 		$v0, 4     								
						syscall					
												#$s2    len(file)
				subi	$t2, $s4,1				#n-1 para el while
While_i:		slt		$t3, $t0, $t2			#i<n-1
				beqz	$t3, Exit				
				add	$t4, $zero, $zero		#j=0 $t4
				addi	$a2, $s6, 1				#apuntador cod_viejo
				jal		buscarLetra			#=cod_nuevo = file[i+1]
				add	$s3, $s5,$zero			#cod_nuevo
				add	$a3, $zero, $s6			#apuntador cod_nuevo
												#m=len(Dicctionary) $s4 
				add	$t1,$zero,$zero		#Resp=0  $t1 

				
While_j	:		slt		$t8,$t4,$s2
				beqz	$t8, If_i
				jal		buscarLetra			#file[j]
				add	$t3,$s5,$zero			#file[j]
				bne	$t3, $s3, Else			#cod_nuevo== file[j]
				addi	$t1,$zero,1			#resp=1
				add	$t4,$zero,$s2			#j=m
				j		While_j
Else:			add	$t1,$zero,$zero		#resp=0
				addi	$t4,$t4,1				#j++
				j		While_j

If_i:				beqz	$t1, Else_i				#if(resp==1)
				add	$t3,$zero,$s3
				la 		$a0, result		
				sw		$t3,0($a0)
				j		Print

Else_i:			
				add	$t3,$zero,$t5
				la	 	$a0, str1
				sw		$t5,0($a0)
				la		$a1, result
				jal 		primerStr				#Concatenamos el primer string
				la 		$a0, str2
				sw		$t3,0($a0)
				jal 		segundoStr			#Concatenamos el segundo string


Print:			la 		$a0, result
				li  		$v0, 4
				syscall
				lb		$t5,0($a0)				#cadena[0]
				la	 	$a0, str1
				sw		$t9,0($a0)
				la		$a1, result
				jal 		primerStr				#Concatenamos el primer string
				la 		$a0, str2
				sw		$t5,0($a0)
				jal 		segundoStr			#Concatenamos el segundo string		
				la		$a0, result
				#li		$v0,4
pare:			#syscall
				lw		$t5,0($a0)				#caracter = traducir(cod_viejo)+cadena
				add	$t8,$s4,$t0				#n+i
				sll		$t8,$t8,2
				add	$t8,$t8,$s0
				sw		$t5,0($t8)				#append en el diccionario
				add	$t9,$zero,$s3			#cod_viejo=cod_nuevo
				addi	$t0,$t0,1
				j		While_i
				



# Funcion para concatenar
primerStr:  		lb		$t8, ($a0)                # obtiene el caracter  
  				beqz	$t8, salir
   				sb 		$t8, ($a1)                # guarda el byte actual  
 			  	addi 	$a0, $a0, 1             # avanza
   				addi 	$a1, $a1, 1             # avanza
  				j 		primerStr              # loop  

  
 segundoStr:	lb 		$t8, ($a0)                   
   				beqz 	$t8, salir
   				sb 		$t8, ($a1)                  
 				 addi 	$a0, $a0, 1               
 				 addi 	$a1, $a1, 1                
  				 j 		segundoStr              

salir: 			jr		$ra

#Procedimiento buscarLetra, ingresa en el archivo y captura una serie de bytes, ademas los pasa a ascii			
buscarLetra:	add	$t7,$zero,$zero		#$t7=k		k tendra la direccion de memoria en el archivo
				add	$s5,$zero,$zero		#$s5 Iniciamos el numero en 0  este sera la letra en el archivo comprimido 
While_k:		addi	$t6,$zero, 32			#Separador
				add	$s6,$t7,$a2				#apuntador en k
				lb		$t8,0($s6)				#$t8 byte actual
				addi	$t7,$t7,1				#k++
				beq	$t8, $t6, out			#Saltamos si encuentra espacio
				subi	$t8,$t8,48
				addi	$t6,$zero,10			#10 para hacer una multiplicacion
				mult	$s5,$t6					#multiplicamos por 10 para correr nuestro numero
				mflo	$s5						#recuperamos el producto
				add	$s5,$s5,$t8				#concatenamos al final
				j		While_k
out:			jr		$ra

#Procedimiento Traducir, busca en el banco de registros la letra que corresponde a la serie de bytes encontrdos con buscarLetra
Traducir:		sll		$s7,$s5,2
				add	$s7,$s7,$s1
				jr		$ra 						# return		
				
						
Exit:		li   $v0, 10	# System call for exit
			syscall
			...
