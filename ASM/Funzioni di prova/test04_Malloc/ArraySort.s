
.section .data

offset: .int 0

.section .bss

.section .text
    .global ArraySort
    .type ArraySort, @function

ArraySort:                          # esi = array, edi = length

# l'array è strutturata come segue:
# primo prodotto...
# array[0] : ID
# array[1] : Durata
# array[2] : Scadenza
# array[3] : Priorita'
# secondo prodotto...
# array[4] : ID
# array[5] : Durata
# array[6] : Scadenza
# array[7] : Priorita'
# and so on...


                                    # quick sort algorithm
                                    # in esi c'è l'indirizzo dell'array
                                    # in edi c'è la lunghezza dell'array

                                    # quick sort sulla base di priorita 

