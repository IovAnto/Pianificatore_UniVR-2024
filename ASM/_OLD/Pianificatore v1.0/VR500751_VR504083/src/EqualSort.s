.section .data

base: .byte 0               # EDF or HPF
flag: .byte 0               # 1 -> swap 0 -> no swap

.section .text
    .global EqualSort
    .type EqualSort, @function

EqualSort:

    pushl %ebp              
    movl %esp, %ebp
 
    movl 8(%ebp), %edi      #len
    movl 12(%ebp), %esi     #pointer
    movl 16(%ebp), %ecx     #Base

    popl %ebp               #restore stack

    movb %cl, base          #salvo base (EDF or HPF)
    movl %ecx, %eax         # i
    movl %eax, %ebx         # j
    addl $4, %ebx           # j + 1

loop:

    cmpl %eax, %edi         #len <= i (uscita)
    jle endLoop

    xorl %ecx, %ecx
    xorl %edx, %edx

    movb (%esi, %eax, 1), %cl   
    movb (%esi, %ebx, 1), %dl

    cmpb %cl, %dl               #confronto i e j
    je Check                    #se sono uguali vado a check

    jmp next

Check:

    cmpb $3, base               #se base = HPF (priorità) -> decrement
    je decrement

increment:                      # guardo priorità

    incl %eax                   #incremento i
    incl %ebx                   #incremento j

    movb (%esi, %eax, 1), %cl       # preparo il confronto dei prossimi valori
    movb (%esi, %ebx, 1), %dl


    subl $3, %eax           # torno a puntare l'inizio dell'elemento
    subl $3, %ebx           # =

    cmpb %cl, %dl           # confronto i e j
    jl reset                
    je SetDurata

    movl (%esi, %eax, 1), %ecx
    movl (%esi, %ebx, 1), %edx

    movl %ecx, (%esi, %ebx, 1)
    movl %edx, (%esi, %eax, 1)

    movb $1, flag

    jmp reset

decrement:                  # guardo scadenza

    decl %eax
    decl %ebx

    movb (%esi, %eax, 1), %cl
    movb (%esi, %ebx, 1), %dl


    subl $2, %eax
    subl $2, %ebx

    cmpb %cl, %dl
    jg reset
    je SetDurata

    movl (%esi, %eax, 1), %ecx
    movl (%esi, %ebx, 1), %edx

    movl %ecx, (%esi, %ebx, 1)
    movl %edx, (%esi, %eax, 1)

    movb $1, flag

    jmp reset

SetDurata:        # se scadenza uguale priorità uguali, controllo la durata

    addl $1, %eax    # incremento così vado da ID a durata
    addl $1, %ebx

Durata:

    movb (%esi, %eax, 1), %cl
    movb (%esi, %ebx, 1), %dl


    subl $1, %eax
    subl $1, %ebx

    cmpb %cl, %dl
    jge reset
    
    movl (%esi, %eax, 1), %ecx
    movl (%esi, %ebx, 1), %edx

    movl %ecx, (%esi, %ebx, 1)
    movl %edx, (%esi, %eax, 1)

    movb $1, flag

reset:

    addb base, %al     # resetto base
    addb base, %bl     # resetto base

next:

    cmpb $1, flag
    je Redo

    addl $4, %eax
    addl $4, %ebx
    jmp loop

Redo:                   # se ho fatto uno swap, ripeto il confronto

    movl $0, flag
    movl base, %ecx
    movl %ecx, %eax
    movl %eax, %ebx
    addl $4, %ebx

    jmp loop

endLoop:
    
    ret
    


    # appuntino :-) 
    # If you're dealing with a big endian system and you need to convert data to little endian,
    # you'll have to write code to swap the byte order manually. Here's an example of how you can do this for a 32-bit word:

    # Assume that %eax contains the value to be converted
    # ror $16, %eax     # Swap the two 16-bit halves of EAX
    # bswap %eax        # Swap the bytes within each 16-bit half
    