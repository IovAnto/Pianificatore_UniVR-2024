.section .data

# ------------------ VARIABILI GLOBALI -------------------------- #
time: .int 0
penalty: .int 0
InputFile: .int 0
OutputFile: .int 0
buffer: .space 1024
bufferLen: .int 0
ini: .byte 0
fd: .int 0
ArrayPointer: .int 0
len: .int 0                         # lunghezza array
choice: .byte 0                     # la scelta della pianificazione EDF - HPF
FlagRestart: .byte 0                     # flag mancanza output file


newInputMSG: .asciz "\n\nInserire il file di input: "
newInputMSGlen = . - newInputMSG

newOutputMSG: .asciz "\n\nInserire il file di output: "
newOutputMSGlen = . - newOutputMSG

ErrorString: .asciz "\nScelta non valida."
ErrorStringLen = . - ErrorString

Errore: .asciz "\nErrore"
ErroreLen = . - Errore

MsgMissingOutputFilePath: .asciz "\n\n\n\tAvviso: non è stato definito il file di output!\n"
MsgMissingOutputFilePathLen = . - MsgMissingOutputFilePath

MsgInputError: .asciz "\nErrore nell'apertura del file di input\n"
MsgInputErrorLen = . - MsgInputError

MsgAskForNewJob: .asciz "\n\nEseguire nuova pianificazione?\n0) Esci \t 1) Nuova pianificazione\t 2) Nuovo Input\t 3) Nuovo Output\n\n"
MsgAskForNewJobLen = . - MsgAskForNewJob


MsgExitProgram: .asciz "\n\nChiusura programma.\n"
MsgExitProgramLen = . - MsgExitProgram



.section .text
    .globl _start
# -------------------- INPUT & PREPARAZIONE MEMORIA -------------------------- #
_start:                             # inizio del programma   
    
    popl %eax 
    popl %ebx 

    cmpl $1, %eax
    je CallAskInput

    cmpl $3, %eax
    jge takeOutput

    popl InputFile
    jmp OpenInputFile

takeOutput:

    popl InputFile
    popl OutputFile
    # ----- Apro il file ----- #

OpenInputFile:

    movl $5, %eax                # Open file
    movl InputFile, %ebx
    movl $0, %ecx                # Read only
    int $0x80

    cmpl $0, %eax                # check stdin
    jl CallAskInput
    
    movl %eax, fd

ReadFile:                           # leggo il file e salvo il contenuto in buffer

    movl $3, %eax                   # Read file
    movl fd, %ebx
    movl $buffer, %ecx              # Indirizzo di memoria in cui salvare il contenuto del file
    movl $1024, %edx                # Lunghezza del file
    int $0x80

    cmp $0, %eax                     # Verifico se va in errore [se non ho letto nulla]
    jl CallAskInput

    movl $0 , (%ecx, %eax, 1)       # metto il terminatore di stringa (0) alla fine del buffer

    jmp FileClose                   # se tutto va bene chiude il file

CallAskInput:

    call AskInput

    # mi ritorna 0 in %EAX se voglio uscire, il file descriptor altrimenti..
    cmpl $0, %eax
    je Exit      

    movl %eax, fd
    jmp ReadFile
    
FileClose:                          # chiudo il file, non serve più e tutto il suo contenuto è in buffer                        

    movl $6, %eax                # Close file
    movl fd, %ebx
    int $0x80

    movl $buffer, %esi              # sposto puntatore all'inizio di buffer in esi
    
SpaceLoop:                          # conta il numero di rientri '\n' in buffer
        
    cmpb $0, (%esi)                 # se trova '\0' esce dal ciclo
    je malloc                       # salto a malloc
    
    cmpb $10, (%esi)                # incremento len se trova '\n'
    je lenPlus  
    
    incl %esi                       # incrementa puntatore (per eseguire ciclo su buffer)
    jmp SpaceLoop   
    
lenPlus:                            # incrementa len e puntatore
    incl len                        # e torna a spaceLoop
    incl %esi   
    jmp SpaceLoop   
    
malloc:                             # alloca spazio per l'array

    movl len, %eax
    sal $2, %eax                    # moltiplico per 4 (4byte per int) (perchè ho 4byte ogni riga/prodotto)     
    movl %eax, len

    movl $45, %eax                  # syscall per la malloc
    xorl %ebx, %ebx                 # alloco inizialmente 0byte
    int $0x80   
    
    movl %eax, %esi                 # salvo l'indirizzo di memoria in esi (zona di memoria puntata dalla malloc)
    
    addl len, %eax                  # aggiungo len a %eax (buffer allocazione)
                                                              
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


