.section .data

AsciiPianificazione: .string "Pianificazione "
AsciiPianificazioneLen: .int .-AsciiPianificazione

EDFstring: .string "EDF:\n\0"
EDFstringLen: .int 5
HPFstring: .string "HPF:\n\0"
HPFstringLen: .int 5

ArrayP: .int 0 # pointer to the array
ArrayLen: .int 0 # length of the array

buffer2: .space 1024
BufferPosition: .int 0
Bchoice: .byte 0

TimeEnlapsed: .int 0



.section .text
.global ArrayToBuffer
.type ArrayToBuffer, @function

ArrayToBuffer:

    

    movl %eax, Bchoice
    movl %esi, ArrayP
    movl %edi, ArrayLen

PrimaRiga:
    movl $buffer2, %edi
    movl AsciiPianificazioneLen, %ecx
    movl $AsciiPianificazione, %esi
    cld
    LoopPrimaRiga:
        lodsb
        stosb
        loop LoopPrimaRiga

    # Save the current position in the buffer
    addl %edi, BufferPosition

# bchoice - 2 = EDF 3 = HPF

    cmpl $3, Bchoice
    je HPF


EDF:
    movl $EDFstring, %esi               # stringa da copiare in buffer
    movl BufferPosition, %edi           # posizione corrente nel buffer
    movl EDFstringLen, %ecx             # lunghezza della stringa
    cld                                 # clear direction flag
    LoopPreEDF:
        lodsb                           # load from esi
        stosb                           # store to edi
        loop LoopPreEDF                 # decrementa ecx ed esegue loop
    movl %edi, BufferPosition           # Backup Posizione corrente nel buffer

    jmp ArrayEDF


HPF:
    movl $HPFstring, %esi               # stringa da copiare in buffer
    movl BufferPosition, %edi           # posizione corrente nel buffer
    movl HPFstringLen, %ecx             # lunghezza della stringa
    cld                                 # clear direction flag
    LoopPreHPF:
        lodsb
        stosb
        loop LoopPreHPF
    movl %edi, BufferPosition           # Backup Posizione corrente nel buffer


ArrayEDF:
# scrive sul buffer l'id del prodotto e il tempo trascorso (variabile TimeEnlapsed)
# ID:TimeEnlapsed
# ':' vengono aggiunti dalla funzione 'DuePunti'
# l'ID deve essere convertito da byte a stringa
# l'ID è il primo elemento dell'array e si trova ogni 4 byte nell'array
# TimeEnlapsed viene incrementato ogni 'durata' relativa al prodotto ID
# 'durata' si trova al byte successivo ad ID

    


ArrayHPF:


DuePunti:

    movb $':', %al
    movl BufferPosition, %edi
    movb %al, (%edi)
    incl BufferPosition
    


    ret

    