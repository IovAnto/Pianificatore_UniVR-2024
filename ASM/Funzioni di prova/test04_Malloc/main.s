.section .data

InputFile: .int 0
OutputFile: .int 0
buffer: .space 1024
fd: .int 0
len: .int 0
ArrayPointer: .int 0

.section .text
    .globl _start

_start:
    
    popl %eax 
    popl %eax 
    popl InputFile
    popl OutputFile

    movl $5, %eax # Open file
    movl InputFile, %ebx
    movl $0, %ecx # Read only
    
    int $0x80

    cmp $0, %eax # Verifico se va in errore
    jl Error

    movl %eax, fd   

    movl $3, %eax # Read file
    movl fd, %ebx
    movl $buffer, %ecx # da provare con movl $buffer
    movl $1024, %edx

    int $0x80

    cmp $0, %eax # Verifico se va in errore
    jl Error

FileClose: 

    movl $6, %eax # Close file
    movl fd, %ebx

    int $0x80


    movl $buffer, %esi

SpaceLoop:
    
    cmpb $0, (%esi)
    je malloc

    cmpb $10, (%esi) 
    je lenPlus

    incl %esi
    jmp SpaceLoop

lenPlus:
    
    incl len
    incl %esi
    jmp SpaceLoop

malloc:

    movl $45, %eax
    xorl %ebx, %ebx
    int $0x80

    movl %eax, %esi

    addl len, %eax
    sal $2, %eax

    movl %eax, %ebx
    movl $45, %eax
    int $0x80

    cmpl %esi, %eax
    jle Error

    movl %esi, ArrayPointer
    
Pippo:

    movl $buffer, %esi
    movl $ArrayPointer, %edi

    call BufferToArray

Prova:

    cmpl $0, OutputFile
    je print

    movl $5, %eax # Open file
    movl OutputFile, %ebx
    movl $65, %ecx # Write or create
    movl $0x1A4, %edx # 0644

    int $0x80

    cmp $0, %eax # Verifico se va in errore
    jl Error

    movl %eax, fd

print:

    xorl %eax, %eax
    movb ArrayPointer, %al

    call btoa

    movl %eax, %ecx

    movl $4, %eax # Write file
    movl $1, %ebx
    movl $4, %edx

    int $0x80

    cmp $0, %eax # Verifico se va in errore
    jl Error
    

    movl $6, %eax # Close file
    movl fd, %ebx

    int $0x80
    
Error:

    movl $1, %eax # Exit
    movl $0, %ebx
    int $0x80