# --------------------- SORTING ------------------------------ #
PreSort:         

                   # preparo i registri per la chiamata a insertionSort
    call Menu                       # chiama la funzione menu   
    # in EAX ho ' base' che definisce la scelta del sorting

    cmpl $0, %eax                   # check stdin
    je exitWithError                # se non c'è niente esce con errore 

    cmpb %al, choice
    je PrintVideo

    movb $0, time
    movl $0, penalty
    movl $0, bufferLen

    movb %al, choice                # salva la scelta in choice

    pushl %eax                      # pusha la base   
    pushl ArrayPointer              # pusha l'indirizzo di ArrayPointer
    pushl len                       # push len
    
FirstSort:                          # chiama la funzione insertionSort
    call insertionSort              # sorting sulla colonna definita da base (EAX)

SecondSort:                         # chiama la funzione EqualSort che controlla se ci sono elementi uguali e aggiorna ordine
    call EqualSort                  # base -> HPF sort per deadline
                                    #      -> EDF sort per priorità
# --------------------- BUFFERING ------------------------------- #
ArrayToBuffer:

    popl %eax
    popl %eax

    xorl %ecx, %ecx
    movl $buffer, %edi
    xorl %eax, %eax
    movb choice, %al

    call intestazione

    movl %ecx, bufferLen

    popl fd # uso fd per salvare la base (EDF oppure HPF)

    xorl %ecx, %ecx
    xorl %eax, %eax
    xorl %edx, %edx
    

    cmpl $2, fd
    je EDF

    addl len, %ecx
    subl $4, %ecx
HPF:    

    cmpl $0, %ecx 
    jl DatiFinali

    jmp Buffering

EDF:

    cmpl %ecx, len
    jle DatiFinali



Buffering:

    movl ArrayPointer, %esi
    movl (%esi, %ecx, 1), %ebx

    xorl %eax, %eax

    movb %bl, %al

    pushl %ebx #oggetto
    pushl %ecx #Posizione
    xorl %ebx, %ebx
    movb time, %bl #salvo il tempo
    movl bufferLen, %ecx
    movl $buffer, %esi

    call btoa

    addl %ecx, bufferLen
    popl %ecx # Riprendo la posizione
    popl %ebx # Riprendo l'oggetto

    addb %bh, time #aggiungo il tempo
    ror $16, %ebx # scambio id e durata con Priorita e scadenza bh/bl


    cmpb %bl, time
    jg CalcoloPentalita

    cmpl $2, fd
    je Add4

    subl $4, %ecx
    jmp HPF

Add4:
  
    addl $4 ,%ecx # Incremento la posizione

    jmp EDF

CalcoloPentalita:

    movb time, %al
    subb %bl, %al
    movb %bh, %bl
    mulb %bl

    addb %al, penalty

    cmpl $2, fd  #da ricordare che l'fd e' la choice
    je Add4

    subl $4, %ecx
    jmp HPF

DatiFinali:

    movl bufferLen, %edx    # dove stampare
    movl $buffer, %edi
    xorl %eax, %eax       # metto nei valori le var che mi servono
    movb time, %al
    movl penalty, %ebx    #cosa stampare

    call finalData    # qui errore fatto io 

    subl $buffer, %edi
    movl %edi, bufferLen

# --------------------- OUTPUT ------------------------------- #
PrintVideo:

    movl $4, %eax                   # Write file
    movl $1, %ebx                   # File descriptor 1 (stdout)
    movl $buffer, %ecx              # Indirizzo della stringa da stampare
    movl bufferLen, %edx            # Lunghezza della stringa
    int $0x80


OpenOutputFile:                 # Apro il file di output

    # Apro il file di output
    cmpl $0, OutputFile             # check se OutputFile è stato definito
    je NoOutputFileMSG              # se non è stato definito salta la scrittura su file
    
    movl $5, %eax                   # Open file
    movl OutputFile, %ebx           # path
    movl $65, %ecx                  # Write or create
    movl $0x1A4, %edx               # RWX

    int $0x80

    cmpl $0, %eax                   # check se OutputFile è stato definito
    jle NoOutputFileMSG              # se non è stato definito salta la scrittura su file

    movl %eax, fd
    
