.section .data

    pivot: .byte 0
    i: .int 0

.section .text
    .global partition
    .type partition, @function

partition:
    

    movl %esi, %eax

    addl %ecx, %eax #aggiungo al pointer ad array il valore massimo
    xorl %edx, %edx
    movb (%eax), %dl

    movb %dl, pivot

    

    movl %ebx, i 
    decl i

    addl $-1, %ecx #high -1

    addl $3, %ebx # punto alla priorità

loop:

    cmpl %ebx, %ecx
    jg endLoop

    leal (%esi, %ebx), %eax


    cmpb (%eax), %dl
    jg next

    incl i

swap:

    movl i, %edx
    addl $-3, %ebx

    movl (%esi, %ebx), %eax
    movl (%esi, %edx), %edx
    
    movl %eax, (%esi, %edx)
    movl %edx, (%esi, %ebx)

    addl $3, %ebx

next:

    addl $4, %ebx
    jmp loop

endLoop:
    
    incl i
    movl i, %eax
    
    movl (%esi, %eax), %ebx
    movl (%esi, %ecx), %edx
    
    movl %ebx, (%esi, %ecx)
    movl %edx, (%esi, %eax)

    ret

