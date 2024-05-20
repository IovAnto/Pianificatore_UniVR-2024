// C program for insertion sort
#include <math.h>
#include <stdio.h>

// i: int. 0
// j: int. 0
// key: int. 0
// push array poinyer
// push array len

/* Function to sort an array using insertion sort*/
void insertionSort(int arr[], int n) // passiamo array e len
{
    int i, key, j; // i, j, pivot
    
// pop %ebx # array len
// pop %eax # array starting pointer 
    movl $1, i
    
    loop:
    
    cmpl i, %ebx
    jge endForLoop
    
        movl i, %ecx
        addl $-1, %ecx
        movl %ecx, j     # j = i-1
        
        movl i, %esi
        movb 3(%eax, 4, %esi), %edx  ??!!!! byte! non mi ricordo 
        movb %edx, key
        
        while:
            
            cmpl %esi, $0
            jl endWhile
    
            cmpb 3(%eax, 4, %esi), %edx !!--------
            jle endWhile
            
            dec %ecx
            movl %ecx, j
            
            jmp while
    
    endWhile: 
            # arr[j + 1] = key;
            
            inc %ecx
            movl %edx, 3(%eax, 4, %ecx)
            
            #i++ 
            inc %esi
            movl %esi, i
            
            jmp loop
               
    emdForLoop:
    
        # fatto? boh 
        
        ret
    
    
    for (i = 1; i < n; i++) { //i che va da 1 ad len)
        key = arr[i]; // pivot = arr[i]
        j = i - 1; 

        /* Move elements of arr[0..i-1], that are
          greater than key, to one position ahead
          of their current position */
        
     // while con doppio controllo
        // j >= 0
        // arr[j] > key 
        
        
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        
        
        arr[j + 1] = key;
    }
}

// A utility function to print an array of size n
void printArray(int arr[], int n)
{
    int i;
    for (i = 0; i < n; i++)
        printf("%d ", arr[i]);
    printf("\n");
}

/* Driver program to test insertion sort */
int main()
{
    int arr[] = { 12, 11, 13, 5, 6 };
    int n = sizeof(arr) / sizeof(arr[0]);

    insertionSort(arr, n);
    printArray(arr, n);

    return 0;
}
