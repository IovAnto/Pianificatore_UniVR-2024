.section .data
filename:
    .ascii "test.txt"
filedescriptor:
    .int 0
buffer:
    .space 1

newline:
    .byte 10 # Carattere di nuova linea

virgola:
    .byte 44 # Carattere di virgola

index:
    .int 0

array:
    .space 100

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
    mov $1, %edx      # Numero di byte da leggere
    int $0x80           # Interruzione del kernel

    # Se c'è un errore o EOF esce
    cmp $0, %eax
    jl _close_file

    # Se non ha letto nulla, esce
    cmp $0, %eax
    je _print_array
    
    # Controllo se il carattere letto è un newline
    movb buffer, %al    # copio il carattere dal buffer ad AL (registro a 8 bit di %eax)
    cmpb newline, %al   # confronto AL con il carattere "\n"

    jne _saveToArray    # se sono diversi salvo in array

    # Controllo se il carattere letto è una virgola
    movb buffer, %al    # copio il carattere dal buffer ad AL (registro a 8 bit di %eax)
    cmpb virgola, %al   # vedo se è virgola
    jne _saveToArray    # se sono diversi salvo in array
    
    incw index          # altrimenti, incremento index array


_saveToArray:
    movb buffer, %al    # copio il carattere dal buffer ad AL (registro a 8 bit di %eax)
    mov index, %edx    # copio index in edx
    movb %al, array(, %edx, 1) # salvo il carattere in array
    incw index          # incremento index array

_close_file:
    mov $6, %eax                # Syscall close
    mov filedescriptor, %ebx    # File descriptor
    int $0x80                   # Interruzione del kernel

    jmp _exit


    _print_array:
        mov $4, %eax        # Syscall write
        mov $1, %ebx        # File descriptor (stdout)
        mov $array, %ecx    # Buffer
        mov index, %edx     # Numero di byte da scrivere
        int $0x80           # Interruzione del kernel
        ret

_print_array_loop:
    cmpw $0, index     # Confronto index con 0
    jle _exit          # Se index <= 0, esce
    decw index         # Decrementa index
    call _print_array  # Stampa array
    jmp _print_array_loop

_exit:
    jmp _print_array_loop
    mov $1, %eax        # Syscall exit
    mov $0, %ebx        # Codice di uscita
    int $0x80           # Interruzione del kernel

_start:
    call _open
