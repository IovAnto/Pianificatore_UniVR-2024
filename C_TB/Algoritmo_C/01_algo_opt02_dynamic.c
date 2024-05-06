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
void OrdinaEDF(Prodotto ArrayProd[], int nProd); //EDF - riordina array in ordine di scadenza
void OrdinaHPF(Prodotto ArrayProd[], int nProd); //HPF - riodina array in priorità decrescente
void StampaVideo(Prodotto ArrayProd[], int nProd, int scelta); // Stampa a video l'ordine dei prodotti secondo le specifiche

int main()
{
    // Variabili
    FILE *file;
    char fileName[FNMAX];
    int scelta;


    // Apertura dati
    printf("Inserisci il nome del file: \t");
    scanf("%s", fileName);
    file = fopen(fileName, "r");

    if (file == NULL)
    {
        printf("Errore nell'apertura del file\n\n\n");
        return 1;
    }

    printf("Scegli l'ordinamento:\n0 - EDF (Earliest deadline first)\n1 - HPF (Highest priority first)\n\n");
    scanf("%d", &scelta);

    if (scelta != 0 && scelta != 1) {
        printf("Opzione di ordinamento non valida\n");
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
    } else {
        printf("Errore nella selezione dell'ordinamento\n");
        return 1;
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

    StampaVideo(ArrayProd, linecounter, scelta);

    
    return 0;
}

void OrdinaEDF(Prodotto ArrayProd[], int nProd){  // in ordine di scadenza - A parità di scadenza, ordina per priorità e ordine di lettura
    Prodotto temp;
    for (int i = 0; i < nProd - 1; i++){
        for (int j = 0; j < nProd - i - 1; j++){
            if (ArrayProd[j].scadenza > ArrayProd[j+1].scadenza || (ArrayProd[j].scadenza == ArrayProd[j+1].scadenza && ArrayProd[j].priorità < ArrayProd[j+1].priorità)){
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
            if (ArrayProd[j].priorità < ArrayProd[j+1].priorità || (ArrayProd[j].priorità == ArrayProd[j+1].priorità && ArrayProd[j].scadenza > ArrayProd[j+1].scadenza)){
                temp = ArrayProd[j];
                ArrayProd[j] = ArrayProd[j+1];
                ArrayProd[j+1] = temp;
            }
        }
    }
}

void StampaVideo(Prodotto ArrayProd[], int nProd, int scelta){
    // stampo i prodotti secondo l'ordine scelto
        // 1 Stampo il nome dell'algoritmo scelto ("Pianificazione EDF:\n oppure Pianificazione HPF:\n")
        // 2 stampo in ordine secono la sintassi: ID:Inizio(timeslot)
        // 3 stampo l'unità di tempo in cui è prevista la conclusione della produzione dell'ultimo prodotto pianificato
        // 4 stampo la somma di tutte le penalità dovute a ritardi di produzione

    // Variabili
    int timeSlot_enlapsed = 0;
    int penalty_total = 0;

    //1 
    if (scelta == 0){
        printf("Pianificazione EDF:\n");
    } else {
        printf("Pianificazione HPF:\n");
    }

    //2 (+ calcolo sequenziale pnalità)

    for (int i = 0; i < nProd; i++){
        printf("%d:%d\tsarebbe scaduto al ts %d\n", ArrayProd[i].id, timeSlot_enlapsed, ArrayProd[i].scadenza);
        timeSlot_enlapsed += ArrayProd[i].durata;
        if (timeSlot_enlapsed > ArrayProd[i].scadenza){
            printf("penalità !!!\n");
             penalty_total += (timeSlot_enlapsed - ArrayProd[i].scadenza)*ArrayProd[i].priorità;
        }
    }

    //3 
    printf("Conclusione: %d\n", timeSlot_enlapsed);

    //4 
    printf("Penalty: %d\n", penalty_total);
}

/* TODO:


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