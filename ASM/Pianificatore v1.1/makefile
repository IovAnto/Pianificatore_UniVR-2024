# Makefile

# folder structure:
#	 VRXXX
#		/bin
#			- executable file ('pianificatore')
#		/obj
#			- object files
#		/ordini
#			- ordini
#		/src
#			- source files

EXE_DIR = ./bin
OBJ_DIR = ./obj
SRC_DIR = ./src

EXE = $(EXE_DIR)/Pianificatore
AS = as --32  # -gstabs -gstabs da commentare prima della consegna
LD = ld -m elf_i386
OBJ = $(OBJ_DIR)/BufferToArray.o $(OBJ_DIR)/main.o $(OBJ_DIR)/btoa.o $(OBJ_DIR)/insertionSort.o $(OBJ_DIR)/menu.o $(OBJ_DIR)/EqualSort.o $(OBJ_DIR)/Intestazione.o $(OBJ_DIR)/FinalData.o $(OBJ_DIR)/AskInput.o $(OBJ_DIR)/AskOutput.o $(OBJ_DIR)/TextIn.o

all: $(EXE) clean

$(EXE): $(OBJ)
	$(LD) -o $(EXE) $(OBJ)

$(OBJ_DIR)/TextIn.o: $(SRC_DIR)/TextIn.s
	$(AS) -o $(OBJ_DIR)/TextIn.o $(SRC_DIR)/TextIn.s

$(OBJ_DIR)/AskOutput.o: $(SRC_DIR)/AskOutput.s
	$(AS) -o $(OBJ_DIR)/AskOutput.o $(SRC_DIR)/AskOutput.s

$(OBJ_DIR)/AskInput.o: $(SRC_DIR)/AskInput.s
	$(AS) -o $(OBJ_DIR)/AskInput.o $(SRC_DIR)/AskInput.s

$(OBJ_DIR)/FinalData.o: $(SRC_DIR)/FinalData.s
	$(AS) -o $(OBJ_DIR)/FinalData.o $(SRC_DIR)/FinalData.s

$(OBJ_DIR)/Intestazione.o: $(SRC_DIR)/Intestazione.s
	$(AS) -o $(OBJ_DIR)/Intestazione.o $(SRC_DIR)/Intestazione.s

$(OBJ_DIR)/EqualSort.o: $(SRC_DIR)/EqualSort.s
	$(AS) -o $(OBJ_DIR)/EqualSort.o $(SRC_DIR)/EqualSort.s

$(OBJ_DIR)/BufferToArray.o: $(SRC_DIR)/BufferToArray.s
	$(AS) -o $(OBJ_DIR)/BufferToArray.o $(SRC_DIR)/BufferToArray.s

$(OBJ_DIR)/main.o: $(SRC_DIR)/main.s
	$(AS) -o $(OBJ_DIR)/main.o $(SRC_DIR)/main.s

$(OBJ_DIR)/menu.o: $(SRC_DIR)/menu.s
	$(AS) -o $(OBJ_DIR)/menu.o $(SRC_DIR)/menu.s

$(OBJ_DIR)/btoa.o: $(SRC_DIR)/btoa.s
	$(AS) -o $(OBJ_DIR)/btoa.o $(SRC_DIR)/btoa.s

$(OBJ_DIR)/insertionSort.o: $(SRC_DIR)/insertionSort.s
	$(AS) -o $(OBJ_DIR)/insertionSort.o $(SRC_DIR)/insertionSort.s

.PHONY: clean

clean:
	rm -f $(OBJ_DIR)/*.o
