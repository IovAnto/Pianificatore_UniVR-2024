.section .data #sezione definizione variabili
hello: #etichetta
.ascii "Hello, World!\n" #stringa costante
hello_len:
.long . – hello #lunghezza della stringa in byte
.section .text #sezione istruzioni
.global
_
start #punto di inizio del programma
_
start:
movl $4, %eax #Carica il codice della system
#call WRITE.
movl $1, %ebx #Mette a 1 il contenuto di EBX.
#Il codice 1 corrisponde al file
#descriptor dello standard
#output (terminale).
Leal hello, %ecx #Carica in ECX l’indirizzo di
#memoria associato all’etichetta
#hello.
movl hello_len, %edx #Carica in EDX la lunghezza
#della stringa contenuta in
#hello.
int $0x80 #Esegue la system call in EAX
#tramite l’interrupt 0x80.
Movl $1, %eax #Carica il codice della system
#call EXIT.
xorl %ebx, %ebx #Azzera EBX. Contiene il codice
#di ritorno della system call.
int $0x80 #Esegue la system call in EAX
#tramite l’interrupt 0x80.