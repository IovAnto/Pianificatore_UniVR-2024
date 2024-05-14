.section .data

offset: .int 0

.section .bss

.section .text
    .global BufferToArray
    .type BufferToArray, @function  # Funzione che converte il contenuto della variabile 'buffer' in un array di interi

BufferToArray:

    movb $0, %dl

loop:
    
    movb (%esi), %al                # Carico il contenuto di buffer in al
    
    cmp $0, %al                     # Se il contenuto di al è 0, allora esco
    je end

    cmp $44, %al                    # Se il contenuto di al è ',' allora salto a 'store'
    je store

    cmp $10, %al                    # Se il contenuto di al è '\n' allora salto a 'store'
    je store

num:
    movb %dl, %bl                   # Copio dl in bl

    sal $3, %edx # *10              
    sal $1, %ebx # *10

    addb %bl, %dl

    sub $48, %al
    addb %al, %dl

    inc %esi
    jmp loop

store:                              # Salvo il numero al puntatore corretto nell'array

    movb %dl, (%edi)
    inc %edi
    movb $0, %dl
    inc %esi
    jmp loop

end:                                # Salvo 0 alla fine dell'array e return
    movb $0, (%edi)
    ret


    


