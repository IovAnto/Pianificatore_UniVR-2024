.section .data

tot: .byte 0			

.section .text
	.global itoa

.type itoa, @function		# dichiaro la funzione itoa che
							# converte un intero in una stringa


itoa:   
	movl   $0, %ecx		# inizializza il contatore a 0


continua_a_dividere:

	cmpl   $10, %eax	# confronta 10 (cioe vede se sono più di un unità) con il contenuto di %eax (in eax c'è il carattere letto da tastiera in Prova.s)

	jge dividi			# salta all'etichetta dividi se %eax e' greater/equal 10

	pushl %eax			# salva nello stack il numero che a sto punto è solo un digits //non guardare qui prima devi guardare dividi!!!
	incl   %ecx			# ho fatto una push, quindi mi segno che ho fatto una push, sto commento è inutile lo so

	movl  %ecx, %ebx	# copia in %ebx il valore di %ecx 

	jmp stampa		


dividi:

	movl  $0, %edx		

	movl $10, %ebx		

	divl  %ebx	
	# divide per %ebx (10)
	# il quoziente viene messo in %eax,  #Sarebbe come fare %10 in c, dai tommi ci siamo capiti no? 
    # il resto in %edx

	pushl  %edx			# pusho l'ultmo digit nello stack

	incl   %ecx			#incremento il count di quante cose ho salvato nello stack

	jmp	continua_a_dividere 

	
stampa: # per ora ok... ma dopo :/ :-( :X !!! 

	cmpl   $0, %ebx		# ebx è il numero di cifre da stampare (ex ecx dove salvavo quante push ho fatto)

	je fine_itoa		# se sono a 0 vuol dire che nella stack c'e' qualcosa che non dovrei stampare quindi salto a fine_itoa

	popl  %eax			# prendo dalla stack l'ultimo valore pushato (pistola puntata sullo stack)

	movb  %al, tot		# sposto dalla stack alla var tot (last in first out, es: 532 l'ultima push è 5, la prima è 2 quindi stampo prima il 5 e ultimo 2)

	addb  $48, tot		# 0 è 48 in ascii quindi se aggiungo 48 al numero mi ciccia fuori il carattere ascii ez ez ez (es: 5+48=53 che è il carattere ascii di 5)
  
	decl   %ebx			# ho fatto una pop che ha annullato una push quindi decremento il count
  
	pushw %bx		#salvo il count nello stack per fare una syscall(de merda, le odio)	

	movl   $4, %eax
	movl   $1, %ebx   # easy write
	leal  tot, %ecx		
	movl   $1, %edx
	int $0x80

	popw   %bx		#mi riprendo il count dalla stack

	jmp   stampa	#e vado al prossimo digit	


fine_itoa:

	movb  $10, tot	#quando ho stampato tutto faccio \n (cioè 10 in ascii) quaesto all'evenienza si può togliere
						
	movl   $4, %eax
	movl   $1, %ebx  # scrivo in standard output \n
	leal  tot, %ecx
	mov    $1, %edx
	int $0x80

	ret  # chiudo la funzione 

