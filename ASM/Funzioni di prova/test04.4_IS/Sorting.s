.section .data

    array: .byte 0,0,0,3,0,0,0,5,0,0,0,1,0,0,0,4,0,0,0,2,0,0,0,3,0,0,0,1,0,0,0,2,0,0,0,1,0,0,0,3 # array to be sorted
                    
    pointer: .int 0 # pointer to the array
    len: .int 40 # length of the array

.section .text
    .globl _start # entry point

_start:

    movl $array, pointer # pointer = &array[0]

# ----------------------------

    push pointer
    push len

    call InsertionSort
    
    movl $1, %eax               # exit
    movl $0, %ebx               # exit status

    int $0x80                   # syscall
    
    
