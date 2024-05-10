# Makefile

# Find all .s files in the current directory
SOURCES = $(wildcard *.s)
# Get the corresponding executable names
EXECUTABLES = $(SOURCES:.s=)

all: $(EXECUTABLES)

# Rule to build each executable
%: %.s
    as --32 -o $@.o $<
    ld -m elf_i386 -o $@ $@.o

clean:
    rm -f *.o $(EXECUTABLES)