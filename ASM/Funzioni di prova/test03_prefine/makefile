# Makefile

# Definizione del nome dell'eseguibile
EXE = Test1

# Definizione dei comandi per l'assemblaggio e il linking
AS = as --32
LD = ld -m elf_i386

# Definizione delle opzioni per il compilatore
FLAGS = -gstabs

# Definizione degli oggetti da compilare
OBJ = BufferToArray.o main.o

# Regola per la creazione dell'eseguibile
$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

# Regola per la compilazione del file BufferToArray.s
BufferToArray.o: BufferToArray.s
	$(AS) $(FLAGS) -o BufferToArray.o BufferToArray.s

# Regola per la compilazione del file main.s
main.o: main.s
	$(AS) $(FLAGS) -o main.o main.s

# Regola per la pulizia dei file oggetto e dell'eseguibile
clean:
	rm -f *.o $(EXE) core
