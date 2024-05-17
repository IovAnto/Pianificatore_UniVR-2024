.section .data

    pivot: .byte 0
    i: .int 0

.section .text
    .global partition
    .type partition, @function

partition:
    

    movl %esi, %eax

    addl %edi, %eax #aggiungo al pointer ad array il valore massimo
    xorl %edx, %edx
    movb (%eax), %dl

    movb %dl, pivot

    movl %ebx, i 
    
    addl $3, %ebx # punto alla priorità

loop:

    cmpl %edi, %ebx
    jg endLoop

    movb pivot, %dl

    cmpb %dl, (%esi, %ebx, 1) # se il valore è maggiore del pivot
    jge next


swap:

    movl i, %edx
    addl $-3, %ebx

    movl (%esi, %ebx, 1), %eax
    movl (%esi, %edx, 1), %ecx
    
    movl %eax, (%esi, %edx, 1)
    movl %ecx, (%esi, %ebx, 1)

    addl $3, %ebx
    addl $4, i

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

