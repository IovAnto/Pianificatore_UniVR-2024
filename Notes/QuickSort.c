#include <stdio.h>

void quickSort(int arr[], int low, int high);
int partition(int arr[], int low, int high);
void swap(int* a, int* b);

int main() {
    int arr[] = {10, 7, 8, 9, 1, 5};
    int n = sizeof(arr) / sizeof(arr[0]);
    quickSort(arr, 0, n - 1);
    printf("Sorted array: \n");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    return 0;
}

void quickSort(int arr[], int low, int high) {  //arg= puntatore ad array, low=indice iniziale, high=indice finale
    if (low < high) {                           //se l'indice iniziale è minore di quello finale
        int pi = partition(arr, low, high);     //pi è l'indice del pivot (partiziona l'array e restituisce l'indice del pivot)
        quickSort(arr, low, pi - 1);            //ricorsione per la parte sinistra dell'array
        quickSort(arr, pi + 1, high);           //ricorsione per la parte destra dell'array
    }
}

int partition(int arr[], int low, int high) {   //arg= puntatore ad array, low=indice iniziale, high=indice finale
    int pivot = arr[high];                      //pivot è l'ultimo elemento dell'array
    int i = (low - 1);                          //indice iniziale -1
    for (int j = low; j <= high - 1; j++) {     //ciclo per scorrere l'array da low a high-1 
        if (arr[j] <= pivot) {                  //se l'elemento è minore o uguale al pivot (il pivot è l'ultimo elemento dell'array partizionato)
            i++;                                //incrementa l'indice iniziale
            swap(&arr[i], &arr[j]);             //scambia elemtno in posizione i con elemento in posizione j (dove j= indice del ciclo for)
        }
    }
    swap(&arr[i + 1], &arr[high]);            //fuori dal for -> scambia elemento in posizione i+1 con elemento in posizione high
    return (i + 1);                             //restituisce indice i aumentato di 1
}

void swap(int* a, int* b) {                     // swappino basic
    int t = *a;
    *a = *b;
    *b = t;
}
