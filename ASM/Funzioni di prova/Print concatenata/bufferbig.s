.section .data
filename:   .asciz "test.txt"
buffer:     .space 1024
fd:         .int 0
newline:    .asciz "\n"

.section .text
.global _start
_start:
    # Apre il file in modalità di sola lettura
    mov $5, %eax        # syscall open
    mov $filename, %ebx # nome del file
    mov $0, %ecx        # modalità di sola lettura
    int $0x80           # chiamata di sistema

    # Controlla se l'apertura del file ha avuto successo
    cmp $0, %eax
    jl error            # se eax < 0, c'è stato un errore

    # Salva il file descriptor restituito in ebx
    mov %eax, fd


    # Legge il contenuto del file in memoria
    mov $3, %eax        # syscall read
    mov fd, %ebx      # file descriptor
    mov $buffer, %ecx   # buffer di destinazione
    mov $1024, %edx     # dimensione del buffer
    int $0x80           # chiamata di sistema

    # Controlla se la lettura del file ha avuto successo
    cmp $0, %eax
    jl error            # se eax < 0, c'è stato un errore


    # stampo il contenuto del file
    mov $4, %eax        # syscall write
    mov $1, %ebx        # file descriptor stdout
    mov $buffer, %ecx   # buffer di sorgente
    mov $256, %edx      # lunghezza del buffer
    int $0x80           # chiamata di sistema
    
    # #############################################
    # stampo 3 volte '\n'
    mov $4, %eax        # syscall write
    mov $1, %ebx        # file descriptor stdout
    mov $newline, %ecx  # buffer di sorgente
    mov $1, %edx        # lunghezza del buffer
    int $0x80           # chiamata di sistema
    # #############################################

    # loop di stampa leggendo da 'buffer' stampando 1 carattere alla volta
    mov $0, %esi        # inizializzo il contatore
    .print_loop:

        mov $4, %eax        # syscall write
        mov $1, %ebx        # file descriptor stdout
        mov $buffer, %ecx   # buffer di sorgente
        add %esi, %ecx      # aggiungo il contatore al buffer
        mov $1, %edx        # lunghezza del buffer
        int $0x80           # chiamata di sistema

        # incremento il contatore
        inc %esi

        # controllo se ho finito di stampare
        cmp $1024, %esi
        jl .print_loop

    # Chiude il file
    mov $6, %eax        # syscall close
    mov %ebx, %ebx      # file descriptor
    int $0x80           # chiamata di sistema

    # Termina il programma
    mov $1, %eax        # syscall exit
    xor %ebx, %ebx      # codice di uscita 0
    int $0x80           # chiamata di sistema

error:
    # Gestisce gli errori
    mov $4, %eax        # syscall write
    mov $2, %ebx        # file descriptor stderr
    mov $error_msg, %ecx    # messaggio di errore
    mov $13, %edx       # lunghezza del messaggio
    int $0x80           # chiamata di sistema

    # Termina il programma con codice di uscita 1
    mov $1, %eax        # syscall exit
    mov $1, %ebx        # codice di uscita 1
    int $0x80           # chiamata di sistema

.section .data
error_msg:  .asciz "Errore durante l'apertura del file\n"
