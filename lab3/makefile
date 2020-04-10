calculator: calculator.s
	as -g --32 -o calculator.o calculator.s 
	ld -m elf_i386 -o calculator calculator.o

clean:
	rm calculator.o calculator
