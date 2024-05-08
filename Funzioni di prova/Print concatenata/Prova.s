.section .data

num_str: .ascii "000"

Buffer:
    .byte 0

num_str_len:
.long . - num_str

.section .text
    .global _start

_start:
    movl $3, %eax
    movl $0, %ebx
    leal num_str, %ecx
    movl num_str_len, %edx

    int $0x80

    leal num_str, %esi

    call atoi
    
    movl %eax, %ebx

    shl $3 , %ebx
    shl $1 , %eax

    add %ebx, %eax

    pushl %eax

    movl $4, %eax

    movl $3, %eax
    movl $0, %ebx
    leal num_str, %ecx
    movl num_str_len, %edx
    
    int $0x80

    leal num_str, %esi

    call atoi

    popl %ebx

    add %ebx, %eax
    
    call itoa

    movl $1, %eax
    movl $0, %ebx

    int $0x80


    
