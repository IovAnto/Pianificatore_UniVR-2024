# Makefile

EXE = Test1
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = QuickSort.o Sorting.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)


QuickSort.o: QuickSort.s
	$(AS) $(FLAGS) -o QuickSort.o QuickSort.s

Sorting.o: Sorting.s
	$(AS) $(FLAGS) -o Sorting.o Sorting.s


clean:
	rm -f *.o
