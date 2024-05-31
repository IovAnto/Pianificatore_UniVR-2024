.section .data

offset: .int 0

.section .bss

.section .text
    .global BufferToArray
    .type BufferToArray, @function

BufferToArray:

    movb $0, %dl        # dl = 0 

loop:
    movb (%esi), %al    # al = *esi
    
    cmp $0, %al         # se al == 0
    je end

    cmp $44, %al        # se al == ','
    je store            # salva

    cmp $10, %al        # se al == '\n'
    je store            # salva

num:
    movb %dl, %bl       

    sal $3, %edx # *10  
    sal $1, %ebx # *10

    addb %bl, %dl           # dl = dl*10 + bl

    sub $48, %al            # al = al - 48
    addb %al, %dl           # dl = dl + al

    inc %esi                # esi++
    jmp loop                # loop back

store:                      

    movb %dl, (%edi)        # *edi = dl
    inc %edi                # edi++ (target)
    movb $0, %dl            # dl = 0
    inc %esi                # esi++
    jmp loop                # loop back

end:

    ret


    


