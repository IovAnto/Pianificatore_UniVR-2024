# Software di Pianificazione della Produzione

## Abstract
Questo progetto prevede lo sviluppo di un software per gestire la pianificazione di 127 prodotti differenti, ciascuno con caratteristiche uniche, su 100 slot temporali consecutivi dopo il lancio dell'applicativo. La pianificazione verrà gestita utilizzando due specifici algoritmi di ordinamento: **Earliest Deadline First (EDF)** e **Highest Priority First (HPF)**.

## Obiettivi
- **Pianificazione della Produzione**: Allocare la produzione su 100 slot temporali utilizzando gli algoritmi EDF e HPF.
- **Calcolo delle Penalità**: Calcolare le penalità basate sui ritardi e sulla priorità.
- **Tempo di Conclusione**: Visualizzare il tempo complessivo di conclusione.
- **Gestione degli Output**: Salvare i risultati su un file (input da bash).

## Specifiche di Input
Il software accetta un file di testo in formato CSV con il seguente formato:

ID, Durata, Scadenza, Priorità
1-127, Numero di slot per produrre 1 unità, Scadenza nella timeline (1-100), Priorità (1-5)

- **ID**: Identificativo unico per ciascun prodotto (1-127).
- **Durata**: Numero di slot temporali necessari per produrre un'unità.
- **Scadenza**: Slot temporale entro cui la produzione deve essere completata (1-100).
- **Priorità**: Livello di urgenza del prodotto (1 = meno urgente, 5 = massima urgenza).

## Struttura del Programma
1. **Avvio**
2. **Selezione dell'Algoritmo**: Scelta dell'algoritmo di ordinamento (EDF/HPF).
3. **Visualizzazione Output**: Stampa dei risultati a video.

## Esempio di Output
Per la pianificazione EDF:
4:0
12:10
Conclusione: 17
Penalità: 0


## Calcolo delle Penalità
Le penalità sono calcolate utilizzando la formula: \n
Penalità = Ritardo * Priorità


## Struttura della Directory del Progetto
VRXXXXXX_VRXXXXXX                                                               
├── src/                                                                        
├── obj/ (vuota)                                                                
├── bin/ (vuota)                                                                
├── Makefile                                                                    
├── Ordini/                                                                     
│ ├── EDF.txt                                                                   
│ ├── HPF.txt                                                                   
│ ├── Both.txt                                                                  
│ └── None.txt                                                                  
└── Relazione.pdf                                                               


## Lista delle Cose da Fare (TODO)
### Completato
- [X] C → In lavorazione
- [X] Scheletro ASM
- [X] Definizione dei Registri
  - [X] Numero di parole per informazione
  - [X] Numero di registri necessari
- [X] Definizione dell'Algoritmo di Ordinamento
- [X] Scrittura dei Test
- [X] Scrittura del File ASM
- [X] Versione Iniziale (V1)
- [X] Interfaccia Grafica (GUI)

### In sospeso
- [ ] Controllo del File prima del lancio
- [ ] Risoluzione dei Bug relativi al Tempo

---

