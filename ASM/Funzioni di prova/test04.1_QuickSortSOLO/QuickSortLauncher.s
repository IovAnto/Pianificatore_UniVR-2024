.section .data

pointer: .int 0
high: .int 0
low: .int 0


.section .text
.global QuickSort
.type QuickSort, @function

QuickSort:
    
    movl %esi, pointer
    movl %ebx, low
    movl %ecx, high

    cmpl %ecx, %ebx
    jge end

    call partition

end:

    ret
