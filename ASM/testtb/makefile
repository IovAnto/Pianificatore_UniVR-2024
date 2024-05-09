EXE= test01
AS= as --32
LD= ld -m elf_i386
FLAGS= -gstabs
OBJ= test.o

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)
eseguibile.o: eseguibile.s
	$(AS) $(FLAGS) -o test.o test.s
clean:
	rm -f *.o $(EXE) core