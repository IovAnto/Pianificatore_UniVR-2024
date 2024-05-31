.section .data

offset: .int 0

.section .bss

.section .text
    .global BufferToArray
    .type BufferToArray, @function

BufferToArray:

    movb $0, %dl

loop:
    
    movb (%esi), %al
    
    cmp $0, %al
    je end

    cmp $44, %al
    je store

    cmp $10, %al
    je store

num:
    movb %dl, %bl

    sal $3, %edx # *10
    sal $1, %ebx # *10

    addb %bl, %dl

    sub $48, %al
    addb %al, %dl

    inc %esi
    jmp loop

store:

    movb %dl, (%edi)
    inc %edi
    movb $0, %dl
    inc %esi
    jmp loop

end:
    ret


    


