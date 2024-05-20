.section .data

array: .byte 0,0,0,10,0,0,0,20,0,0,0,1,0,0,0,4,0,0,0,9
len: .int 20  

.section .text
.globl _start

_start:

    pushl $array
    pushl len

    call insertionSort

    movl $1, %eax

    #Break point to Arr ( 18 )

    int $0x80
