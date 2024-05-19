.section .data
pointer: .int 0
high: .int 0
low: .int 0
pivot: .int 0
i: .int 0
j: .int 0
pindex: .int 0

.section .text
.global QuickSort
.type QuickSort, @function

# arr = EAX
# low = ECX
# high = EDX

QuickSort:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi

    # if low < high
    cmpl %ecx, %edx
    jge end_quick_sort

    # Partition logic
    # pivot = arr[high]
    movl (%eax, %edx, 4), %ebx
    movl %ebx, pivot

    # i = low - 1
    movl %ecx, %esi
    subl $1, %esi
    movl %esi, i

    movl %ecx, %edi  # j = low

partition_loop:
    cmpl %edx, %edi
    jge end_partition_loop

    movl (%eax, %edi, 4), %ebx
    cmpl pivot, %ebx
    jg skip_swap

    addl $1, i
    movl i, %esi
    movl (%eax, %esi, 4), %ebx
    movl (%eax, %edi, 4), %ecx
    movl %ecx, (%eax, %esi, 4)
    movl %ebx, (%eax, %edi, 4)

skip_swap:
    addl $1, %edi
    jmp partition_loop

end_partition_loop:
    addl $1, i
    movl i, %esi
    movl (%eax, %esi, 4), %ebx
    movl (%eax, %edx, 4), %ecx
    movl %ecx, (%eax, %esi, 4)
    movl %ebx, (%eax, %edx, 4)

    movl i, pindex

    # Recursive calls
    movl %eax, %ebx
    movl %ecx, %ecx
    movl pindex, %edx
    subl $1, %edx
    call QuickSort

    movl %eax, %ebx
    movl pindex, %ecx
    addl $1, %ecx
    movl high, %edx
    call QuickSort

end_quick_sort:
    popl %edi
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret