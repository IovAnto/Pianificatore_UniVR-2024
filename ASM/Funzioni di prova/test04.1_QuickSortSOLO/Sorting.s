.section .data

    array: .byte 0,0,0,3,0,0,0,5,0,0,0,1,0,0,0,4,0,0,0,2,0,0,0,3,0,0,0,1,0,0,0,2,0,0,0,1,0,0,0,3 # array to be sorted
                    
    pointer: .int 0 # pointer to the array
    len: .int 40 # length of the array
    
    pivot: .byte 0 # pivot value

.section .text
    .globl _start # entry point

_start:

    movl $array, pointer # pointer = &array[0]

# ----------------------------

    movl pointer, %esi          # int* arr / puntatore all'array
    movl $0, %ebx               # int low / indice basso
    movl len, %edi              # int high / indice alto
    decl %edi                   # high-- / indice alto -1 
    
    call QuickSort              # QuickSort(arr, low, high)
    
    movl $1, %eax               # exit
    movl $0, %ebx               # exit status

    int $0x80                   # syscall
    
    
