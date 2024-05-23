.section .data

############################################ Menu ############################################
MsgMenu: .string "TEST MENU!!!!: Scegli un'opzione\n\0"
MenuLen: .int .-MsgMenu
#-----------------------------
MsgScelta: .string "1) Sort EDF\n2) Sort HPF\n3)Exit\n\n\0"
SceltaLen: .int .-MsgScelta
#-----------------------------
SceltaErr: .string "TEST MENU!!!!: Scelta non valida\n\0"
SceltaErrLen: .int .-SceltaErr
#-----------------------------
SortMethod: .byte 0
#-----------------------------
MsgExit: .string "Chiusura programma...\n\0"
MsgExitLen: .int .-MsgExit
##############################################################################################


.section .text 
    .global Menu
    .type Menu, @function

Menu:

    movl $4, %eax                   # syscall per la scrittura
    movl $1, %ebx                   # file descriptor 1 (stdout)
    movl $MsgMenu, %ecx             # indirizzo di memoria di Menu
    movl MenuLen, %edx              # lunghezza di Menu

    int $0x80  

Scelta:

    movl $4, %eax                   # syscall per la scrittura
    movl $1, %ebx                   # file descriptor 1 (stdout)
    movl $MsgScelta, %ecx           # indirizzo di memoria di Scelta
    movl SceltaLen, %edx            # lunghezza di Scelta

    int $0x80

    movl $3, %eax                   # syscall per la lettura
    movl $0, %ebx                   # file descriptor 0 (stdin)
    movl $SortMethod, %ecx          # indirizzo di memoria di SortMethod
    movl $1, %edx                   # lunghezza di SortMethod

    int $0x80

    xorl %eax, %eax              

    cmpb $49, SortMethod             
    je EDF                 # chiama EDF

    cmpb $50, SortMethod
    je HPF                 # chiama HPF                

    cmpb $51, SortMethod
    je Exit

SceltaNonValida:

    movl $4, %eax                   # syscall per la scrittura
    movl $1, %ebx                   # file descriptor 1 (stdout)
    movl $SceltaErr, %ecx           # indirizzo di memoria di SceltaErr
    movl SceltaErrLen, %edx        # lunghezza di SceltaErr

    int $0x80

    jmp Scelta

EDF:

    movl $2, %eax

    jmp end

HPF:

    movl $3, %eax
    

end:

    ret