.section .data
    fd: .int 0

.section .bss
    buffer: .string ""

.section .text
    .global ReadOrders
    .type ReadOrders, @function

ReadOrders:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %ebx   # FileOrder
    movl 12(%ebp), %esi  # ArrayOrder

    movl $5, %eax
    movl $0, %ecx

    int $0x80

    cmpl $0, %eax
    jl endRead

    movl %eax, fd

    movl $19, %eax
    movl fd, %ebx
    xorl %ecx, %ecx
    xorl %edx, %edx

    int $0x80

    xorl %eax, %eax
    pushl %eax

ReadLoop:
    movl $3, %eax
    movl fd, %ebx
    leal buffer, %ecx
    movl $1, %edx

    int $0x80

    cmp $0, %eax
    jle endRead

    movb buffer, %cl

    cmpb $10, %cl
    je store

    cmpb $44, %cl
    je store

    jmp num

store:
    popl %eax
    movb %al, (%esi)
    addl $1, %esi
    xorl %eax, %eax
    pushl %eax

    jmp ReadLoop

num:
    popl %eax
    movl %eax, %ebx

    sal $3, %eax
    sal $1, %ebx

    addl %ebx, %eax

    movb %cl, %bl
    subl $48, %ebx

    addl %ebx, %eax

    pushl %eax

    jmp ReadLoop

endRead:
    movl $6, %eax   # close
    movl fd, %ebx

    int $0x80

    movl %ebp, %esp
    popl %ebp

    ret
