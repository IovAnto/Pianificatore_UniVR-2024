#include <stdio.h>
#include <stdlib.h>


typedef struct
{
    int id;
    int durata;
    int scadenza;
    int priorità;
} Prodotto;


int main()
{

    // 00 Variabili --------------------------------------------
    FILE *file;
    char fileName[100];

    Prodotto ArrayProd[100] = {0}; //array di struct prodotto


    // 01 apertura dati -----------------------------------------

    printf("Inserisci il nome del file: ");
    scanf("%s", fileName);
    file = fopen(fileName, "r");

        if (file == NULL)
        {
            printf("Errore nell'apertura del file\n");
            return 1;
        }

    // 02 lettura dati -----------------------------------------

        // conto le RIGHE del file -> nProd
        int nProd = 0;
        char temp;
        while (!feof(file))
        {
            temp = fgetc(file);
            if (temp == '\n')
            {
                nProd++;
            }
        }

        // acquisisco i dati del file (esculdendo il carattere ',')
        rewind(file);
        for (int i = 0; i < nProd; i++)
        {
            fscanf(file, "%d,%d,%d,%d\n", &ArrayProd[i].id, &ArrayProd[i].durata, &ArrayProd[i].scadenza, &ArrayProd[i].priorità);
        }


    // stampa dell'array di struct prodotto in maniera ordinata:
    printf("ID\tDurata\tScadenza\tPriorità\n");
    for (int i = 0; i < nProd; i++)
    {
        printf("%d\t%d\t%d\t%d\n", ArrayProd[i].id, ArrayProd[i].durata, ArrayProd[i].scadenza, ArrayProd[i].priorità);
    }

    // 0x chiusura del file ------------------------------------
    fclose(file);

    return 0;
}
