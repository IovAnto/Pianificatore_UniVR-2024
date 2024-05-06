section .data
    fileName db 64  ; Lunghezza massima del nome del file
    prompt db "Inserisci il nome del file: ", 0
    invalid_option db "Opzione di ordinamento non valida", 0
    output_filename db "output.txt", 0
    edf_prompt db "Pianificazione EDF:", 0
    hpf_prompt db "Pianificazione HPF:", 0
    separator db "--------------------------------", 0
    id_header db "ID", 9, "Durata", 9, "Scadenza", 9, "Priorità", 10, 0
    id_format db "%d", 9, "%d", 9, "%d", 9, "%d", 10, 0
    finito db "Conclusione: ", 0
    penalty db "Penalty: ", 0

section .bss
    ArrayProd resb 16000  ; Riserva spazio per l'array di prodotti

section .text
    global _start

_start:
    ; Stampa il prompt per il nome del file
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 30
    int 0x80

    ; Legge il nome del file dalla console
    mov eax, 3
    mov ebx, 0
    mov ecx, fileName
    mov edx, 64
    int 0x80

    ; Apre il file in modalità di lettura
    mov eax, 5
    mov ebx, fileName
    mov ecx, 0
    int 0x80
    mov esi, eax  ; Salva il descrittore del file

    ; Controlla se il file è stato aperto correttamente
    cmp eax, -1
    je file_error

    ; Lettura dell'ordinamento scelto
    mov eax, 4
    mov ebx, 1
    mov ecx, ordine_prompt
    mov edx, 50
    int 0x80

    ; Lettura della scelta dell'utente
    mov eax, 3
    mov ebx, 0
    mov ecx, scelta
    mov edx, 2
    int 0x80

    ; Controlla se l'opzione di ordinamento è valida
    cmp byte [scelta], '0'
    jl invalid_option
    cmp byte [scelta], '1'
    jg invalid_option

    ; Lettura dei dati dal file e memorizzazione nell'array di prodotti
    xor ecx, ecx  ; Contatore dei caratteri letti
read_loop:
    mov eax, 3
    mov ebx, esi
    add ebx, ecx  ; Calcola l'offset per la lettura
    mov ecx, ArrayProd
    add ecx, ecx  ; Moltiplica per 2 per ottenere l'offset in termini di struct
    add ecx, ecx
    add ecx, ecx
    add ecx, ArrayProd  ; Aggiungi l'indirizzo di base
    mov edx, 4
    int 0x80
    cmp eax, 0  ; Controlla se ha raggiunto la fine del file
    je read_done
    add ecx, 4  ; Passa al campo successivo
    inc ecx  ; Salta la virgola
    inc ecx  ; Passa al campo successivo
wread_done:

    ; Chiude il file
    mov eax, 6
    mov ebx, esi
    int 0x80

    ; Ordina l'array di prodotti
    cmp byte [scelta], '0'
    je ordina_edf
    cmp byte [scelta], '1'
    je ordina_hpf
    jmp invalid_option

ordina_edf:
    ; Implementa l'algoritmo EDF per ordinare l'array di prodotti
    ; ...

    jmp stampa_output

ordina_hpf:
    ; Implementa l'algoritmo HPF per ordinare l'array di prodotti
    ; ...

    jmp stampa_output

stampa_output:
    ; Apre il file di output
    mov eax, 5
    mov ebx, output_filename
    mov ecx, 1  ; O_RDWR
    mov edx, 0644  ; Permessi di lettura e scrittura per l'utente, solo lettura per il gruppo e altri
    int 0x80
    mov edi, eax  ; Salva il descrittore del file di output

    ; Scrive l'intestazione nel file di output
    mov eax, 4
    mov ebx, edi
    mov ecx, id_header
    mov edx, id_header_len
    int 0x80

    ; Stampa ogni prodotto nel file di output
    mov esi, ArrayProd
    xor ecx, ecx  ; Contatore degli elementi
