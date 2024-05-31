.section .data

# ------------------ VARIABILI GLOBALI -------------------------- #
InputFile: .int 0
OutputFile: .int 0
buffer: .space 1024
bufferLen: .int 0
fd: .int 0
ArrayPointer: .int 0
len: .int 0                         # lunghezza array
choice: .byte 0                     # la scelta della pianificazione EDF - HPF



ErrorString: .asciz "\n\tErrore intero\n"
ErrorStringLen = . - ErrorString

MsgMissingOutputFilePath: .asciz "Avviso: non è stato definito il file di output.\n\n\n"
MsgMissingOutputFilePathLen = . - MsgMissingOutputFilePath


MsgAskForNewJob: .asciz "Vuoi eseguire una nuova pianificazione?\n0) Per terminare il programma\n1) Per eseguire una nuova pianificazione\n\n"
MsgAskForNewJobLen = . - MsgAskForNewJob




.section .text
    .globl _start
# -------------------- INPUT & PREPARAZIONE MEMORIA -------------------------- #

_start:                             # inizio del programma   
    
    popl %eax 
    popl %eax 
    popl InputFile
    popl OutputFile


OpenInputFile:

    movl $5, %eax                # Open file
    movl InputFile, %ebx
    movl $0, %ecx                # Read only
    int $0x80

    cmpl $0, %eax                # check stdin
    jl CallAskInput
    
    movl %eax, fd
    jmp ReadFile

ReadFile:                           # leggo il file e salvo il contenuto in buffer
    movl $3, %eax                   # Read file
    movl fd, %ebx
    movl $buffer, %ecx              # Indirizzo di memoria in cui salvare il contenuto del file
    movl $1024, %edx                # Lunghezza del file
    int $0x80

    cmp $0, %eax                     # Verifico se va in errore [se non ho letto nulla]
    jl CallAskInput

    jmp FileClose                   # se tutto va bene chiude il file

CallAskInput:

    call AskInput

    # mi ritorna 0 in %EAX se voglio uscire, il file descriptor altrimenti..
    cmpl $0, %eax               # check stdin
    je Exit                     # se non c'è niente esce

    movl %eax, fd
    jmp ReadFile

FileClose:                          # chiudo il file, non serve più e tutto il suo contenuto è in buffer                        

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

# --------------------- SORTING ------------------------------ #

PreSort:                            # preparo i registri per la chiamata a insertionSort
    call Menu                       # chiama la funzione menu   
    # in EAX ho ' base' che definisce la scelta del sorting

    cmpl $0, %eax                   # check stdin
    je exitWithError                # se non c'è niente esce con errore 

    movb %al, choice                # salva la scelta in choice

    pushl %eax                      # pusha la base   
    pushl ArrayPointer              # pusha l'indirizzo di ArrayPointer
    movl len, %eax                  # muove len in eax    
    sal $2, %eax                    # moltiplica len per 4 (4byte per int)                     
    movl %eax, len                  # rimette len*4 in len
    pushl len                       # push len
    
FirstSort:                          # chiama la funzione insertionSort
    call insertionSort              # sorting sulla colonna definita da base (EAX)

SecondSort:                         # chiama la funzione EqualSort che controlla se ci sono elementi uguali e aggiorna ordine
    call EqualSort                  # base -> HPF sort per deadline
                                    #      -> EDF sort per priorità

# --------------------- OUTPUT ------------------------------- #


CallArrayToBuffer: 

# preparo i registri per la chiamata ad Array To Buffer: 


    movl choice, %eax                 # sposto choice in eax
    movl (ArrayPointer), %esi         # sposto l'indirizzo di ArrayPointer in esi
    movl len, %edi                      # sposto len in edi
    movl $buffer, %ecx              # sposto l'indirizzo di buffer in ecx
    call ArrayToBuffer              # chiama la funzione ArrayToBuffer



# Dopo ArrayToBuffer ho buffer. ovvero una parte di memoria in cui ho ciò che va scritto su file e stampato a video in ascii...

    PrintVideo:
    movl $4, %eax                   # Write file
    movl $1, %ebx                   # File descriptor 1 (stdout)
    movl $buffer, %ecx              # Indirizzo della stringa da stampare
    movl bufferLen, %edx            # Lunghezza della stringa
    int $0x80

    cmpl $0, OutputFile             # check se OutputFile è stato definito
    je AskForNewJob                 # se non è stato definito salta la scrittura su file

OpenOutputFile:                 # Apro il file di output

    # Apro il file di output
    movl $5, %eax                   # Open file
    movl OutputFile, %ebx           # path
    movl $65, %ecx                  # Write or create
    movl $0x1A4, %edx               # RWX

    int $0x80

    cmpl $0, %eax             # check se OutputFile è stato definito
    je NoOutputFileMSG              # se non è stato definito salta la scrittura su file


    movl %eax, fd
    

WriteOutputFile:                # Scrivo su file
    

    movl $4, %eax                   # Write file
    movl fd, %ebx                   # File descriptor 1 (stdout)
    movl $buffer, %ecx              # Indirizzo della stringa da stampare
    # movl bufferLen, %edx            # Lunghezza della stringa

# SCRIBVO SU FILE. . . . . .. . . .

# QUA SI SCRIVE SU FILE1!!!!1!1!11

# , , , , , , , 

NoOutputFileMSG:
    # Stampo un avviso di errore:
    movl $4, %eax                           # Write file
    movl $2, %ebx                           # File descriptor 2 (stderr)
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
    movl $buffer, %ecx              # Indirizzo della stringa da leggere
    movl $2, %edx                   # Lunghezza della stringa
    int $0x80
                                    # comparo ascii 0 (48) con il valore inserito
    cmpb $48, buffer                # se buffer è uguale a 0
    je Exit                         # esce dal programma

    cmpl $1, buffer                 # se buffer è uguale a 1
    je PrepareForBackMenu

PrepareForBackMenu:

    jmp PreSort                     # ritorna a PreSort (Menu)

# ------------------ Uscite ed errori -------------------------- #

Exit:                       # uscita con successo        
    movl $1, %eax                   # Exit with 0
    movl $0, %ebx
    int $0x80

exitWithError:              # uscita con errore
    movl $1, %eax           # Exit with 1 [error]
    movl $1, %ebx
    int $0x80


Error:                            
    # Stampo un avviso di errore:
    movl $4, %eax                   # Write file
    movl $2, %ebx                   # File descriptor 2 (stderr)
    movl $ErrorString, %ecx         # Indirizzo della stringa da stampare
    movl $ErrorStringLen, %edx      # Lunghezza della stringa
    int $0x80

   jmp exitWithError
