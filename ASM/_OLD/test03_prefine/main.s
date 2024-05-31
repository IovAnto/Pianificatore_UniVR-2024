.section .data
InputFile: .int 0
OutputFile: .int 0
buffer: .space 1024
fd: .int 0
len: .int 0
ArrayPointer: .space 512

.section .bss
# ArrayPointer: in caso di malloc TODO

.section .text
.globl _start

_start:
    popl %eax                       # Pop argc
    popl %eax                       # Pop argv[0]
    popl InputFile                  # Pop argv[1] "InputFile path"
    popl OutputFile                 # Pop argv[2] "OutputFile path"

    movl $5, %eax                   # Open file
    movl InputFile, %ebx
    movl $0, %ecx                   # Read only
    int $0x80

    cmp $0, %eax                    # Verifico errore apertura file
    jl Error

    movl %eax, fd   

    movl $3, %eax                   # Read file
    movl fd, %ebx
    movl $buffer, %ecx              # da provare con movl $buffer
    movl $1024, %edx
    int $0x80

    cmp $0, %eax                    # Verifico se va in errore
    jl Error

    movl %eax, len

FileClose: 
    movl $6, %eax                   # Close file
    movl fd, %ebx
    int $0x80

malloc:
#----------------------

Pippo:
    movl $buffer, %esi
    movl $ArrayPointer, %edi
    call BufferToArray

loopPrintArray:
    movl $4, %eax                   # Write file
    movl $1, %ebx
    movl $ArrayPointer, %ecx
    movl $512, %edx
    int $0x80

    cmp $0, %eax                    # Verifico se va in errore
    jl Error

    movl $1, %eax                   # Exit
    movl $0, %ebx
    int $0x80

Prova:
    movl $5, %eax                   # Open file
    movl OutputFile, %ebx
    movl $65, %ecx                  # Write or create
    movl $0x1A4, %edx               # 0644
    int $0x80

    cmp $0, %eax                    # Verifico se va in errore
    jl Error

    movl %eax, fd

    movl $4, %eax                   # Write file
    movl fd, %ebx
    movl $buffer, %ecx
    movl len, %edx
    int $0x80

    cmp $0, %eax                    # Verifico se va in errore
    jl Error

    movl $6, %eax                   # Close file
    movl fd, %ebx
    int $0x80
    
Error:
    movl $1, %eax                   # Exit
    movl $0, %ebx
    int $0x80