print_loop:
    cmp ecx, 10  ; Numero massimo di elementi da stampare
    jge print_done

    ; Carica i valori del prodotto corrente
    mov eax, [esi]  ; ID
    mov ebx, [esi + 4]  ; Durata
    mov edx, [esi + 8]  ; Scadenza
    mov edi, [esi + 12]  ; Priorità

    ; Formatta e stampa i valori nel file di output
    mov eax, 4
    mov ebx, edi
    mov ecx, id_format
    mov edx, 0
    int 0x80

    ; Passa al prodotto successivo
    add esi, 16  ; Dimensione di un prodotto

    ; Incrementa il contatore degli elementi
    inc ecx
    jmp print_loop

print_done:
    ; Chiude il file di output
    mov eax, 6
    mov ebx, edi
    int 0x80

    ; Stampa a video l'ordine dei prodotti secondo le specifiche
    ; ...

    ; Termina il programma
    mov eax, 1
    xor ebx, ebx
    int 0x80

file_error:
    ; Stampa un messaggio di errore in caso di fallimento nell'apertura del file
    ; ...

invalid_option:
    ; Stampa un messaggio di errore in caso di opzione di ordinamento non valida
    ; ...

; Dichiarazioni e definizioni di funzioni aggiuntive qui

section .text

; Implementazione della funzione di ordinamento EDF
ordina_edf:
    mov esi, ArrayProd  ; Puntatore all'inizio dell'array di prodotti
    mov ecx, 0  ; Indice del primo elemento
outer_loop:
    cmp ecx, 10  ; Numero massimo di elementi da ordinare
    jge ordina_done
    mov edx, ecx  ; Indice del secondo elemento
inner_loop:
    cmp edx, 10  ; Numero massimo di elementi da ordinare
    jge next_outer
    mov eax, [esi + ecx * 16 + 8]  ; Scadenza del primo elemento
    mov ebx, [esi + edx * 16 + 8]  ; Scadenza del secondo elemento
    cmp eax, ebx  ; Confronta le scadenze
    jg swap_elements
    jl next_inner
    ; Se le scadenze sono uguali, confronta le priorità
    mov eax, [esi + ecx * 16 + 12]  ; Priorità del primo elemento
    mov ebx, [esi + edx * 16 + 12]  ; Priorità del secondo elemento
    cmp eax, ebx  ; Confronta le priorità
    jg swap_elements
next_inner:
    inc edx  ; Passa al prossimo elemento
    jmp inner_loop
next_outer:
    inc ecx  ; Passa al prossimo elemento
    jmp outer_loop
swap_elements:
    ; Scambia i valori dei due elementi
    mov eax, [esi + ecx * 16]
    mov ebx, [esi + ecx * 16 + 4]
    mov ecx, [esi + ecx * 16 + 8]
    mov edx, [esi + ecx * 16 + 12]
    mov [esi + ecx * 16], [esi + edx * 16]
    mov [esi + ecx * 16 + 4], [esi + edx * 16 + 4]
    mov [esi + ecx * 16 + 8], [esi + edx * 16 + 8]
    mov [esi + ecx * 16 + 12], [esi + edx * 16 + 12]
    mov [esi + edx * 16], eax
    mov [esi + edx * 16 + 4], ebx
    mov [esi + edx * 16 + 8], ecx
    mov [esi + edx * 16 + 12], edx
    jmp next_inner
ordina_done:

; Implementazione della funzione di ordinamento HPF
ordina_hpf:
    mov esi, ArrayProd  ; Puntatore all'inizio dell'array di prodotti
    mov ecx, 0  ; Indice del primo elemento
outer_loop_hpf:
    cmp ecx, 10  ; Numero massimo di elementi da ordinare
    jge ordina_done_hpf
    mov edx, ecx  ; Indice del secondo elemento
