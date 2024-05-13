.section .data
filename:
    .ascii "test.txt"
filedescriptor:
    .int 0
buffer:
    .space 100 # Buffer per la lettura del file

newline:
    .byte 10 # Carattere di nuova linea

virgola:
    .byte 44 # Carattere di virgola

index:
    .int 0


.section .bss

.section .text
.globl _start

# Apre il file
_open:
    mov $5, %eax        # Syscall open
    mov $filename, %ebx # Nome del file
    mov $0, %ecx        # Modalità di apertura (O_RDONLY)
    int $0x80           # Interruzione del kernel

    # Se c'è un errore, esce
    cmp $0, %eax
    jl _exit

    mov %eax, filedescriptor      # filedescriptor = risultato syscall from eax

# lettura file
_read_loop:
    mov $3, %eax        # Syscall read
    mov $filedescriptor, %ebx       # File descriptor
    mov $buffer, %ecx   # Buffer
    mov $100, %edx      # Numero di byte da leggere
    int $0x80           # Interruzione del kernel

    # Se c'è un errore o EOF esce
    cmp $0, %eax
    jl _close_file

    # Se non ha letto nulla, esce
    cmp $0, %eax
    je _print_array
    
    # Stampa il buffer
    mov %eax, index # Salva il numero di byte letti
    call _print


_print:
    mov $4, %eax        # Syscall write
    mov $1, %ebx        # File descriptor (stdout)
    mov $buffer, %ecx   # Buffer
    mov index, %edx     # Numero di byte da scrivere
    int $0x80           # Interruzione del kernel

    ret


_close_file:
    mov $6, %eax                # Syscall close
    mov filedescriptor, %ebx    # File descriptor
    int $0x80                   # Interruzione del kernel

    jmp _exit


_exit:
    jmp _print_array_loop
    mov $1, %eax        # Syscall exit
    mov $0, %ebx        # Codice di uscita
    int $0x80           # Interruzione del kernel

_start:
    call _open
