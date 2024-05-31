.section .data

buffer2: .space 1024
BufferPosition: .int 0
Bchoice: .byte 0

AsciiPianificazione: .string "Pianificazione: \0"
AsciiPianificazioneLen: .int 16

EDFstring: .string "EDF:\n\0"
EDFstringLen: .int 5
HPFstring: .string "HPF:\n\0"
HPFstringLen: .int 5

ArrayP: .int 0 # pointer to the array
ArrayLen: .int 0 # length of the array

.section .text
.global ArrayToBuffer
.type ArrayToBuffer, @function

ArrayToBuffer:
    movl %eax, Bchoice
    movl %esi, ArrayP
    movl %edi, ArrayLen

PrimaRiga:
    movl $AsciiPianificazione, %esi
    movl $buffer2, %edi
    movl AsciiPianificazioneLen, %ecx
    cld
    LoopPrimaRiga:
        lodsb
        stosb
        loop LoopPrimaRiga

    # Save the current position in the buffer
    movl %edi, BufferPosition

# bchoice - 2 = EDF 3 = HPF

    cmpl $3, Bchoice
    je HPF


EDF:
    movl $EDFstring, %esi               # stringa da copiare in buffer
    movl BufferPosition, %edi           # posizione corrente nel buffer
    movl EDFstringLen, %ecx             # lunghezza della stringa
    cld                                 # clear direction flag
    LoopPreEDF:
        lodsb
        stosb
        loop LoopPreEDF
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

ArrayHPF:


    ret

    