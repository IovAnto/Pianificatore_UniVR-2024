.section .data

.section .text
    .global FopenWrite

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
        movl lines, %ecx    # mette in ecx il numero di righe
        sal $2, %ecx        # moltiplica il numero di righe per 4
        pushl %ecx          # pusha il valore di ecx sullo stack


    LoopScrittura:
        popl %ecx
        popl %ebx
        cmp %ecx, %ebx                   # confronta ebx con il numero di righe
        je UscitaLoopScrittura              # se sono uguali esce dal loop
        movl ArrayOrdini(%ebx) , %eax
        inc %ebx                            # incrementa ebx (pseudo counter)
        pushl %ebx                          # pusha il valore di ebx sullo stack
        pushl %ecx                          # pusha il valore di ecx sullo stack
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
    