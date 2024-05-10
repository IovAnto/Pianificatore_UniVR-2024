# Makefile

EXE = eseguibile
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = $(wildcard *.s)

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

%.o: %.s
	$(AS) $(FLAGS) -o $@ $<

clean:
	rm -f *.o $(EXE) core
