# Makefile

EXE = Test1
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = Partition.o QuickSortLauncher.o Sorting.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

Partition.o: Partition.s
	$(AS) $(FLAGS) -o Partition.o Partition.s

QuickSortLauncher.o: QuickSortLauncher.s
	$(AS) $(FLAGS) -o QuickSortLauncher.o QuickSortLauncher.s

Sorting.o: Sorting.s
	$(AS) $(FLAGS) -o Sorting.o Sorting.s


clean:
	rm -f *.o
