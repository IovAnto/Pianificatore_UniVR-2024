# Makefile

EXE = Test1
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = BufferToArray.o main.o btoa.o insertionSort.o menu.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

BufferToArray.o: BufferToArray.s
	$(AS) $(FLAGS) -o BufferToArray.o BufferToArray.s

main.o: main.s
	$(AS) $(FLAGS) -o main.o main.s

menu.o: menu.s
	$(AS) $(FLAGS) -o menu.o menu.s

btoa.o: btoa.s
	$(AS) $(FLAGS) -o btoa.o btoa.s

insertionSort.o: insertionSort.s
	$(AS) $(FLAGS) -o insertionSort.o insertionSort.s

clean:
	rm -f *.o $(EXE)
