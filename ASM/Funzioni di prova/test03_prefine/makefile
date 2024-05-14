# Makefile

EXE = Test1
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = BufferToArray.o main.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

BufferToArray.o: BufferToArray.s
	$(AS) $(FLAGS) -o BufferToArray.o BufferToArray.s

main.o: main.s
	$(AS) $(FLAGS) -o main.o main.s


clean:
	rm -f *.o $(EXE) core
