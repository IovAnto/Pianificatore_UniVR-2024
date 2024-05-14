
.section .data

offset: .int 0

.section .bss

.section .text
    .global ArraySort
    .type ArraySort, @function

ArraySort:

                                    # quick sort algorithm
                                    # in esi c'è l'indirizzo dell'array
                                    # in edi c'è la lunghezza dell'array

