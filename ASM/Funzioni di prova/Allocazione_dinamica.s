.section .data

Ordini:
    .byte 0 #ID
    .byte 0 #Durata
    .byte 0 #Scadenza
    .byte 0 #Priorità

.section .bss

ArrayOrdini:

.section .text
    .globl _start

_start:
    movl $45, %eax
    movl $100, %ebx

    int $0x80

    movl %eax, ArrayOrdini

    movl $'3', (ArrayOrdini)
    movl $'', (ArrayOrdini+1)

    movl $4, %eax
    movl $1, %ebx
    movl $ArrayOrdini, %ecx
    movl $1, %edx

    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $ArrayOrdini + 1, %ecx
    movl $1, %edx

    int $0x80

    movl $1, %eax
    movl $0, %ebx

    int $0x80
