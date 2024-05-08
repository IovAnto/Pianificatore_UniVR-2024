.section .data


.section .text
    .globl atoi

atoi:  				


  xorl %eax,%eax			
  xorl %ebx,%ebx           # mi servono tutti i registi, quindi uso ESI (Extended Source Index) un puntatore praticamente
  xorl %ecx,%ecx           # quindi nel main devi caricare in %esi l'indirizzo della stringa da convertire, grazie indiano a caso su yt
  xorl %edx,%edx
  

ripeti:

  movb (%ecx,%esi,1), %bl # praticamente un Stringa[i] piu' complesso, praticamente sposto nei primi 16 bit di EBX il valore puntato da 
                          # (%ecx,%esi,1) Base + index * scale , gli sto dicendo fai a sto indirizzo + base e leggi 1 byte (string[i+1] ti ricorda qualcosa?)

  cmp $10, %bl             # vedo se e' stato letto il carattere '\n'
  je fine_atoi

  subb $48, %bl            # sempre la stessa storia del itoa se 0 è 48 allora togliendo 48 ho tutti i numeri da 0 a 9 
  movl $10, %edx           # metto 10 per poi usarlo come moltiplicatore
  mulb %dl                # molb sua EBX Come base e %dl come molt (cioe 10) e salva tutto in eax
  addl %ebx, %eax         

  inc %ecx     # i++
  jmp ripeti   #torno su


fine_atoi:
    
      ret #Fine Funzione
