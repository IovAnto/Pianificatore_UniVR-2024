# Elaborato_Assembly2024

# Abstract:

Programmare un software per la pianificazione di 127 possibili prodotti secondo caratteristiche diverse nei successi 100 slot temporali dal lancio dell'applicativo.

### Obbiettivo:

- Ordinare la produzione in 100 slot temporali secondo:
   - EDF (erliest deadline first)
   - HPF (highest priority first)
   - Calcolare *penality*
   - Visualizzare tempo conclusione
- Salva su file gli output (input da bash)

----

### Input

- file di testo "csv" style:

| **ID,** | **Durata,**                            | **Scadenza,**                  | **Priority,**                        |
| ------- | -------------------------------------- | ------------------------------ | ------------------------------------ |
| 1 - 127 | n. slot temporali per produrre 1 unità | scadenza nella timeline: 1-100 | 1-5 : 1 less urgent , 5 max priority |

----

### Struttura programma

**Start** → **selezione** algoritmo di ordinamento (EDF/HPF) → Stampa a video

Esempio:

> Pianificazione EDF:

> 4:0

> 12:10

> Conclusione: 17

> Penalty: 0

----

### Task:

- Calcolo penality (Ritardo*priority= X$)

### Struttura file

- > VRXXXXXX_VRXXXXXX/
   - > s**rc/**
   - > **obj**/ (vuota)
   - > **bin**/ (vuota)
   - > **Makefile**
   - > **Ordini**/
      - > **EDF**.txt
      - > **HPF**.txt
      - > **Both**.txt
      - > **None**.txt
- > **Relazione.**pdf

----

> > # TODO:

- [X] C*     **→ WIP**
- [X] Scheletro ASM
- [X] Definizione REG
   - [X] > > Quante parole per info
   - [X] > > Quanti reg?
- [X] Definizione algorimto di sorting*
- [X] Scrittura dei test
- [X] Stesura macchinosa del file ASM
- [X] Testing (GPT?)
- [X] Consegna 🎉🥳🎊🎈
- [ ] GUI 
