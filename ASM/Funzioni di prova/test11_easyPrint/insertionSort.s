.section .data

    key: .int 0
    base: .int 0

.section .text 
    .global insertionSort
    .type insertionSort, @function

insertionSort:

    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi # edi = Arr[fine]
    movl 12(%ebp), %esi # esi = Arr[inizio]
    movl 16(%ebp), %ecx # Metodo di sorting (+3 Priorità, +2 Scadenza)

    popl %ebp

    movl %ecx, base

    xorl %ecx, %ecx # i = 0
    xorl %edx, %edx # j = 0
    addl base, %ecx # %ecx punta alla priorità/scadenza 
    addl $4, %ecx  # %punta a 2 oggetto (1)

for:

    cmpl %ecx, %edi
    jle endFor

    movl (%esi, %ecx, 1), %eax
    movb %al, key 
    subl base, %ecx
    movl (%esi, %ecx, 1), %eax
    push %eax
    addl base, %ecx

    movl %ecx, %edx # j = i
    addl $-4, %edx # j = i - 1

while:

    cmpl $0, %edx
    jl PrepEndWhile

    movb (%esi,%edx,1), %al

    cmpb %al, key
    jg PrepEndWhile

    subl base, %edx
    movl %edx, %eax
    addl $4, %eax
    movl (%esi ,%edx,1), %ebx
    movl %ebx, (%esi ,%eax,1)
    decl %edx

    cmpl $3, base
    je while

    decl %edx

    jmp while

PrepEndWhile:

    incl %edx

    cmpl $3, base
    je endWhile

    incl %edx

endWhile:

    popl %eax
    movl %eax, (%esi ,%edx, 1)

    addl $4, %ecx

    jmp for

endFor:

    ret
