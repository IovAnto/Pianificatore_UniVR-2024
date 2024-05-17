.section .data


pointer: .int 0
high: .int 0
low: .int 0
pivot: .int 0 # forse non serve


.section .text
.global QuickSort
.type QuickSort, @function

QuickSort:


#   {  //arg= puntatore ad array, low=indice iniziale, high=indice finale
#       if (low < high) {                           //se l'indice iniziale è minore di quello finale
#           int pi = partition(arr, low, high);     //pi è l'indice del pivot (partiziona l'array e restituisce l'indice del pivot)
#           quickSort(arr, low, pi - 1);            //ricorsione per la parte sinistra dell'array
#           quickSort(arr, pi + 1, high);           //ricorsione per la parte destra dell'array
#       }
#   }
    
    # mi preparo low e high e il puntatore ad array:
    movl %esi, pointer
    movl %ebx, low
    movl %edi, high
    
    # comparo low < high
    cmpl %edi, %ebx
    jge end

    # chiamo partition per trovare il pivot e lo salvo
        call partition  # il pivot è in %dl

        movl %eax, pivot


        movl pointer, %esi
        movl low, %ebx
        movl pivot, %edi
        addl $-4, %edi

        call QuickSort

        movl %eax, pivot

        movl pointer, %esi
        movl pivot, %ebx
        movl high, %edi
        addl $4, %ebx
        
        call QuickSort

    # chiamo ricorsivamente QuickSort per la parte sinistra dell'array
    # preparo regitstri con gli argomenti giusti:
    # puntatore ad array
    # puntatore a array[low]
    # puntatore a array[pivot-1]

    
    #ricorsivo

    call QuickSort


end:

    ret
