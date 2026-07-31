# Pianificatore della produzione

Elaborato del corso di Architettura degli Elaboratori, Università di Verona, 2024.

Il programma pianifica la produzione di 127 prodotti su 100 slot temporali, con due
politiche di ordinamento: Earliest Deadline First e Highest Priority First. Per ogni
pianificazione calcola il tempo di conclusione e la penalità totale. È scritto in
assembly x86 (sintassi NASM), con una parte di prototipazione in C nella cartella `Notes`.

La penalità di un prodotto è `ritardo × priorità`; la penalità complessiva è la loro somma.

## Input

Un file di testo, una riga per prodotto:

```
ID, Durata, Scadenza, Priorità
```

| Campo | Valori |
|---|---|
| ID | 1–127 |
| Durata | slot necessari a produrre un'unità |
| Scadenza | slot entro cui concludere, 1–100 |
| Priorità | 1 (meno urgente) – 5 (massima urgenza) |

In `ASM/Datasets` ci sono i dataset di prova, più `datasetmaker.py` per generarne altri.

## Output

```
4:0
12:10
Conclusione: 17
Penalità: 0
```

Ogni riga è `ID:slot di inizio`. Le ultime due righe danno il tempo di conclusione e la
penalità della pianificazione.

## Struttura

```
ASM/
├── Pianificatore v1.2/     sorgenti, Makefile e ordini generati
└── Datasets/               dataset di prova e generatore
Notes/                      prototipi in C, appunti su gdb e salti condizionali
Relazione/                  relazione in LaTeX, con i sorgenti e il PDF
```

## Stato

L'ordinamento, il calcolo delle penalità, i test e l'interfaccia sono completi. Restano
aperti il controllo di validità del file prima dell'avvio e un bug sul calcolo dei tempi
con i dataset lunghi (`ASM/Datasets/05_BUG_LONG`).

## Autori

Antonio Iovine e Tommi Bimbato.
