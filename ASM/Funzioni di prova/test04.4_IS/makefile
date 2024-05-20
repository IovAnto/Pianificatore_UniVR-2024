# Makefile

EXE = Test1
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = InsertionSort.o Sorting.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)


InsertionSort.o: InsertionSort.s
	$(AS) $(FLAGS) -o InsertionSort.o InsertionSort.s

Sorting.o: Sorting.s
	$(AS) $(FLAGS) -o Sorting.o Sorting.s


clean:
	rm -f *.o
