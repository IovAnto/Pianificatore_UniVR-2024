.section .data


MsgBadOutputFile: .asciz "Errore nell'apertura o nella creazione del file di Output.\n\n\n0)\t Continua senza salvare.\n1)\t Inserisci un nuovo file di Output.\n\n"
MsgBadOutputFileLen = . - MsgBadOutputFile

MsgAskForOutputFile: .asciz "Inserire il path del file di Output:\t"
MsgAskForOutputFileLen = . - MsgAskForOutputFile

FPlength: .int 0
filepath: .string ""

UserChoice: .space 2


.section .text 
    .global AskOutput
    .type AskOutput, @function

AskOutput:

    movl $0, FPlength               # Reset the length of the file path

    # avviso che il file di Output non è corretto e chiedo se si vuole inserirne un altro (1 inserisci nuovo file 0 esci)
    movl $4, %eax                   # Write file
    movl $2, %ebx                   # File descriptor 2 (stderr)
    movl $MsgBadOutputFile, %ecx     # Indirizzo della stringa da stampare
    movl $MsgBadOutputFileLen, %edx  # Lunghezza della stringa
    int $0x80

    # Chiedi all'utente di decidere tra 0 e 1
    movl $3, %eax                   # Read file
    movl $0, %ebx                   # File descriptor 0 (stdin)
    leal UserChoice, %ecx           # Indirizzo della stringa da leggere
    movl $2, %edx                   # Lunghezza della stringa
    int $0x80

    # Confronta l'Output con '0'
    cmpb $'0', UserChoice
    je ExitProgram

    # Confronta l'Output con '1'
    cmpb $'1', UserChoice
    je AskFilePath

    jmp ErrorOutput


AskFilePath:
   
    # chiedo il path del file di Output
    # acquisisco nuovo Output path come stringa da tastiera e lo salvo in ciò che è puntato da FOutput:

    # richiedo il file path stampando un messaggio a video
    movl $4, %eax                   # Write file
    movl $2, %ebx                   # File descriptor 2 (stderr)
    movl $MsgAskForOutputFile, %ecx  # Indirizzo della stringa da stampare
    movl $MsgAskForOutputFileLen, %edx # Lunghezza della stringa
    int $0x80

    # Read filename from stdin
    movl $3, %eax          # sys_read
    movl $0, %ebx          # file descriptor: stdin
    movl $filepath, %ecx   # buffer to store filename
    movl $512, %edx        # number of bytes to read
    int $0x80              # make the system call

    # Save the length of the string read
    movl %eax, FPlength

    # sostituisci i carattere \n al termine di filepath con \0 conoscendo la lunghezza della stringa (FPlength)

    #  FPlength contiene la lunghezza della stringa
    # filepath è l'indirizzo della stringa

    movl FPlength, %ecx     # Carica la lunghezza della stringa
    decl %ecx               # Decrementa di 1 per ottenere l'indice del carattere \n
    movl $filepath, %edi    # Carica l'indirizzo della stringa
    addl %ecx, %edi         # Aggiungi l'indice a %edi per ottenere l'indirizzo del carattere \n
    movb $0, (%edi)         # Sovrascrivi il carattere \n con \0


# Apro il file di output
    movl $5, %eax                   # Open file
    movl filepath, %ebx           # path
    movl $65, %ecx                  # Write or create
    movl $0x1A4, %edx               # RWX

    int $0x80


    cmpl $-1, %eax
    je AskOutput            # if less than 0, jump to AskOutput

    # %eax contains the file descriptor, continue with other operations

    ret

ExitProgram:
    # Codice per uscire dal programma
    movl $1, %eax                   # Exit system call
    xorl %ebx, %ebx                 # Exit code 0
    int $0x80

ErrorOutput:
    movl $1, %eax           # Exit with 1 [error]
    movl $1, %ebx
    int $0x80

