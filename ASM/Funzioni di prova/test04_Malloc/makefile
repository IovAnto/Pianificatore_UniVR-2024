# Makefile

EXE = Test1
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = BufferToArray.o main.o btoa.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

BufferToArray.o: BufferToArray.s
	$(AS) $(FLAGS) -o BufferToArray.o BufferToArray.s

main.o: main.s
	$(AS) $(FLAGS) -o main.o main.s

btoa.o: btoa.s
	$(AS) $(FLAGS) -o btoa.o btoa.s


clean:
	rm -f *.o $(EXE)
