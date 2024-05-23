.section .data
word: .space 4  # Buffer for the string (3 digits + null terminator)

.section .text
    .global btoa
    .type btoa, @function
    
btoa:
    movl $10, %ebx  # The base to convert to
    leal word+3, %edi  # Start at the end of the buffer
    movb $10, (%edi)  # Null terminator

loop:
    xorl %edx, %edx  # Clear edx
    div %ebx  # Divide edx:eax by bl

    addb $48, %dl  # Convert remainder to ASCII
    dec %edi
    movb %dl, (%edi)  # Store remainder in buffer

    test %eax, %eax  # Check if quotient is 0
    jz done  # If quotient is 0, exit loop

    jmp loop

done:
    movl %edi, %eax  # Return pointer to start of string
    ret
    