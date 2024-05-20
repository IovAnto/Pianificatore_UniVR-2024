# Makefile

EXE = Test1
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = insertionSort.o main.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)


insertionSort.o: insertionSort.s
	$(AS) $(FLAGS) -o insertionSort.o insertionSort.s

main.o: main.s
	$(AS) $(FLAGS) -o main.o main.s


clean:
	rm -f *.o
