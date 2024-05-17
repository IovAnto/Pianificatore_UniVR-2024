.section .data

    pivot: .byte 0          # pivot
    i: .int 0               # i

.section .text
    .global partition
    .type partition, @function

partition:
    

# esi = pointer
# ebx = 0
# edi = len
# edi = len - 1

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


     movl i, %edx                    # salvo il valore di i in edx   
     addl $-3, %ebx                  # decremento ebx di 3 (priorità / colonna 4 del csv)
     movl (%esi, %ebx, 1), %eax      # metto in arr[ebx] il valore di eax
     movl (%esi, %edx, 1), %ecx      # metto in arr[edx] il valore di ecx
     movl %eax, (%esi, %edx, 1)      # metto in arr[edx] il valore di eax
     movl %ecx, (%esi, %ebx, 1)      # metto in arr[ebx] il valore di ecx
     addl $3, %ebx
     addl $4, i                     # return (i + 1)

next:

    addl $4, %ebx                   # incremento ebx di 4
    jmp loop                        # ritorno al loop

endLoop:
    
    addl $4, i                      # return (i + 1)
    movl i, %eax                    # metto in eax il valore di i
    addl $-3, %edi                  # decremento edi di 3
    
    movl (%esi, %eax, 1), %ebx      # metto in arr[eax] il valore di ebx
    movl (%esi, %edi, 1), %edx      # metto in arr[edi] il valore di edx
    
    movl %ebx, (%esi, %edi, 1)      # metto in arr[edi] il valore di ebx
    movl %edx, (%esi, %eax, 1)      # metto in arr[eax] il valore di edx

    ret

