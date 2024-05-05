#include <stdio.h>
#include <stdlib.h>

#define FNMAX 64 // Lunghezza massima del nome del file
#define INITIAL_CAPACITY 10 // Capacità iniziale dell'array di prodotti

typedef struct
{
    int id;
    int durata;
    int scadenza;
    int priorità;
    int ordinamento;
} Prodotto;

// Prototipi delle funzioni
void OrdinaEDF(Prodotto ArrayProd[], int nProd);
void OrdinaHPF(Prodotto ArrayProd[], int nProd);

int main()
{
    // Variabili
    FILE *file;
    char fileName[FNMAX];
    int scelta;

    printf("Scegli l'ordinamento:\n0 - EDF (Earliest deadline first)\n1 - HPF (Highest priority first)\n");
    scanf("%d", &scelta);

    if (scelta != 0 && scelta != 1) {
        printf("Opzione di ordinamento non valida\n");
        return 1;
    }

    // Apertura dati
    printf("Inserisci il nome del file: ");
    scanf("%s", fileName);
    file = fopen(fileName, "r");

    if (file == NULL)
    {
        printf("Errore nell'apertura del file\n");
        return 1;
    }

    // Lettura dati

    // Inizializza un array di prodotti con una capacità iniziale
    Prodotto *ArrayProd = malloc(INITIAL_CAPACITY * sizeof(Prodotto));
    int capacity = INITIAL_CAPACITY;
    int linecounter = 0;

    // Controlla se l'allocazione di memoria è riuscita
    if (ArrayProd == NULL) {
        printf("Errore nell'allocazione di memoria\n");
        return 1;
    }

    // Legge i prodotti dal file e li memorizza nell'array
    while (fscanf(file, "%d,%d,%d,%d", &ArrayProd[linecounter].id, &ArrayProd[linecounter].durata, &ArrayProd[linecounter].scadenza, &ArrayProd[linecounter].priorità) == 4) {
        linecounter++;

        // Se l'array è pieno, rialloca la memoria per aumentare la capacità
        if (linecounter >= capacity) {
            capacity *= 2; // Raddoppia la capacità
            ArrayProd = realloc(ArrayProd, capacity * sizeof(Prodotto));
            if (ArrayProd == NULL) {
                printf("!!! successo un casino nel riallocare la memoria\n");
                return 1;
            }
        }
    }

    // chiudo file
    fclose(file);

    // Ordinamento
    if (scelta == 0)
    {
        OrdinaEDF(ArrayProd, linecounter);
    }
    else if (scelta == 1)
    {
        OrdinaHPF(ArrayProd, linecounter);
    }

    // Stampa su console
    printf("ID\tDurata\tScadenza\tPriorità\n");
    for (int i = 0; i < linecounter; i++)
    {
        printf("%d\t%d\t%d\t\t%d\n", ArrayProd[i].id, ArrayProd[i].durata, ArrayProd[i].scadenza, ArrayProd[i].priorità);
    }

    // Stampa su file
    FILE *file2;
    file2 = fopen("output.txt", "w");
    if (file2 == NULL)
    {
        printf("Errore nell'apertura del file di output\n");
        return 1;
    }
    fprintf(file2, "ID\tDurata\tScadenza\tPriorità\n");
    for (int i = 0; i < linecounter; i++)
    {
        fprintf(file2, "%d\t%d\t%d\t%d\n", ArrayProd[i].id, ArrayProd[i].durata, ArrayProd[i].scadenza, ArrayProd[i].priorità);
    }
    fclose(file2);

    // Visualizzazione previsione linea di produzione ed eventuali penalties
    int penalty_total = 0;
    int timeSlot_enlapsed = 0;

    for (int k = 0; k < linecounter; k++)
    {
        timeSlot_enlapsed += ArrayProd[k].durata;
        if (timeSlot_enlapsed > ArrayProd[k].scadenza)
        {
            penalty_total += (timeSlot_enlapsed - ArrayProd[k].scadenza) * ArrayProd[k].priorità;
        }
        printf("%d\tID produzione: %d\tTTrascorso: %d\tScadenza: %d \tPenalty: %d\n", k, ArrayProd[k].id, timeSlot_enlapsed, ArrayProd[k].scadenza, penalty_total);
    }

    return 0;
}

void OrdinaEDF(Prodotto ArrayProd[], int nProd){  // in ordine di scadenza
    Prodotto temp;
    for (int i = 0; i < nProd - 1; i++){
        for (int j = 0; j < nProd - i - 1; j++){
            if (ArrayProd[j].scadenza > ArrayProd[j+1].scadenza){
                temp = ArrayProd[j];
                ArrayProd[j] = ArrayProd[j+1];
                ArrayProd[j+1] = temp;
            }
        }
    }
}

void OrdinaHPF(Prodotto ArrayProd[], int nProd){ //priorità decrescente
    Prodotto temp;
    for (int i = 0; i < nProd - 1; i++){
        for (int j = 0; j < nProd - i - 1; j++){
            if (ArrayProd[j].priorità < ArrayProd[j+1].priorità){
                temp = ArrayProd[j];
                ArrayProd[j] = ArrayProd[j+1];
                ArrayProd[j+1] = temp;
            }
        }
    }
}