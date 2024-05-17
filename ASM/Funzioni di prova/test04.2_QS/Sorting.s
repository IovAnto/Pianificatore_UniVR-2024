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

    movl pointer, %esi          # esi = pointer
    movl $0, %ebx               # ebx = 0
    movl len, %edi              # edi = len
    decl %edi                   # edi = len - 1
    
    call QuickSort              # QuickSort(arr, low, high) -> quick sort(esi, ebx, edi)
    
    movl $1, %eax               # exit
    movl $0, %ebx               # exit status

    int $0x80                   # syscall
    
    
