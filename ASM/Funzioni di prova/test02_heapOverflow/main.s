.section .data
    # messaggi di errore ------
    errorMSG: .ascii "Errore apertura file\n"
    errorMSG_len: .int . - errorMSG
    FileOrders: .int 0
    FileOutput: .int 0

    fd: .int 0
    lines: .int 0

.section .bss
    ArrayOrdini:


buffer: .string ""


.section .text
.global _start 

_start:
    popl %ebx
    popl %ebx
    popl FileOrders
    popl FileOutput

    movl $5, %eax # chiamata Open
    movl FileOrders, %ebx
    movl $0, %ecx

    int $0x80

    cmp $0, %eax
    jl error

    movl %eax, fd

LoopReadLenght:
    movl $3, %eax # chiamata Read
    movl fd, %ebx
    movl $buffer, %ecx
    movl $1, %edx

    int $0x80

    cmp $0, %eax
    jl error
    je Malloc     

    movb buffer, %al

    cmpb $10, %al
    je plusLine

    jmp LoopReadLenght

plusLine:
    incb lines
    jmp LoopReadLenght

Malloc:

    movl $45, %eax
    xorl %ebx, %ebx
    
    int $0x80
    
    movl lines, %ebx # passo il numero di linee 
    sal $2, %ebx # *4 byte di ogni ordine

    movl %ebx, lines

    movl $45, %eax
    # in ebx c'e lines * 4

    int $0x80

    cmpl $0, %eax
    jl error

    sub lines , %eax
    
    movl %eax, ArrayOrdini

    movl $6 , %eax # chiamata Close
    movl fd, %ebx

    int $0x80

Orders:


    pushl ArrayOrdini
    pushl FileOrders

    call ReadOrders

    pushl ArrayOrdini
    pushl FileOutput
    pushl lines

    call WriteOrders

error:
    movl $4, %eax # chiamata Write
    movl $1, %ebx
    leal errorMSG, %ecx
    movl $errorMSG_len, %edx

    int $0x80

exit:
    movl $1, %eax # chiamata Exit
    movl $0, %ebx

    int $0x80
