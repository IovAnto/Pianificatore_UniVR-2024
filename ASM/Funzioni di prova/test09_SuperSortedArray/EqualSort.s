.section .data

base: .byte 0
flag: .byte 0

.section .text
    .global EqualSort
    .type EqualSort, @function

EqualSort:

    pushl %ebp
    movl %esp, %ebp
 
    movl 8(%ebp), %edi #len
    movl 12(%ebp), %edx #pointer
    movl 16(%ebp), %ecx #Base

    popl %ebp

    movb %cl, base
    movl %ecx, %eax
    movl %eax, %ebx
    addl $4, %ebx

loop:

    cmpl %eax, %edi
    jle endLoop

    xorl %ecx, %ecx
    xorl %edx, %edx

    movb (%esi, %eax, 1), %cl
    movb (%esi, %ebx, 1), %dl

    cmpb %cl, %dl
    je Check

    jmp next

Check:

    cmpb $3, base
    je decrement

increment:

    incl %eax
    incl %ebx

    movb (%esi, %eax, 1), %cl
    movb (%esi, %ebx, 1), %dl


    subl $3, %eax
    subl $3, %ebx

    cmpb %cl, %dl
    jg reset
    je SetDurata

    movl (%esi, %eax, 1), %ecx
    movl (%esi, %ebx, 1), %edx

    movl %ecx, (%esi, %ebx, 1)
    movl %edx, (%esi, %eax, 1)

    movb $1, flag

    jmp reset

decrement:

    decl %eax
    decl %ebx

    movb (%esi, %eax, 1), %cl
    movb (%esi, %ebx, 1), %dl


    subl $2, %eax
    subl $2, %ebx

    cmpb %cl, %dl
    jg reset
    je SetDurata

    movl (%esi, %eax, 1), %ecx
    movl (%esi, %ebx, 1), %edx

    movl %ecx, (%esi, %ebx, 1)
    movl %edx, (%esi, %eax, 1)

    movb $1, flag

    jmp reset

SetDurata:

    addl $1, %eax
    addl $1, %ebx

Durata:

    movb (%esi, %eax, 1), %cl
    movb (%esi, %ebx, 1), %dl


    subl $1, %eax
    subl $1, %ebx

    cmpb %cl, %dl
    jge reset
    
    movl (%esi, %eax, 1), %ecx
    movl (%esi, %ebx, 1), %edx

    movl %ecx, (%esi, %ebx, 1)
    movl %edx, (%esi, %eax, 1)

    movb $1, flag

reset:

    addb base, %al
    addb base, %bl

next:

    cmpb $1, flag
    je Redo

    addl $4, %eax
    addl $4, %ebx
    jmp loop

Redo:

    movl $0, flag
    movl base, %ecx
    movl %ecx, %eax
    movl %eax, %ebx
    addl $4, %ebx

    jmp loop

endLoop:
    
    ret
    