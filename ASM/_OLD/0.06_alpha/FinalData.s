.section .data

PenaltyMsgLen: .byte 9
TimeMsgLen: .byte 13

PenaltyMsg: .string "Penalty: "
TimeMsg: .string "Conclusione: "

timeAscii: .byte 4
penaltyAscii: .byte 6


.section .text
    .globl finalData
    .type finalData, @function

finalData:

    pushl %ebx #salvo la penalita'
    pushl %eax #salvo il tempo
    addl %edx, %edi # aggiungo la lunghezza del buffer all'inizio del buffer per avere il primo spazio libero
    xorl %ecx, %ecx #per sicurezza azzero ecx

    movl $TimeMsg, %esi
    movb TimeMsgLen, %cl
    cld                                 
    LoopTime:                #ctrl c e ctrl v
        lodsb
        stosb
        loop LoopTime


getTime:  #Tempo in numeri in %ebx e dove scrivere in %edi

    popl %eax #Riprendo dalla stack il tempo
    movl $10, %ebx     
    leal timeAscii+3, %esi    #un semplicissimo btoa che trasforma il tempo in ascii 
    movl $10, (%esi)

loopTime:

    xorl %edx, %edx
    divl %ebx               # divido per prendere il resto

    addb $48, %dl           #aggiungo 48 per trasformare il numero in ascii
    decl %esi               #decremento il puntatore che fino a questo punto punta a 10 (vedi sopra)
    movb %dl, (%esi)       

    test %eax, %eax       
    jz BufferTime

    jmp loopTime

BufferTime: #copio il buffer in %edi(puntatore al buffer)

    movb (%esi), %al
    cmpb $10, %al
    je next
    movb %al, (%edi)

    incl %edi
    incl %esi

    jmp BufferTime

next:  #finito il tempo uso il tappo \n

    movb $10, (%edi)
    incl %edi

    xorl %ecx, %ecx 

    movl $PenaltyMsg, %esi
    movb PenaltyMsgLen, %cl
    cld                                # ctrl c e ctrl v
    LoopPenalty:
        lodsb
        stosb
        loop LoopPenalty

getPenalty: 

    popl %eax #Riprendo dalla stack la penalita'
    movl $10, %ebx     
    leal penaltyAscii+5, %esi 
    movl $10, (%esi)

loopPenalty:

    xorl %edx, %edx
    divl %ebx

    addb $48, %dl
    decl %esi
    movb %dl, (%esi) #stessa cosa di sopra ma per la penalita'

    test %eax, %eax
    jz BufferPenalty

    jmp loopPenalty

BufferPenalty:

    movb (%esi), %al
    cmpb $10, %al
    je next2
    movb %al, (%edi)

    incl %edi
    incl %esi

    jmp BufferPenalty

next2:

    movb %al, (%edi)      #aggiungo il tappo \n
    incl %edi             
    movl $0, (%edi)       #concludo con \0

    ret
    