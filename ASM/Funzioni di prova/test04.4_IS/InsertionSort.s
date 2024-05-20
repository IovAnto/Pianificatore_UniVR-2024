.section .data

i: .int 0
j: .int 0
key: .int 0

.section .text
.globl insertionSort

.section .text
.global InsertionSort
.type InsertionSort, @function

pop %ebx    # array len da stack in EBX
pop %eax    # array starting pointer da stack in EAX
movl $1, i  # i = 1
    
forLoop:
    
    cmpl i, %ebx            # i < n
    jge endForLoop          # se i >= n, esci dal ciclo for
    
    movl i, %ecx            # j = i -> ECX
    addl $-1, %ecx          # j = i-1
    movl %ecx, j            # -> j = i-1
    
    movl i, %esi            # key = arr[i] -> arr[ESI]

    # muovi arr[3+(4*j)] in 8bit di DL (INT) -> DL = arr[j]
    movb 3(%eax, %esi, 4), %dl  # key => %dl
    movb %edx, key              # key <= arr[j]

    # preparato ciclo while...
        
        while:
            
            cmpl %esi, $0                   # j >= 0
            jl endWhile                     # se j < 0, esci dal ciclo while
    
            cmpb 3(%eax, 4, %esi), %dl      # arr[j] > key
            jle endWhile                    # se arr[j] <= key, esci dal ciclo while
            
            dec %ecx                        # decremento j
            movl %ecx, j                    # j <= j - 1
            
            jmp while                       # torna all'inizio del ciclo while
    
    endWhile: 
            # arr[j + 1] = key; 
            # muovi key in arr[3+(4*(j+1))] 
            
            inc %ecx                        # j = j + 1
            movl %edx, 3(%eax, 4, %ecx)     # arr[j] <= key
            
            # i++
            inc %esi                        # i = i + 1 
            movl %esi, i                    # i <= i + 1
            
            jmp forLoop                     # torna all'inizio del ciclo for
               
    emdForLoop:
        
        ret                                 # fine funzione
    