.section .data
filename:
    .ascii "test.txt"

fd:
    .int 0

buffer: .string""
newLine: .ascii "\n"
lines: .int 0

.section .bss

.section .text
    .globl _start

#Apertura file
_open:
    movl $5, %eax           # syscall apri
    movl $filename, %ebx    # nome del file
    movl $0, %ecx           # apro in lettura
    int $0x80               # interrupt

    # cioè metto in eax la syscall e in ebx il nome del file
    # in ecx dico di aprire in lettura e poi interrupt

    # qui andrebbe il controllo ma yolo

    movl %eax, fd           # salvo il file descriptor

# leggo riga x riga
_readLoop:
    movl $3, %eax            # syscall read
    movl fd, %ebx            # file descriptor
    movl buffer, %ecx        # buffer
    movl $255, %edx          # lunghezza buffer
    int $0x80               # interrupt

    # qui andrebbe il controllo ma yolo

    # check se c'è un altra linea
    movb buffer, %al    # prendo il primo carattere
    cmpl newLine, %al   # confronto con il carattere di newline salvato prima come variabile
    jne _printLine      # se non è newline stampo la linea (jump if not equal JNE)
    incw lines          # incremento il contatore delle linee altrimenti

_printLine:
    movl $4, %eax           # syscall write
    movl $1, %ebx           # file descriptor stdout
    movl buffer, %ecx       # buffer
    int $0x80               # interrupt

    jmp _readLoop           # torno a leggere 

# chiudo il file    
_close:
    movl $6, %eax           # syscall close
    movl fd, %ebx           # file descriptor
    int $0x80               # interrupt


jmp _exit