inner_loop_hpf:
    cmp edx, 10  ; Numero massimo di elementi da ordinare
    jge next_outer_hpf
    mov eax, [esi + ecx * 16 + 12]  ; Priorità del primo elemento
    mov ebx, [esi + edx * 16 + 12]  ; Priorità del secondo elemento
    cmp eax, ebx  ; Confronta le priorità
    jg swap_elements_hpf
    jl next_inner_hpf
    ; Se le priorità sono uguali, confronta le scadenze
    mov eax, [esi + ecx * 16 + 8]  ; Scadenza del primo elemento
    mov ebx, [esi + edx * 16 + 8]  ; Scadenza del secondo elemento
    cmp eax, ebx  ; Confronta le scadenze
    jg swap_elements_hpf
next_inner_hpf:
    inc edx  ; Passa al prossimo elemento
    jmp inner_loop_hpf
next_outer_hpf:
    inc ecx  ; Passa al prossimo elemento
    jmp outer_loop_hpf
swap_elements_hpf:
    ; Scambia i valori dei due elementi
    mov eax, [esi + ecx * 16]
    mov ebx, [esi + ecx * 16 + 4]
    mov ecx, [esi + ecx * 16 + 8]
    mov edx, [esi + ecx * 16 + 12]
    mov [esi + ecx * 16], [esi + edx * 16]
    mov [esi + ecx * 16 + 4], [esi + edx * 16 + 4]
    mov [esi + ecx * 16 + 8], [esi + edx * 16 + 8]
    mov [esi + ecx * 16 + 12], [esi + edx * 16 + 12]
    mov [esi + edx * 16], eax
    mov [esi + edx * 16 + 4], ebx
    mov [esi + edx * 16 + 8], ecx
    mov [esi + edx * 16 + 12], edx
    jmp next_inner_hpf
ordina_done_hpf:

; Stampa l'ordine dei prodotti secondo le specifiche
stampa_output:
    ; Stampa il prompt per la pianificazione EDF o HPF
    mov eax, 4
    mov ebx, 1
    mov ecx, edf_prompt
    cmp byte [scelta], '0'
    jne print_hpf_prompt
    mov ecx, hpf_prompt
print_hpf_prompt:
    mov edx, 20
    int 0x80

    ; Stampa l'ordine dei prodotti
    mov esi, ArrayProd
    xor ecx, ecx  ; Contatore degli elementi
    mov edx, 0  ; Tempo trascorso
    mov edi, 0  ; Penalità totale
print_loop:
    cmp ecx, 10  ; Numero massimo di elementi da stampare
    jge print_done
    ; Carica i valori del prodotto corrente
    mov eax, [esi + ecx * 16]  ; ID
    mov ebx, [esi + ecx * 16 + 4]  ; Durata
    mov edi, [esi + ecx * 16 + 8]  ; Scadenza
    mov ebp, [esi + ecx * 16 + 12]  ; Priorità
    ; Stampa i dettagli del prodotto
    mov eax, 4
    mov ebx, 1
    mov edx, edf_prompt
    cmp byte [scelta], '0'
    jne print_hpf_prompt
    mov edx, hpf_prompt
print_hpf_prompt:
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov edx, eax
    mov eax, 1
    int 0x80
    ; Calcola il tempo di scadenza effettivo del prodotto
    add edx, ebx  ; Tempo trascorso più durata del prodotto
    cmp edx, edi  ; Confronta con la scadenza
    jle no_penalty
    ; Calcola e aggiunge la penalità
    sub edx, edi  ; Calcola il ritardo
    imul edx, ebp  ; Moltiplica per la priorità
    add edi, edx  ; Aggiunge alla penalità totale
    ; Stampa la penalità
    mov eax, 4
    mov ebx, 1
    mov ecx, penalty
    mov edx, 8
    int 0x80
no_penalty:
    ; Incrementa il contatore degli elementi
    inc ecx
    jmp print_loop
print_done:
    ; Stampa la conclusione e la penalità totale
    mov eax, 4
    mov ebx, 1
    mov ecx, finito
    mov edx, 12
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, edi  ; Penalità totale
    mov edx, 1
    int 0x80
    ; Termina il programma
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Gestione degli errori
file_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, file_error_msg
    mov edx, 24
    int 0x80
    jmp exit_program

invalid_option:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_option_msg
    mov edx, 32
    int 0x80
    jmp exit_program

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
