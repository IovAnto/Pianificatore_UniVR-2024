.section .data


MsgBadInputFile: .asciz "\n\n\n\nErrore nell'apertura del file di input.\n0) Esci dal programma.\t\t1) Inserisci un nuovo file di input.\n\n"
MsgBadInputFileLen = . - MsgBadInputFile

MsgAskForInputFile: .asciz "\nInserire il path del file di input:\t"
MsgAskForInputFileLen = . - MsgAskForInputFile


FPlength: .int 0
filepath: .string ""

UserChoice: .space 2


.section .text 
    .global AskInput
    .type AskInput, @function

AskInput:

    movl $0, FPlength               # Reset the length of the file path

    # avviso che il file di input non è corretto e chiedo se si vuole inserirne un altro (1 inserisci nuovo file 0 esci)
    movl $4, %eax                   # Write file
    movl $2, %ebx                   # File descriptor 2 (stderr)
    movl $MsgBadInputFile, %ecx     # Indirizzo della stringa da stampare
    movl $MsgBadInputFileLen, %edx  # Lunghezza della stringa
    int $0x80

    # Chiedi all'utente di decidere tra 0 e 1
    movl $3, %eax                   # Read file
    movl $0, %ebx                   # File descriptor 0 (stdin)
    leal UserChoice, %ecx           # Indirizzo della stringa da leggere
    movl $2, %edx                   # Lunghezza della stringa
    int $0x80

    # Confronta l'input con '0'
    cmpb $48, UserChoice
    je ExitProgram

    # Confronta l'input con '1'
    cmpb $'1', UserChoice
    je AskFilePath

    jmp ErrorInput


AskFilePath:
   
    # chiedo il path del file di input
    # acquisisco nuovo input path come stringa da tastiera e lo salvo in ciò che è puntato da Finput:

    # richiedo il file path stampando un messaggio a video
    movl $4, %eax                   # Write file
    movl $2, %ebx                   # File descriptor 2 (stderr)
    movl $MsgAskForInputFile, %ecx  # Indirizzo della stringa da stampare
    movl $MsgAskForInputFileLen, %edx # Lunghezza della stringa
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


    # Open the file in read-only mode
    movl $5, %eax          # sys_open
    movl $filepath, %ebx   # filename
    movl $0, %ecx          # flags: O_RDONLY
    int $0x80              # syscall


    cmpl $-1, %eax
    je AskInput            # if less than 0, jump to AskInput

    # %eax contains the file descriptor, continue with other operations

    ret

ExitProgram:
#
#   movl $4, %eax                   # Write file
#   movl $2, %ebx                   # File descriptor 2 (stderr)
#   movl $MsgExitProgram, %ecx      # Indirizzo della stringa da stampare
#   movl $MsgExitProgramLen, %edx   # Lunghezza della stringa
#   int $0x80
#
#
#   # Codice per uscire dal programma
#   movl $0, %eax                   # Exit system call
#   xorl %ebx, %ebx                 # Exit code 0
#   int $0x80
#
    movl $0, %eax
    ret
ErrorInput:
    movl $1, %eax           # Exit with 1 [error]
    movl $1, %ebx
    int $0x80