Truncate:                      # Tronca il file di output

    movl $93, %eax                  # Truncate file
    movl fd, %ebx
    movl $0, %ecx
    int $0x80

WriteOutputFile:                # Scrivo su file
    
    movl $4, %eax                   # Write file
    movl fd, %ebx                   # File descriptor 1 (stdout)
    movl $buffer, %ecx              # Indirizzo della stringa da stampare
    incl %ecx
    movl bufferLen, %edx            # Lunghezza della stringa

    int $0x80

closeFile:                      # chiudo il file di output

    movl $6, %eax                   # Close file
    movl fd, %ebx
    int $0x80

    jmp AskForNewJob

NoOutputFileMSG:
    # Stampo un avviso di errore:
    movl $4, %eax                           # Write file
    movl $1, %ebx                           # File descriptor 2 (stderr)
    movl $MsgMissingOutputFilePath, %ecx       # Indirizzo della stringa da stampare
    movl $MsgMissingOutputFilePathLen, %edx    # Lunghezza della stringa
    int $0x80

AskForNewJob:

    movl $4, %eax                   # Write file
    movl $1, %ebx                   # File descriptor 1 (stdout)
    movl $MsgAskForNewJob, %ecx     # Indirizzo della stringa da stampare
    movl $MsgAskForNewJobLen, %edx  # Lunghezza della stringa
    int $0x80

    movl $3, %eax                   # Read file
    movl $0, %ebx                   # File descriptor 0 (stdin)
    movl $ini, %ecx              # Indirizzo della stringa da leggere
    movl $2, %edx                   # Lunghezza della stringa
    int $0x80
                                    # comparo ascii 0 (48) con il valore inserito
    cmpb $48, ini                # se buffer è uguale a 0
    je Exit                         # esce dal programma

    cmpb $49, ini                     # se buffer è uguale a 1
    je PrepareRestart                      # esegue nuova pianificazione

    cmpb $50, ini                   # se la scelta e' 2 scelta = richiesta input
    je newInput

    cmpb $51, ini                   # se la scelta e' 3 scelta = richiesta output
    je newOutput


    movl $4, %eax              
    movl $1, %ebx                
    movl $ErrorString, %ecx     
    movl $ErrorStringLen, %edx   
    int $0x80

    jmp AskForNewJob

newInput:

    movl $4, %eax                   # Write file
    movl $1, %ebx                   # File descriptor 1 (stdout)
    movl $newInputMSG, %ecx         # Indirizzo della stringa da stampare
    movl $newInputMSGlen, %edx      # Lunghezza della stringa
    int $0x80

    call TextIn

    movl %eax, InputFile
    movb $1, FlagRestart

    jmp AskForNewJob

newOutput:

    movl $4, %eax                   # Write file
    movl $1, %ebx                   # File descriptor 1 (stdout)
    movl $newOutputMSG, %ecx        # Indirizzo della stringa da stampare
    movl $newOutputMSGlen, %edx     # Lunghezza della stringa
    int $0x80

    call TextIn

    movl %eax, OutputFile

    jmp AskForNewJob

PrepareRestart:

    cmpb $1, FlagRestart
    jne PreSort

    movl $0, choice
    movl $0, len
    movl $0, bufferLen
    movl $0, time
    movl $0, penalty
    movl $0, ArrayPointer
    movb $0, ini
    movb $0, FlagRestart

    jmp OpenInputFile
# ------------------ Uscite ed errori -------------------------- #
Exit:                       # uscita con successo      

    #stampo un messaggio di uscita
    movl $4, %eax                   # Write file
    movl $1, %ebx                   # File descriptor 1 (stdout)
    movl $MsgExitProgram, %ecx      # Indirizzo della stringa da stampare
    movl $MsgExitProgramLen, %edx   # Lunghezza della stringa
    int $0x80


    movl $1, %eax                   # Exit with 0
    movl $0, %ebx
    int $0x80

Error:
    # Stampo un avviso di errore:
    movl $4, %eax                   # Write file
    movl $2, %ebx                   # File descriptor 2 (stderr)
    movl $Errore, %ecx         # Indirizzo della stringa da stampare
    movl $ErroreLen, %edx      # Lunghezza della stringa
    int $0x80

exitWithError:              # uscita con errore
    movl $1, %eax           # Exit with 1 [error]
    movl $1, %ebx
    int $0x80
