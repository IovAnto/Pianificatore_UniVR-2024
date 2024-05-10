.section .data

.section .text

    FopenWrite:
        popl %ebx
        test %ebx, %ebx 
        jz nofile

        movl $5, %eax
        movl $1, %ecx
        movl $0, %edx

        int $0x80

        cmp $0, %eax
        jle nofile

        movl %eax, fd
        xorl %eax, %eax     # pulisce eax  
        pushl %eax          # pusha il valore di eax sullo stack
        


    LoopScrittura:

        popl %ebx
        cmp lines*4, %ebx                   # confronta ebx con il numero di righe
        je UscitaLoopScrittura              # se sono uguali esce dal loop
        movl (ArrayOrdini + %ebx) , %eax
        inc %ebx                            # incrementa ebx (pseudo counter)
        pushl %ebx                          # pusha il valore di ebx sullo stack
        call itoa                           # converte il numero in stringa
        

        jmp LoopScrittura




    nofile:

    movl $4, %eax
    movl $1, %ebx
    leal Buffer, %ecx
    movl $10, %edx

    int $0x80


    UscitaLoopScrittura:

    ret
    