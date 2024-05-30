.section .data

Stringa: .space 4
counter: .byte 0
newLine: .byte 10

.section .text
    .global btoa
    .type btoa, @function
    
btoa:

    movb $0, counter
    pushl %ebx           #salvo il tempo
    movl $10, %ebx      #divisore
    leal Stringa+3, %edi    #punto di partenza della stringa
    movb $58, (%edi)

    jmp loop

timetoa:

    leal Stringa+3, %edi
    movb $10, (%edi)

loop:

    xorl %edx, %edx
    div %ebx

    addb $48, %dl
    decl %edi
    movb %dl, (%edi)

    test %eax, %eax
    jz StringToBuffer

    jmp loop

StringToBuffer:

    movb (%edi), %al
    cmpb $58, %al
    je DuePunti

    cmpb $10, %al
    je FineRiga

    movb %al, (%esi, %ecx, 1)

    incl %ecx
    incl counter
    incl %edi

    jmp StringToBuffer

DuePunti:

    movb %al, (%esi, %ecx, 1)

    incl %ecx

    incl counter

Tempo:

    xorl %eax, %eax
    popl %eax
    jmp timetoa

FineRiga:

    movb %al, (%esi, %ecx, 1)

    incl counter

fine:

    xorl %ecx, %ecx
    movb counter , %cl

    ret
