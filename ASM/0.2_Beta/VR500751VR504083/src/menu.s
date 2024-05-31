.section .data

# ------------ MENU ------------
MsgMenu: .string "\nSelezionare un opzione di pianificazione:\n\n\0"
MenuLen: .int .-MsgMenu

MsgScelta: .string "1) Pianificazione EDF\t2) Pianificazione HPF\t3) Esci\n\n\0"
SceltaLen: .int .-MsgScelta

SceltaErr: .string "Scelta non valida.\t Inserire un valore compreso da 1 e 3.\n\0"
SceltaErrLen: .int .-SceltaErr


MsgExit: .string "Chiusura programma\n\0"
MsgExitLen: .int .-MsgExit

SortMethod: .byte 0

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
    movl $2, %edx                   # lunghezza di SortMethod

    int $0x80

    xorl %eax, %eax              

    cmpb $49, SortMethod             
    je EDF                 # chiama EDF

    cmpb $50, SortMethod
    je HPF                 # chiama HPF                

    cmpb $51, SortMethod
    je Exit
    # easter egg esco anche se inserisco q
    cmpb $113, SortMethod # [113 ascii = q]
    je Exit

SceltaNonValida:

    movl $4, %eax                   # syscall per la scrittura
    movl $1, %ebx                   # file descriptor 1 (stdout)
    movl $SceltaErr, %ecx           # indirizzo di memoria di SceltaErr
    movl SceltaErrLen, %edx         # lunghezza di SceltaErr

    int $0x80

    jmp Scelta

EDF:

    movl $2, %eax
    jmp end

HPF:

    movl $3, %eax
    jmp end



Exit:

    movl $4, %eax                   # syscall per la scrittura
    movl $1, %ebx                   # file descriptor 1 (stdout)
    movl $MsgExit, %ecx             # indirizzo di memoria di MsgExit
    movl MsgExitLen, %edx          # lunghezza di MsgExit

    int $0x80

    movl $0, %eax                   # muovo -1 in eax per passare errore

end:

    ret
