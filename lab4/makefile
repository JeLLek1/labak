FLAGS = -m32				#flagi kompilatora

S_FILES := $(wildcard src/*.s)		#pliki s
C_FILES := $(wildcard src/*.c)		#pliki c
KERNEL_BIN := calc			#plik wynikowy
CC := gcc

all: $(KERNEL_BIN)

clean:
	rm -f $(KERNEL_BIN)

$(KERNEL_BIN): $(C_FILES) $(S_FILES)
	$(CC) $(FLAGS) $(C_FILES) $(S_FILES) -o $@
