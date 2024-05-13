# Makefile

EXE = eseguibile
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = bigbuffer.o 

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)


bigbuffer.o: bigbuffer.s
	$(AS) $(FLAGS) -o bigbuffer.o bigbuffer.s

clean:
	rm -f *.o $(EXE) core
