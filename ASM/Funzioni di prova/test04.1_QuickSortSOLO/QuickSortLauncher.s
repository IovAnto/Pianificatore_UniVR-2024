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
    movl %edi, high
    

    cmpl %edi, %ebx
    jge end

    call partition
    #metto le giuste variabili nei registri

    #ricorsivo

    call QuickSort


end:

    ret
