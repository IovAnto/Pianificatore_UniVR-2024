# Elaborato_Assembly2024

## Abstract

Questo progetto sviluppa un software per gestire la pianificazione di 127 possibili prodotti, ciascuno con caratteristiche diverse, distribuiti in 100 slot temporali successivi al lancio dell'applicativo.

## Obiettivi

- Pianificare la produzione in 100 slot temporali utilizzando i seguenti algoritmi di ordinamento:
  - EDF (Earliest Deadline First)
  - HPF (Highest Priority First)
- Calcolare la penalità
- Visualizzare il tempo di conclusione
- Salvare gli output su file (input da bash)

## Input

Il software accetta un file di testo in stile "csv" con il seguente formato:

ID, Durata, Scadenza, Priorità
1-127, n. slot temporali per produrre 1 unità, scadenza nella timeline: 1-100, 1-5 : 1 meno urgente, 5 massima priorità

## Struttura del Programma

Start → Selezione dell’algoritmo di ordinamento (EDF/HPF) → Stampa a video

## Esempio di Output

### Pianificazione EDF

4:0
12:10
Conclusione: 17
Penalty: 0

### Task

- Calcolare la penalità: `Ritardo * Priorità = X$`

## Struttura del Progetto

VRXXXXXX_VRXXXXXX/
├── src/
├── obj/ (vuota)
├── bin/ (vuota)
├── Makefile
├── Ordini/
│   ├── EDF.txt
│   ├── HPF.txt
│   ├── Both.txt
│   └── None.txt
└── Relazione.pdf

## TODO

- [X] C → WIP
- [X] Scheletro ASM
- [X] Definizione REG
  - [X] Numero di parole per informazione
  - [X] Numero di registri necessari
- [X] Definizione algoritmo di sorting
- [X] Scrittura dei test
- [X] Stesura del file ASM
- [X] Testing (GPT?)
- [X] V1
- [X] GUI
- [ ] Controllo file pre lancio
- [ ] Risoluzione bug del tempo

## Licenza

Questo progetto è distribuito sotto la licenza Creative Commons Attribution 4.0. Per ulteriori dettagli, vedere [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

## Crediti

Progetto sviluppato da Tommi Bimbato e Antonio Iovine.