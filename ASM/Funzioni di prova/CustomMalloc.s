.section .data
    lines: .byte 0      # numero di righe leti da file = numero prodotti

.section .text
    .global malloc
    
custom_malloc:
    call ContaRighe         # chiamo la funzione che conta le righe del file
    movl $45, %eax          # syscall brk (allocazione memoria - - - mmap)
    movl lines, %ebx        # predispongo numero lines in %ebx
    sal $2, %ebx            # moltiplico per 4 (shifting aritmetico a SX di 2 bit)
                            # dimensione in byte della memoria da allocare
                            # 1 lines è composta da 4 dati da 1 byte ciascuno
                            # ( numero lines = prodotti ) * 4 = dimensione in byte
    int $0x80               # interrupt
    movl %eax, ArrayOrdini  # salvo l'indirizzo di memoria allocato in ArrayOrdini

ContaRighe:
    movl $3, %eax       # syscall READ
    movl fd, %ebx       # file descriptor in %ebx
    leal buffer, %ecx   # carico indirizzo del buffer in %ecx
    movl $1, %edx       # numero di byte da leggere
    int $0x80           # interrupt
    
    cmp $0, %eax        # se ho letto 0 byte
    jle return          # fine file -> ritorno al chiamante
    cmp $10, %eax       # se ho letto '\n' ...
    je incrementa       # incremento il contatore delle righe
    jmp ContaRighe      # ricomincio a leggere il file

incrementa:
    inc lines           # incremento il contatore delle righe
    jmp ContaRighe      # ricomincio a leggere il file

return:
    ret                 # ritorno al chiamante
