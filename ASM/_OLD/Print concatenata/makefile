# Makefile

EXE = eseguibile
AS = as --32 -gstabs
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = bufferbig.o 

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)


bufferbig.o: bufferbig.s
	$(AS) $(FLAGS) -o bufferbig.o bufferbig.s

clean:
	rm -f *.o $(EXE) core
