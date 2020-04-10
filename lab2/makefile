all: addition subtraction multiplication

addition: addition.s
	as -g --32 -o addition.o addition.s 
	ld -m elf_i386 -o addition addition.o

subtraction: subtraction.s
	as -g --32 -o subtraction.o subtraction.s
	ld -m elf_i386 -o subtraction subtraction.o

multiplication: multiplication.s
	as -g --32 -o multiplication.o multiplication.s
	ld -m elf_i386 -o multiplication multiplication.o

clean:
	rm addition.o addition multiplication.o multiplication substraction.o substraction
