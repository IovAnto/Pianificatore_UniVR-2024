.section .data

    array: .byte 0,0,0,5,0,0,0,2,0,0,0,1,0,0,0,4 # array to be sorted

                    
    pointer: .int 0 # pointer to the array
    len: .int 16 # length of the array

.section .text
    .globl _start # entry point

_start:

    movl $array, %eax # pointer = &array[0]
    movl %eax, pointer
    movl $80, len # len = 80
    movl len, %ebx
    

# ----------------------------
# non so perchè ma mi cambia l'array quando poppo len (non riesco a trovare alcuna spiegazione)
#    push %eax                
#    push %ebx

    # STACK:
    #   |   ...     |
    #   |   ...     |
    #   |   pointer |
    #   |   len     |
    

    call InsertionSort
    
    movl $1, %eax               # exit
    movl $0, %ebx               # exit status

    int $0x80                   # syscall
    
    
