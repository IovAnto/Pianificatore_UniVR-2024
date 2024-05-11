.section .data
    buffer: .ascii ""
    fd: .int 0
    counter: .int 0
    notOpen: .byte 0

.section .bss

.section .text
.global WriteOrders
.type WriteOrders, @function

WriteOrders:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %ecx   # lines
    movl 12(%ebp), %ebx  # FileOutput
    movl 16(%ebp), %esi  # ArrayOrders

    movl %ecx, counter

    movl $5, %eax
    movl $1, %ecx
    int $0x80

    cmp $0, %eax
    je nofile

    movl %eax, fd

WriteLoop:
    movl (%esi), %eax
    call itoa
    movl %eax, %edi

stampa:
    cmpb $1, notOpen
    je stampaTerminale

    movl $4, %eax
    movl fd, %ebx
    movl (%edi), %ecx
    movl $1, %edx
    int $0x80

stampaTerminale:
    movl $4, %eax
    movl $1, %ebx
    movl (%edi), %ecx
    movl $1, %edx
    int $0x80

    cmpb $0, (%edi)
    je nextElement

    addl $1, %edi
    jmp stampa

nofile:
    movl $1, notOpen
    jmp exit

nextElement:
    addl $1, %esi
    cmp counter, %esi
    jne WriteLoop

endWrite:
    cmpb $1, notOpen
    jne closeFile
    jmp exit

closeFile:
    movl $6, %eax
    movl fd, %ebx
    int $0x80

exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
