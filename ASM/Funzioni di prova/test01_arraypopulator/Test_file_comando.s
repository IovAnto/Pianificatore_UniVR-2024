.section .data

Buffer: .ascii ""
fd: .int 0  

.section .text
    .globl _start

OpenFIle:

    popl %ebx
    popl %ebx
    popl %ebx

    test %ebx, %ebx 
    jz error

    movl $5, %eax
    movl $0, %ecx
    movl $0, %edx

    int $0x80

    cmp $0, %eax
    jle error

    movl %eax, fd

    call malloc

    call ArrayOrdini

    movl $6, %eax
    movl fd, %ebx

    int $0x80

    popl %ebx

    test %ebx, %ebx 
    jz nofile

    movl $5, %eax
    movl $1, %ecx
    movl $0, %edx

    int $0x80

    cmp $0, %eax
    jle error

    movl %eax, fd

    movl $4, %eax
    movl fd, %ebx
    leal Buffer, %ecx
    movl $100, %edx

    int $0x80

nofile:

    movl $4, %eax
    movl $1, %ebx
    leal Buffer, %ecx
    movl $10, %edx

    int $0x80

error:

    movl $1, %eax
    movl $0, %ebx

    int $0x80


