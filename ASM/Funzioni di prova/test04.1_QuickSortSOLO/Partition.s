.section .data

    pivot: .byte 0          # pivot
    i: .int 0               # i

.section .text
    .global partition
    .type partition, @function

partition:
    

    movl %esi, %eax         # puntatore all'array

    addl %edi, %eax         # aggiungo al pointer ad array il valore massimo
    xorl %edx, %edx         # pulisco edx
    movb (%eax), %dl        # prendo il byte del valore massimo (da indirizzo di eax)

    movb %dl, pivot         # salvo il pivot 

    movl %ebx, i            # salvo il valore di ebx in i
    
    addl $3, %ebx           # punto alla priorità

loop:

    cmpl %edi, %ebx         # se ho finito (caso base)
    jg endLoop              # esco

    movb pivot, %dl         # carico il pivot in dl

    cmpb %dl, (%esi, %ebx, 1)   # se il valore è maggiore del pivot
    jge next                    # salto al prossimo


swap:


    # swap(&arr[i + 1], &arr[high]) -> asm: array[i+4] <-> array[high]
    # ASM: swap([i + 4] , arr[%edi])
    


    # movl i, %edx                    # salvo il valore di i in edx   
    # addl $-3, %ebx                  # decremento ebx di 3 (priorità / colonna 4 del csv)

    # movl (%esi, %ebx, 1), %eax      # metto in eax in valore puntato da esi + ebx
    # movl (%esi, %edx, 1), %ecx
   #  
    # movl %eax, (%esi, %edx, 1)
    # movl %ecx, (%esi, %ebx, 1)

    # addl $3, %ebx
    # addl $4, i                     # return (i + 1)

next:

    addl $4, %ebx
    jmp loop

endLoop:
    
    addl $4, i
    movl i, %eax
    addl $-3, %edi
    
    movl (%esi, %eax, 1), %ebx
    movl (%esi, %edi, 1), %edx
    
    movl %ebx, (%esi, %edi, 1)
    movl %edx, (%esi, %eax, 1)

    ret

