# Makefile

EXE = Pianificatore
AS = as --32 -gstabs # -gstabs da commentare prima della consegna!!!!!!!!!!!!!!!!!!!!!!!!!!
LD = ld -m elf_i386
OBJ = BufferToArray.o main.o btoa.o insertionSort.o menu.o EqualSort.o Intestazione.o FinalData.o AskInput.o AskOutput.o

all: $(EXE) clean

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

AskOutput.o: AskOutput.s
	$(AS) -o AskOutput.o AskOutput.s

AskInput.o: AskInput.s
	$(AS) -o AskInput.o AskInput.s

FinalData.o: FinalData.s
	$(AS) -o FinalData.o FinalData.s

Intestazione.o: Intestazione.s
	$(AS) -o Intestazione.o Intestazione.s

EqualSort.o: EqualSort.s
	$(AS) -o EqualSort.o EqualSort.s

BufferToArray.o: BufferToArray.s
	$(AS) -o BufferToArray.o BufferToArray.s

main.o: main.s
	$(AS) -o main.o main.s

menu.o: menu.s
	$(AS) -o menu.o menu.s

btoa.o: btoa.s
	$(AS) -o btoa.o btoa.s

insertionSort.o: insertionSort.s
	$(AS) -o insertionSort.o insertionSort.s

.PHONY: clean

clean:
	rm -f *.o