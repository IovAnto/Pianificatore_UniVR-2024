.section .data

i: .int 0
j: .int 0
key: .int 0

.section .text
.globl insertionSort

.section .text
.global InsertionSort
.type InsertionSort, @function

InsertionSort:


#   len in EBX
#   pointer in EAX
movl $1, i  # i = 1


forLoop:

    movl i, %esi            # key = arr[i] -> arr[ESI]

    cmpl %esi, %ebx         # i < n
    jl endForLoop           # se i >= n, esci dal ciclo for
    
    movl i, %ecx            # j = i -> ECX
    dec %ecx                # j = i-1
    movl %ecx, j            # -> j = i-1

    # in ecx c'è j
    

    # muovi arr[3+(4*i)] in 8bit di DL (INT) -> DL = arr[i]
    movb 3(%eax, %esi, 4), %dl  # key => %dl
    movb %dl, key              # key <= arr[j]

    # preparato ciclo while...
        # while (j >= 0 && arr[j] > key) {
        
        #    arr[j + 1] = arr[j]
        #    j = j - 1
        
        while:
            
            cmpl $0, %ecx                 # j >= 0 -> 0 > j
            jg endWhile                     
    
            cmpb 3(%eax, %ecx, 4), %dl      # arr[j] > key
            jle endWhile                    # se arr[j] <= key, esci dal ciclo while


            #    arr[j + 1] = arr[j]
            #    muovi arr[j] in arr[j+1]
            movl (%eax, %ecx, 4), %edx     # muovi arr[j] in EDX (4 byte!) || (%eax, %ecx, 4) = (*array + (ecx*4))
            inc %ecx                        # ecx = j + 1
            movl %edx, (%eax, %ecx, 4)     # muovi arr[j] in arr[j+1] (4 byte!) || (%eax, %ecx, 4) = (*array + (ecx*4))
            
            dec %ecx                        # decremento j
            dec %ecx                        # decremento j

            movl %ecx, j                    # j <= j - 1
            
            jmp while                       # torna all'inizio del ciclo while
    
    endWhile: 
            # arr[j + 1] = key; 
            # muovi key in arr[3+(4*(j+1))] 
            
            inc %ecx                        # j = j + 1
            movl key, %edx     # Move the value of key into register EDX
            movb %dl, 3(%eax, %ecx, 4)     # arr[j+1] <= key

            movl i, %esi
            inc %esi                        # i = i + 1 
            movl %esi, i                    # i <= i + 1
            
            jmp forLoop                     # torna all'inizio del ciclo for
               
endForLoop:

ret                                 # fine funzione

