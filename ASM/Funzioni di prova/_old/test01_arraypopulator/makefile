# Makefile

EXE = eseguibile
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = ArrayPopulator.o main.o itoa.o CustomMalloc.o OpenFile.o OutputToFile.o 

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

ArrayPopulator.o: ArrayPopulator.s
	$(AS) $(FLAGS) -o ArrayPopulator.o ArrayPopulator.s

main.o: main.s
	$(AS) $(FLAGS) -o main.o main.s

itoa.o: itoa.s
	$(AS) $(FLAGS) -o itoa.o itoa.s

CustomMalloc.o:CustomMalloc.s	
	$(AS) $(FLAGS) -o CustomMalloc.o CustomMalloc.s

OpenFile.o: OpenFile.s
	$(AS) $(FLAGS) -o OpenFile.o OpenFile.s

OutputToFile.o: OutputToFile.s
	$(AS) $(FLAGS) -o OutputToFile.o OutputToFile.s

clean:
	rm -f *.o $(EXE) core
