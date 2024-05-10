.section .data

Ordini:
    .byte 0     # ID        | 0 - 127   |
    .byte 0     # Durata    | 1 - 10    |
    .byte 0     # Scadenza  | 1 - 99    |
    .byte 0     # Priota'   | 1 - 5     |
 

.section .bss

ArrayOrdini: 

.section .text
    .global _start

_start:

    jmp OpenFile
    jmp OutputToFile
    movl $1, %eax   # Exit
    movl $0, %ebx   # Exit
    int $0x80       # Exit

    # ok 
