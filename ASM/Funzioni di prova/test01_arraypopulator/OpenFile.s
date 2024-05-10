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

    int $0x80               # interrupt

    ret                    # ritorno

    


error:
    
    # ma mettiamoci na stampina

    movl $1, %eax
    movl $0, %ebx


    int $0x80


