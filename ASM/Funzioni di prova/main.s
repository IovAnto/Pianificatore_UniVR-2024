.section .data

InputFile: .int 0
OutputFile: .int 0
buffer: .space 1024
fd: .int 0
len: .int 0
ArrayPointer: .int 0
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
    .globl _start

_start:
    
    popl %eax 
    popl %eax 
    popl InputFile
    popl OutputFile

    movl $5, %eax                # Open file
    movl InputFile, %ebx
    movl $0, %ecx                # Read only
    
    int $0x80

    cmp $0, %eax                 # Verifico se va in errore
    jl Error

    movl %eax, fd   

    movl $3, %eax                # Read file
    movl fd, %ebx
    movl $buffer, %ecx           # da provare con movl $buffer
    movl $1024, %edx

    int $0x80

    cmp $0, %eax                 # Verifico se va in errore
    jl Error

FileClose: 

    movl $6, %eax                # Close file
    movl fd, %ebx

    int $0x80


    movl $buffer, %esi              # sposto puntatore all'inizio di buffer in esi
    
SpaceLoop:                          # conta quante volte c'è '\n' in buffer
        
    cmpb $0, (%esi)                 # se trova '\0' esce dal ciclo
    je malloc                       # e va a malloc
    
    cmpb $10, (%esi)                # se trova '\n' incrementa len
    je lenPlus  
    
    incl %esi                       # incrementa puntatore (per ciclare su buffer)
    jmp SpaceLoop   
    
lenPlus:                            # incrementa len e puntatore
    incl len                        # e torna a spaceLoop
    incl %esi   
    jmp SpaceLoop   
    
malloc:                             # alloca spazio per l'array
    
    movl $45, %eax                  # syscall per la malloc
    xorl %ebx, %ebx                 # alloco inizialmente 0byte
    int $0x80   
    
    movl %eax, %esi                 # salvo l'indirizzo di memoria in esi (zona di memoria puntata dalla malloc)
    
    addl len, %eax                  # aggiungo len a %eax (buffer allocazione)
    sal $2, %eax                    # moltiplico per 4 (4byte per int) (perchè ho 4byte ogni riga/prodotto)
                                    # salvo il risultato in len (len non era ancora moltiplicato * 4)
    
    movl %eax, %ebx                 # salvo il risultato in ebx (lunghezza totale da allocare)
    movl $45, %eax                  # syscall per la malloc
    int $0x80                       # alloco la memoria - interrupt
    
    cmpl %esi, %eax                 # compara nuovo puntatore col vecchio (se sono uguali non ha allocato)
    jle Error                       # esi è l'indirizzo di memoria puntato dalla malloc (inizio array) mentre in eax c'è l'indirizzo di fine array
    
    movl %esi, ArrayPointer         # se tutto funziona salvo l'indirizzo di memoria in ArrayPointer cosi lo posso usare in BufferToArray
        
PrepArr:                            # preparo i registri per la chiamata a BufferToArray
    
    movl $buffer, %esi              # muove l'indirizzo di buffer in esi (source)
    movl ArrayPointer, %edi        # muove l'indirizzo di ArrayPointer in edi (target)
    
    call BufferToArray              # chiama la funzione BufferToArray

Menu:

    movl $4, %eax                   # syscall per la scrittura
    movl $1, %ebx                   # file descriptor 1 (stdout)
    movl $MsgMenu, %ecx                # indirizzo di memoria di Menu
    movl MenuLen, %edx             # lunghezza di Menu

    int $0x80  

Scelta:

    movl $4, %eax                   # syscall per la scrittura
    movl $1, %ebx                   # file descriptor 1 (stdout)
    movl $MsgScelta, %ecx              # indirizzo di memoria di Scelta
    movl SceltaLen, %edx           # lunghezza di Scelta

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

    jmp PrepToORder

HPF:

    movl $3, %eax
    
PrepToORder:                        # preparo i registri per la chiamata a ArraySort
    
    pushl %eax
    pushl ArrayPointer             # pusha l'indirizzo di ArrayPointer
    movl len, %eax
    sal $2, %eax                    # moltiplica len per 4 (4byte per int)                     
    movl %eax, len
    pushl len 
    


    call insertionSort              # chiama la funzione ArraySort

#------------------------------------------------------------------------- corretto fin qui


Prova:                              # scrittura file <prova>

    cmpl $0, OutputFile 
    je print    

    movl $5, %eax                   # Open file
    movl OutputFile, %ebx   
    movl $65, %ecx                  # Write or create
    movl $0x1A4, %edx               # 0644

    int $0x80

    cmp $0, %eax # Verifico se va in errore
    jl Error

    movl %eax, fd

print:

    xorl %eax, %eax
    movb ArrayPointer, %al

    call btoa

    movl %eax, %ecx

    movl $4, %eax # Write file
    movl $1, %ebx
    movl $20, %edx

    int $0x80

    cmp $0, %eax # Verifico se va in errore
    jl Error
    

    movl $6, %eax # Close file
    movl fd, %ebx

    int $0x80
    
Exit:

    movl $4, %eax                   # syscall per la scrittura
    movl $1, %ebx                   # file descriptor 1 (stdout)
    movl $MsgExit, %ecx             # indirizzo di memoria di MsgExit
    movl MsgExitLen, %edx          # lunghezza di MsgExit

    int $0x80


Error:

    movl $1, %eax # Exit
    movl $0, %ebx
    int $0x80
