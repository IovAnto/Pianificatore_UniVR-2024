.section .data

Buffer: .ascii ""
fd: .int 0  

.section .text

OpenFIle:

    popl %ebx               # pop 
    popl %ebx               # pop
    popl %ebx               # pop

    test %ebx, %ebx         # controllo se il puntatore è nullo
    jz error                # if 0 -> salta ad error
                            # in %ebx ho il file descriptor (tripla pop)

    movl $5, %eax           # syscall open
    movl $0, %ecx           # O_RDONLY
    movl $0, %edx           # 0

    int $0x80               # interrupt

    cmp $0, %eax            # controllo se il file descriptor è valido
    jle error               # if 0 -> salta ad error

    movl %eax, fd           # salvo il file descriptor in fd

    call CustomMalloc       # alloco spazio per l'array degli ordini (<CustomMalloc.s>)

    call ArrayPopulator     # popolo l'array degli ordini (<ArrayPopulator.s>)

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


