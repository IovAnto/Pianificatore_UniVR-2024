.section .data

    array: .byte 0,0,0,3,0,0,0,5,0,0,0,1,0,0,0,4,0,0,0,2,0,0,0,3,0,0,0,1,0,0,0,2,0,0,0,1,0,0,0,3 # array to be sorted
                    
    pointer: .int 0 # pointer to the array
    len: .int 40 # length of the array
    
    pivot: .byte 0 # pivot value

.section .text
    .globl _start

_start:

    movl $array, pointer

#----------------------------

    movl pointer, %esi # int* arr
    movl $0, %ebx   # int low
    movl len, %edi #int high
    decl %edi # high--
    
    call QuickSort
    
    movl $1, %eax
    movl $0, %ebx

    int $0x80
    
    
