.section .data

    array: .byte 5, 3, 4, 7, 0, 7, 5 ,10, 28, 1 # array to be sorted
    pointer: .int 0 # pointer to the array
    len: .int 10 # length of the array
    
    pivot: .byte 0 # pivot value

.section .text
    .globl _start

_start:

    movl $array, pointer

#----------------------------

    movl pointer, %esi # int* arr
    movl $0, %ebx   # int low
    movl len, %ecx #int high
    decl %ecx # high--
    
    call QuickSort
    
    movl $1, %eax
    movl $0, %ebx

    int $0x80
    
    
