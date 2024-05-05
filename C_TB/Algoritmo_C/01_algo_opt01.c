#include <stdio.h>
#include <stdlib.h>

#define FNMAX 64 // lunghezza massima del nome del file



typedef struct
{
    int id;
    int durata;
    int scadenza;
    int priorità;
    int ordinamento;
} Prodotto;

// 01 Prototipi delle funzioni
void OrdinaEDF(Prodotto ArrayProd[], int nProd);
void OrdinaHPF(Prodotto ArrayProd[], int nProd);

int main()
{
    // 00 Variabili --------------------------------------------
    FILE *file;
    char fileName[FNMAX];
    int scelta;

    printf("Scegli l'ordinamento:\n");
    printf("0 - EDF (Earliest deadline first) \n");
    printf("1 - HPF (Highest priority first) \n");
    scanf("%d", &scelta);


    // 01 apertura dati -----------------------------------------

    printf("Inserisci il nome del file: ");
    scanf("%s", fileName);
    file = fopen(fileName, "r");

    // controllo fopen
        if (file == NULL)
        {
            printf("Errore nell'apertura del file\n");
            return 1;
        }

    // 02 lettura dati -----------------------------------------

        // conto le RIGHE del file -> nProd
        int linecounter = 0;
        char temp;
        Prodotto ArrayProd[100];
        int i = 0;
        while (!feof(file))
        {

            fscanf(file, "%d,%d,%d,%d", &ArrayProd[i].id, &ArrayProd[i].durata, &ArrayProd[i].scadenza, &ArrayProd[i].priorità);
            ++i;
            temp = fgetc(file);
            if (temp == '\n')
            {
                linecounter++;
            }
        }

    // 03 ordinamento -----------------------------------------
    
    if (scelta == 0) {
        OrdinaEDF(ArrayProd, linecounter);
        } 
    else if (scelta == 1){
        OrdinaHPF(ArrayProd, linecounter);
        }

    // stampa dell'array di struct prodotto in maniera ordinata secondo ordinamento:
    printf("ID\tDurata\tScadenza\tPriorità\n");
    for (int i = 0; i < linecounter; i++)
    {
        printf("%d\t%d\t%d\t\t%d\n", ArrayProd[i].id, ArrayProd[i].durata, ArrayProd[i].scadenza, ArrayProd[i].priorità);
    }
    // 0x chiusura del file ----------------------------------
    fclose(file);

    // stampa dell'array di struct prodotto in maniera ordinata su file (output.txt):
    FILE *file2;
    file2 = fopen("output.txt", "w");
    fprintf(file2, "ID\tDurata\tScadenza\tPriorità\n");
    for (int i = 0; i < linecounter; i++)
    {
        fprintf(file2, "%d\t%d\t%d\t%d\n", ArrayProd[i].id, ArrayProd[i].durata, ArrayProd[i].scadenza, ArrayProd[i].priorità);
    }
    // 0x chiusura dei filesss ----------------------------------
    fclose(file2);
    fclose(file);

    // visualizzo previsione linea di produzione ed eventuali penlities
    int penalty_total = 0;
    int timeSlot_enlapsed = 0;

    for (int k = 0; k < linecounter; k++){
        timeSlot_enlapsed += ArrayProd[k].durata;
        if (timeSlot_enlapsed > ArrayProd[k].scadenza){
            penalty_total += (timeSlot_enlapsed - ArrayProd[k].scadenza)*ArrayProd[k].priorità;
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