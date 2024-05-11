# Makefile

EXE = Test1
AS = as --32
LD = ld -m elf_i386
FLAGS = -gstabs
OBJ = ReadOrders.o main.o itoa.o WriteOrders.o 

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

ReadOrders.o: ReadOrders.s
	$(AS) $(FLAGS) -o ReadOrders.o ReadOrders.s

main.o: main.s
	$(AS) $(FLAGS) -o main.o main.s

itoa.o: itoa.s
	$(AS) $(FLAGS) -o itoa.o itoa.s

WriteOrders.o: WriteOrders.s	
	$(AS) $(FLAGS) -o WriteOrders.o WriteOrders.s


clean:
	rm -f *.o $(EXE) core
