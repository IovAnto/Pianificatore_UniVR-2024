.section .data

    key: .int 0
    pointer: .int 0

.section .text 
    .global insertionSort
    .type insertionSort, @function

insertionSort:

    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi # edi = Arr[fine]
    movl 12(%ebp), %esi # esi = Arr[inizio]

    popl %ebp

    movl %esi, pointer

    xorl %ecx, %ecx # i = 0
    xorl %edx, %edx # j = 0
    addl $7, %ecx  # i = 1 (priorità) (posso passare da stack lo spiazamento +3 se prio +2 se scadenza)

for:

    cmpl %ecx, %edi
    jle endFor

    movl (%esi, %ecx, 1), %eax
    movb %al, key 
    addl $-3, %ecx
    movl (%esi, %ecx, 1), %eax
    push %eax
    addl $3, %ecx

    movl %ecx, %edx # j = i
    addl $-4, %edx # j = i - 1

while:

    cmpl $0, %edx
    jl endWhile

    movb (%esi,%edx,1), %al

    cmpb %al, key
    jg endWhile

    addl $-3, %edx
    movl %edx, %eax
    addl $4, %eax
    movl (%esi ,%edx,1), %ebx
    movl %ebx, (%esi ,%eax,1)
    decl %edx

    jmp while

endWhile:

    incl %edx
    popl %eax
    movl %eax, (%esi ,%edx, 1)

    addl $4, %ecx

    jmp for

endFor:
    
    ret
