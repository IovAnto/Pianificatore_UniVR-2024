.section .data
buffer: .space 4  # Buffer for the string (3 digits + null terminator)

.section .text
.global itoa
itoa:
    movl $10, %ebx  # The base to convert to
    leal buffer+3, %edi  # Start at the end of the buffer
    movb $0, (%edi)  # Null terminator

loop:

    movl 