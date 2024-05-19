.section .data
pointer: .int 0    ; Variabile per il puntatore all'array
high: .int 0       ; Variabile per l'indice più alto dell'array
low: .int 0        ; Variabile per l'indice più basso dell'array
pivot: .int 0      ; Variabile per il valore del pivot
i: .int 0          ; Variabile per l'indice i
j: .int 0          ; Variabile per l'indice j
pindex: .int 0     ; Variabile per l'indice del pivot

.section .text
.global QuickSort
.type QuickSort, @function

QuickSort:
    pushl %ebp      ; Salva il valore di ebp nello stack
    movl %esp, %ebp ; Imposta ebp come il nuovo valore di esp
    pushl %ebx      ; Salva il valore di ebx nello stack
    pushl %esi      ; Salva il valore di esi nello stack
    pushl %edi      ; Salva il valore di edi nello stack

    cmpl %ecx, %edx ; Confronta low con high
    jge end_quick_sort ; Salta alla fine se low >= high

    movl (%eax, %edx, 4), %ebx ; Carica il valore di arr[high] in ebx
    movl %ebx, pivot ; Salva il valore di arr[high] in pivot

    movl %ecx, %esi ; Salva il valore di low - 1 in esi
    subl $1, %esi   ; Sottrae 1 da esi
    movl %esi, i    ; Salva il valore di esi in i

    movl %ecx, %edi ; Salva il valore di low in edi

partition_loop:
    cmpl %edx, %edi ; Confronta j con high
    jge end_partition_loop ; Salta alla fine del loop se j >= high

    movl (%eax, %edi, 4), %ebx ; Carica il valore di arr[j] in ebx
    cmpl pivot, %ebx ; Confronta pivot con ebx
    jg skip_swap ; Salta allo step successivo se pivot > ebx

    addl $1, i ; Incrementa i di 1
    movl i, %esi ; Salva il valore di i in esi
    movl (%eax, %esi, 4), %ebx ; Carica il valore di arr[i] in ebx
    movl (%eax, %edi, 4), %ecx ; Carica il valore di arr[j] in ecx
    movl %ecx, (%eax, %esi, 4) ; Salva il valore di arr[j] in arr[i]
    movl %ebx, (%eax, %edi, 4) ; Salva il valore di arr[i] in arr[j]

skip_swap:
    addl $1, %edi ; Incrementa j di 1
    jmp partition_loop ; Salta all'inizio del loop

end_partition_loop:
    addl $1, i ; Incrementa i di 1
    movl i, %esi ; Salva il valore di i in esi
    movl (%eax, %esi, 4), %ebx ; Carica il valore di arr[i] in ebx
    movl (%eax, %edx, 4), %ecx ; Carica il valore di arr[high] in ecx
    movl %ecx, (%eax, %esi, 4) ; Salva il valore di arr[high] in arr[i]
    movl %ebx, (%eax, %edx, 4) ; Salva il valore di arr[i] in arr[high]

    movl i, pindex ; Salva il valore di i in pindex

    movl %eax, %ebx ; Salva il valore di arr in ebx
    movl %ecx, %ecx ; Salva il valore di high in ecx
    movl pindex, %edx ; Salva il valore di pindex in edx
    subl $1, %edx ; Sottrae 1 da edx
    call QuickSort ; Chiama QuickSort ricorsivamente

    movl %eax, %ebx ; Salva il valore di arr in ebx
    movl pindex, %ecx ; Salva il valore di pindex in ecx
    addl $1, %ecx ; Incrementa ecx di 1
    movl high, %edx ; Salva il valore di high in edx
    call QuickSort ; Chiama QuickSort ricorsivamente

end_quick_sort:
    popl %edi ; Ripristina il valore di edi dallo stack
    popl %esi ; Ripristina il valore di esi dallo stack
    popl %ebx ; Ripristina il valore di ebx dallo stack
    movl %ebp, %esp ; Ripristina il valore di esp da ebp
    popl %ebp ; Ripristina il valore di ebp dallo stack
    ret ; Ritorna dalla funzione
