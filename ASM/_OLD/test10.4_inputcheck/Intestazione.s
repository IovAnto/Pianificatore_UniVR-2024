.section .data

    Pianificazione: .asciz "Pianificazione "
    PianificazioneLen: .int . - Pianificazione
    
    P1: .asciz "EDF: \n"
    P1Len: .int . - P1

    P2: .asciz "HPF: \n"
    P2Len: .int . - P2

.section .text
    .global intestazione
    .type intestazione, @function

intestazione:

    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax

    popl %ebp

    xorl %ebx, %ebx
    xorl %edx, %edx
    xorl %ecx, %ecx

    pushl %ecx

ini:

    leal Pianificazione, %esi
    movb (%esi, %ecx, 1), %dl
    movb %dl, (%edi,%ecx,1)

    cmpl PianificazioneLen, %ecx
    jge check

    incl %ecx
    jmp ini

check:

    popl %ecx
    addl PianificazioneLen, %ecx
    pushl %ecx

    cmpl $3, %eax
    je P2in

P1in:

    leal P1, %esi
    movb (%esi, %ebx, 1), %dl
    movb %dl, (%edi,%ecx,1)

    cmpl P1Len, %ecx
    jge endP1

    incl %ecx

    jmp P1in

endP1:

    popl %ecx
    addl P1Len, %ecx

    ret

P2in:

    leal P2, %esi
    movb (%esi, %ebx, 1), %dl
    movb %dl, (%edi,%ecx,1)

    cmpl P2Len, %ecx
    jge endP2

    incl %ecx

    jmp P2in

endP2:

    popl %ecx
    addl P2Len, %ecx

    ret
    