.section .data

FPlength: .int 0
filepath: .string ""

.section .text
    .global TextIn
    .type TextIn, @function

TextIn:
    movl $3, %eax
    movl $0, %ebx
    movl $filepath, %ecx
    movl $512, %edx
    int $0x80

    movl %eax, FPlength

    movl FPlength, %ecx
    decl %ecx
    movl $filepath, %edi
    addl %ecx, %edi
    movb $0, (%edi)

    movl $filepath, %eax

    ret
