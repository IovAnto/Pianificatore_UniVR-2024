.section .data

penality: .int 0
time: .byte 0
InputFile: .int 0
OutputFile: .int 0
buffer: .space 1024
bufferLen: .int 0
fd: .int 0
len: .int 0
ArrayPointer: .int 0
choice: .byte 0 # la scelta della pianificazione EDF - HPF

MsgInputError: .string "Errore nell'apertura del file di input\n\0"
MsgInputErrorLen = . - MsgInputError

ErrorString: .string "Errore interno\n\n\0"
ErrorStringLen = . - ErrorString

MsgErrorOutputFile: .string "Errore nell'apertura del file di output\n\0"
MsgErrorOutputFileLen = . - MsgErrorOutputFile

MsgMissingOutputFilePath: .string "Avviso: non è stato definito il file di output.\n\0"
MsgMissingOutputFilePathLen = . - MsgMissingOutputFilePath

MsgMissingInputFilePath: .string "Errore: non è stato definito il file di input\n\0"
MsgMissingInputFilePathLen = . - MsgMissingInputFilePath


MsgAskForNewJob: .string "Vuoi eseguire una nuova pianificazione?\n0) Per terminare il programma\n1) Per eseguire una nuova pianificazione\n\n\n\0"
MsgAskForNewJobLen = . - MsgAskForNewJob




.section .text
    .globl _start
# -------------------- INPUT & PREPARAZIONE MEMORIA -------------------------- #

_start:                             # inizio del programma   
    
    popl %eax 
    popl %eax 
    popl InputFile
    popl OutputFile
                        # ----- Apro il file ----- #
    movl $5, %eax                # Open file
    movl InputFile, %ebx
    movl $0, %ecx                # Read only
    
    int $0x80

    cmp $0, %eax                 # Verifico se va in errore
    jl ErrorInputFile

    movl %eax, fd

                        # --- Leggo il file -> buffer --- #
    movl $3, %eax                # Read file
    movl fd, %ebx
    movl $buffer, %ecx           # da provare con movl $buffer
    movl $1024, %edx

    int $0x80

    cmp $0, %eax                 # Verifico se va in errore [se non ho letto nulla]
    jl ErrorInputFile

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

CheckOutputFile:

    cmpl $0, OutputFile             # check se OutputFile è stato definito
    je MissingOutputFilePath        # se non è stato definito salta la scrittura su file

    jmp ElaborazioneOut           # se OutputFile è stato definito va a ElaborazioneOut

MissingOutputFilePath:
    # Stampo un avviso di errore:
    movl $4, %eax                           # Write file
    movl $2, %ebx                           # File descriptor 2 (stderr)
    movl $MsgMissingOutputFilePath, %ecx       # Indirizzo della stringa da stampare
    movl $MsgMissingOutputFilePathLen, %edx    # Lunghezza della stringa
    int $0x80



    movl ArrayPointer, %esi         # sposto l'indirizzo di ArrayPointer in esi
    movl len, %edi                  # sposto len in edi
    movl choice, %eax                   # sposto choice in eax
    jmp CallArrayToBuffer               # Salto ad ArrayToBuffer e bypasso la scrittura su file


ElaborazioneOut:
    cmpl $0, OutputFile             # check se OutputFile è stato definito
    je ErrorOutputFile              # se non è stato definito salta la scrittura su file


    movl $5, %eax                   # Open file
    movl OutputFile, %ebx           # path
    movl $65, %ecx                  # Write or create
    movl $0x1A4, %edx               # RWX

    int $0x80

    cmp $0, %eax                     # Verifico se va in errore
    jl ErrorOutputFile

    movl %eax, fd

    # preparazione alla chiamata che sposta i dati da ArrayPointer a buffer
    # mi serve :
    # - ArrayPointer
    # - len dell'array
    # - buffer pointer
    # la scelta del sorting (base) da mettere in eax



    movl choice, %eax                 # sposto choice in eax
    movl ArrayPointer, %esi         # sposto l'indirizzo di ArrayPointer in esi
    movl len, %edi                  # sposto len in edi
    movl $buffer, %ecx              # sposto l'indirizzo di buffer in ecx
    jmp CallArrayToBuffer              # chiama la funzione ArrayToBuffer


CallArrayToBuffer: 
    call ArrayToBuffer              # chiama la funzione ArrayToBuffer

































FineElaborazione:                    # chiama la funzione FineElaborzione
# stampo a video il buffer fino a buffer len
    movl $4, %eax                   # Write file
    movl $1, %ebx                   # File descriptor 1 (stdout)
    movl $buffer, %ecx              # Indirizzo della stringa da stampare
    movl bufferLen, %edx            # Lunghezza della stringa
    int $0x80


# chiedo all'utente se vuole terminare il programma o se vuole eseguire una nuova pianificazione:
# 0 -> termina il programma
# 1 -> esegue una nuova pianificazione

    movl $4, %eax                   # Write file
    movl $1, %ebx                   # File descriptor 1 (stdout)
    movl $MsgAskForNewJob, %ecx     # Indirizzo della stringa da stampare
    movl $MsgAskForNewJobLen, %edx  # Lunghezza della stringa
    int $0x80

    movl $3, %eax                   # Read file
    movl $0, %ebx                   # File descriptor 0 (stdin)
    movl $buffer, %ecx              # Indirizzo della stringa da leggere
    movl $1, %edx                   # Lunghezza della stringa
    int $0x80
                                    # comparo ascii 0 (48) con il valore inserito
    cmpb $48, buffer                # se buffer è uguale a 0
    je Exit                         # esce dal programma

    cmpl $1, buffer                 # se buffer è uguale a 1
    je PrepareForBackMenu

PrepareForBackMenu:

    xorl %eax, %eax                 # pulisce eax
    xorl %ebx, %ebx                 # pulisce ebx
    xorl %ecx, %ecx                 # pulisce ecx
    xorl %edx, %edx                 # pulisce edx

    jmp PreSort                     # ritorna a PreSort (Menu)

# ------------------ Uscite ed errori -------------------------- #

Exit:                       # uscita con successo        
    movl $1, %eax                   # Exit with 0
    movl $0, %ebx
    int $0x80

exitWithError:              # uscita con errore
    movl $1, %eax                   # Exit with 1 [error]
    movl $1, %ebx
    int $0x80

ErrorInputFile:

    movl $4, %eax                   # Write file
    movl $2, %ebx                   # File descriptor 2 (stderr)
    movl $MsgInputError, %ecx       # Indirizzo della stringa da stampare
    movl $MsgInputErrorLen, %edx    # Lunghezza della stringa
    int $0x80

    jmp exitWithError

ErrorOutputFile:
    
        movl $4, %eax                   # Write file
        movl $2, %ebx                   # File descriptor 2 (stderr)
        movl $MsgErrorOutputFile, %ecx     # Indirizzo della stringa da stampare
        movl $MsgErrorOutputFileLen, %edx  # Lunghezza della stringa
        int $0x80
    
        jmp exitWithError

Error:                            
    # Stampo un avviso di errore:
    movl $4, %eax                   # Write file
    movl $2, %ebx                   # File descriptor 2 (stderr)
    movl $ErrorString, %ecx         # Indirizzo della stringa da stampare
    movl $ErrorStringLen, %edx      # Lunghezza della stringa
    int $0x80

   jmp exitWithError
