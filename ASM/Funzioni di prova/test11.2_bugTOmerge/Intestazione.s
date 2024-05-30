.section .data


bufferLen: .int 0

EDFstring: .string "EDF:\n"
EDFstringLen: .int 5
HPFstring: .string "HPF:\n"
HPFstringLen: .int 5

AsciiPianificazione: .string "\nPianificazione "
AsciiPianificazioneLen: .int .-AsciiPianificazione

.section .text
    .global intestazione
    .type intestazione, @function

intestazione:

    xorl %ebx, %ebx
    xorl %edx, %edx
    xorl %ecx, %ecx

PrimaRiga:
    #in edi c'è il buffer
    movl AsciiPianificazioneLen, %ecx
    movl $AsciiPianificazione, %esi
    cld
    LoopPrimaRiga:
        lodsb
        stosb
        loop LoopPrimaRiga
    
    movl AsciiPianificazioneLen, %ecx
    addl %ecx, bufferLen

    cmpb $3, %al
    je HPF

EDF:

    #BufferLen in edi
    movl $EDFstring, %esi               # stringa da copiare in buffer
    movl EDFstringLen, %ecx             # lunghezza della stringa
    cld                                 # clear direction flag
    LoopPreEDF:
        lodsb                           # load from esi
        stosb                           # store to edi
        loop LoopPreEDF                 # decrementa ecx ed esegue loop

    jmp end

HPF:

    movl $HPFstring, %esi               # stringa da copiare in buffer
    movl HPFstringLen, %ecx             # lunghezza della stringa
    cld                                 # clear direction flag
    LoopPreHPF:
        lodsb
        stosb
        loop LoopPreHPF

end:

    addl $5, bufferLen
    movl bufferLen, %ecx

    ret


