# Prende da file e salva in struttira dati

.section .data
    buffer: .ascii "0"
    num: .byte 0        # variabile in cui salvo il numero letto per intero in numero (non ascii)
                        # non usiamo 'INTEGER' perchè ci bastano 8 bit di memoria (0-255)
    
.section .text 


ArrayPopulator:
    # 1 rewind(file):
    movl $19, %eax       # sys_lseek (sposta puntatore a byte specifico)
    movl fd, %ebx        # file descriptor in %ebx
    xorl %ecx, %ecx     # offset
    movl $0, %edx        # SEEK byte 0 (vado al byte zero + offset di %ecx = 0)

    int 0x80            # interrupt
    
    xorl %edx, %edx     # %edx = 0
    push %edx           # pusho 0 sulla stack
    push %edx           # pusho 0 sulla stack



    # 2 read(file, buffer, 1):
    LoopLettura:

        movl $3, %eax       # sys_read (legge da file)
        movl fd, %ebx       # file descriptor in %ebx
        leal buffer, %ecx   # buffer in %ecx
        movl $1, %edx       # leggo un byte

        int 0x80            # interrupt

        cmp $0, buffer        # se ho letto 0 byte, jmp to chiusura file
        je ChiusuraFile

        cmp $44, buffer     # se il byte letto è ','
        je SalvaSuArray

        cmp $10, buffer     # se il byte letto è '\n'
        je SalvaSuArray

        jmp ElaborazioneByte




    ElaborazioneByte:           # se il byte letto non è ',' o '\n' 
    
        popl %edx               # placeholder per il numero (memorizzo infra-operazioni in stack pop push)
    
        movl buffer, %eax       # metto il byte letto in %eax
        sub $48, %eax           # sottraggo 48 per ottenere il numero corrispondente
        
                                # shift sx x3 + shift sx 1 = *10
        movl %edx, %ebx         # metto il numero in %ebx
        sal $3, %ebx            # *8
        sal $1, %edx            # *2
        addl %ebx, %edx         # sommo il numero al placeholder 

        addl %eax, %edx         # sommo il byte letto al placeholder (es: 1 * 10 + 2 = 12)

        pushl %edx              # pusho il numero elaborato sulla stack

        jmp LoopLettura 

    SalvaSuArray:

        popl %edx                           # prendo il numero dalla stack
        popl %ecx                           # counter su %ecx 
        movl %edx, (ArrayOrdini+%ecx)       # salvo il numero in array all'indirizzo puntato %ecx
        inc %ecx                            # incremento il counter
        pushl %ecx                          # pusho il counter sulla stack
        
        xorl %edx, %edx                     # azzero %edx per il prossimo numero

        pushl %edx                          # pusho il numero sulla stack
        
        jmp LoopLettura

    ChiusuraFile:

        # 3 close(file):

        popl %eax           # pulisco la stack
        popl %eax           # pulisco la stack
    

        movl $6, %eax       # sys_close (chiude file)
        movl fd, %ebx       # file descriptor in %ebx

        int 0x80            # interrupt

        ret
