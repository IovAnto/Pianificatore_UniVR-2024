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

/* TODO:

Una volta pianificati i task, il software dovrà stampare a video:
1. L’ordine dei prodotti, specificando per ciascun prodotto l’unità di tempo in cui è pianificato
l’inizio della produzione del prodotto. Per ogni prodotto, dovrà essere stampata una riga con la
seguente sintassi:
ID:Inizio
Dove ID è l’identificativo del prodotto, ed Inizio è l’unità di tempo in cui inizia la produzione.
2. L’unità di tempo in cui è prevista la conclusione della produzione dell’ultimo prodotto pianificato.
3. La somma di tutte le penalità dovute a ritardi di produzione.
Dunque, nell’esempio precedente, se si utilizzasse l’algoritmo EDF, l’output atteso sarà:
Pianificazione EDF:
4:0
12:10
Conclusione: 17
Penalty: 0
Mentre, se si fosse usato l’algoritmo HPF:
Pianificazione HPF:
12:0
4:17
Conclusione: 17
Penalty: 20
In quanto nel primo caso non ci sarebbero penalità, mentre nel secondo caso il prodotto con ID 4
terminerebbe con 5 unità di tempo di ritardo, da moltiplicare per il valore di priorità 4.
L’output del programma dovrà avere la sintassi riportata sopra.
Una volta stampate a video le statistiche, il programma tornerà al menù iniziale in cui chiede all’utente
se vuole pianificare la produzione utilizzando uno dei due algoritmi.
Bonus (facoltativo): se l’utente inserisce due file come parametri da linea di comando, il file
specificato come secondo parametro verrà utilizzato per salvare i risultati della pianificazione, indicando
l’algoritmo usato. Ad esempio:
pianificatore Ordini.txt Pianificazione.txt
Il programma carica gli ordini dal file Ordini.txt e salva le statistiche stampate a video nel file
Pianificazione.txt.
Nel caso l’utente inserisca un solo parametro, la stampa su file sarà ignorata.

*/