
.section .data
# eax = pointer
# ebx = len

pointer: .int 0
high: .int 0
low: .int 0
len: .int 0
pivot: .int 0 # forse non serve
i: .int 0
j: .int 0
pindex: .int 0

.section .text
.global QuickSort
.type QuickSort, @function

# Funzione QuickSort(arr, low, high)

# arr = EAX
# low = ECX
# high = EDX

movl %ebx, len      # len = high
movl $0 , %ecx
xorl %edx, %edx
addl %ebx, %edx     # high = len

movl %eax, pointer  # pointer array
movl %ecx, low      # low
movl %edx, high     # high


QuickSort:
    # if low < high     
    # cmpl low, high
    cmpl %ecx, %edx
    # se low >= high
    jge end                         # esco
    # oppure... :
        # pivot = arr[high] -> pivot = arr[3+(high*4)] ---- SALVO PIVOT IN VARIABILE 'PIVOT'
        movl 3(%eax, %edx, 4), %ebx
        movl %ebx, pivot
        # i = low - 1   ---- DECREMENTO I .. di 1.. cioè 4 per noi
        movl low, %esi      # low in esi
        subl $4, %esi       # sottraggo 4
        movl %esi, i        # i = low - 4 (= -1)
        # j = low
        movl low, esi       # low in esi
        movl %esi, j # pozor! ho messo j in esi!

        # scorro array da array[j] ad array[high-1]
        # quindi da array[j+3] ad array[high-1+3]
            # confronto array[j] con pivot
                                                                        # esi = j
                                                                        # ebx = pivot
            # comparo pointerarray3+[j*4] con pivot
            cmpl 3(%eax, %esi, 4), %ebx
            # se array[j] <= pivot
                # incrementa i
                # scambia array[i] con array[j]
            # se no salta a forBack
            jg forBack

            # incrementa i
            addl $4, i
            # scambia array[i] con array[j]
            movl i, %edi       # i in edi
                # Carica array[i] in %ebx
                movl 3(%eax, %edi, 4), %ebx
                # Carica array[j] in %ecx
                movl 3(%eax, %esi, 4), %ecx
                # Salva array[j] in array[i]
                movl %ecx, 3(%eax, %edi, 4)
                # Salva array[i] in array[j]
                movl %ebx, 3(%eax, %esi, 4)




        forBack:
        # Incrementa temporaneamente i
        movl i, %esi      # Memorizza temporaneamente l'indice i in %esi
        addl $4, %esi     # Incrementa %esi di 4 per ottenere l'indice di arr[i + 1]

        # Scambio di arr[i + 1] con arr[high] (il pivot)
        movl (%eax, %esi, 4), %ebx   # Carica arr[i + 1] in %ebx
        movl (%eax, %edx, 4), %ecx   # Carica il pivot (arr[high]) in %ecx
        movl %ecx, (%eax, %esi, 4)   # Salva il pivot in arr[i + 1]
        movl %ebx, (%eax, %edx, 4)   # Salva arr[i + 1] in arr[high]

        # Restituisce l'indice del pivot (i + 1)
        movl %esi, %eax   # Carica l'indice di arr[i + 1] in %eax
        addl $4, %eax     # Incrementa %eax di 4 per ottenere l'indice del pivot (i + 1)

        # !!! in eax c'e' l'INDICE del pivot  !!!

        movl %eax, pindex

        # Ricorsione per le due partizioni
        #         QuickSort(arr, low, pi - 1)
        #         QuickSort(arr, low, pi - 1)

        # QuickSort(arr, low, pi - 1)
        movl pointer, %eax
        movl low, %ecx
        movl pindex, %edx
        subl $4, %edx
        call QuickSort

        # QuickSort(arr, pi + 1, high)
        movl pointer, %eax
        movl pindex, %ecx
        addl $4, %ecx
        movl high, %edx
        call QuickSort

        

        # ! quicksort(eax, ecx, edx) !
 
end:

    ret
