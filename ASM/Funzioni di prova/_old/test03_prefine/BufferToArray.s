.section .data

offset: .int 0

.section .bss

.section .text
    .global BufferToArray
    .type BufferToArray, @function  # Funzione che converte il contenuto della variabile 'buffer' in un array di interi

BufferToArray:

    movb $0, %dl                    # Inizializzo dl a 0 (in dl ci sarà il numero che sto costruendo dalla lettura)

loop:
    
    movb (%esi), %al                # carico il dato puntato nel buffer in al
    
    cmp $0, %al                     # Se il contenuto di al è 0, allora esco
    je end

    cmp $44, %al                    # Se il contenuto di al è ',' allora salto a 'store'
    je store

    cmp $10, %al                    # Se il contenuto di al è '\n' allora salto a 'store'
    je store

num:
    movb %dl, %bl                   # Copio dl in bl

    sal $3, %edx                    # Moltiplico ebx per 8
    sal $1, %ebx                    # Moltiplico ebx per 2
                                    # (ho moltiplicato per 10)
    addb %bl, %dl                   # salvo in dl
                                    

    sub $48, %al                    # Sottraggo 48 -> ascii to int
    addb %al, %dl                   # Aggiungo dl (che è stato moltiplicato per 10) ad al
                                    # se leggo 1 e poi leggo 2 -> 1*10 + 2 = 12

    inc %esi                        # Incremento il puntatore al buffer
    jmp loop                        # torno a loop

store:                              # Salvo il numero al puntatore corretto nell'array

    movb %dl, (%edi)                # Salvo il numero al puntatore corretto (puntato da edi) nell'array
    inc %edi                        # Incremento il puntatore all'array
    movb $0, %dl                    # Resetto dl a 0
    inc %esi                        # Incremento il puntatore al buffer
    jmp loop                        # Torno a loop

end:
    ret                             # Return


    


