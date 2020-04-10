#Kalkulator liczb pojedyńczej lub podwójnej precyzji
#zmienne:
#
#
#
#stałe:
# SYS_EXIT - kod wywołania systemowego wyjścia z programu
# STATUS_SUCCESS - kod poprawnego zakończenia programu
# SYS_READ - kod wywołania czytania z pliku
# SYS_WRITE - kod wywołania zapisu do pliku
# STD_IN - opid pliku stdin
# STD_OUT - opis pliku stdout
#
#zmienne:
# numfloat1 - pierwsza liczba typu float
# numfloat2 - druga liczba typu float
# numdouble1 - pierwsza liczba typu double
# numdouble2 - druga liczba typu double
# wynikFloat - wynik pojedyńczej precyzji
# wynikDouble - wynik podwójnej precyzji
# msg_type - wiadomość wyświetlana podczas wyboru typu precyzji
# msg_operation - wiadomość wyświetlana podczas wyboru typu operacji
# type_a - kod ascii typu precyzji
# operation_a - kod ascii wybranej operacji
# control_word - sterowanie precyzja
.section .data
	.equ SYS_EXIT, 1
	.equ STATUS_SUCCESS, 0
	.equ SYS_READ, 3
	.equ SYS_WRITE, 4
	.equ STD_IN, 0
	.equ STD_OUT, 1
numfloat1: .float 9
numfloat2: .float 1
numdouble1: .double 5
numdouble2: .double 1
control_word: .word 0xF7F
#24bit	0x7f	- do najbliższej,	0x47	- do -nieskończoność,	0x87   - do +nieskończoność,  	0xC7  - do zera
#53bit	0x27F	- do najbliższej,	0x67F	- do -nieskończoność,	0xA7F  - do +nieskończoność, 	0xE7F - do zera
#64bit	0x37F	- do najbliższej,	0x77F	- do -nieskończoność,	0xB7F, - do +nieskończoność, 	0xF7F - do zera
type_a:
	.ascii "  "
	.equ TYPE_A_LEN, . - type_a
operation_a:
	.ascii "  "
	.equ OPERATION_A_LEN, . - operation_a
.section .text
msg_type:
	.ascii "Podaj precyzje, z jaka maja sie wykonywac obliczenia (f - pojedyncza, d - podwojna):"
	.equ MSG_TYPE_LEN, . - msg_type
msg_operation: 
	.ascii "Podaj typ operacji (dostepne sa \"+\",\"-\",\"*\",\"/\"):"
	.equ MSG_OPERATION_LEN, . - msg_operation

.global _start
_start:
	fldcw control_word		#ustawienie słowa sterującego precyzją
ask_type:
	#wypisanie na terminalu msg_type
	movl $SYS_WRITE, %eax
	movl $STD_OUT, %ebx
	movl $msg_type, %ecx
	movl $MSG_TYPE_LEN, %edx
	int $0x80
	#===============================

	#wczytanie z terminalu znaku odpowiedzi
	movl $SYS_READ, %eax
	movl $STD_IN, %ebx
	movl $type_a, %ecx
	movl $TYPE_A_LEN, %edx
	int $0x80
	#===============================
	
	movl $0, %esi			#indeks znaku pobranego w strukturze danych
	movb type_a(,%esi,1), %al	#zapis bajtu pobranego znaku do rejestru 
	
	cmpb $0x66, %al
	je type_f			#jeżeli wczytany znak to f
	cmpb $0x64, %al
	je type_d			#jeżeli wczytany znak to d
	jmp ask_type			#jeżeli żadno z powyrzszych to zapytaj się raz jeszcze o typ operacji

	#Dodanie do stosu liczb typu f/d w zależności od opcji
type_f:
	fld numfloat1
	fld numfloat2
	jmp ask_operation
type_d:
	fld numdouble1
	fld numdouble2
	#=====================================================
	
ask_operation:
	#wypisanie na terminalu msg_operation
	movl $SYS_WRITE, %eax
	movl $STD_OUT, %ebx
	movl $msg_operation, %ecx
	movl $MSG_OPERATION_LEN, %edx
	int $0x80
	#===============================

	#wczytanie z terminalu znaku odpowiedzi
	movl $SYS_READ, %eax
	movl $STD_IN, %ebx
	movl $operation_a, %ecx
	movl $OPERATION_A_LEN, %edx
	int $0x80
	#===============================

	movl $0, %esi			#indeks znaku pobranego w strukturze danych
	movb operation_a(,%esi,1), %al	#zapis bajtu pobranego znaku do rejestru 

	cmpb $0x2B, %al
	je addition			#jezeli + to dodaj
	cmpb $0x2D, %al
	je subtraction			#jezeli - to odejmij
	cmpb $0x2A, %al
	je multiplication		#jezeli * to pomnóż
	cmpb $0x2F, %al
	je division			#jezeli / to podziel
	jmp ask_operation			

	#Wykonanie operacji w zależności od opcji
addition:
	faddp				#dodawanie liczb zmiennoprzecinkowych
	jmp end_operations
subtraction:
	fsubp				#odejmowanie liczb zmiennoprzecinkowcy
	jmp end_operations
multiplication:
	fmulp				#mnożenie liczb zmiennoprzecinkowych
	jmp end_operations
division:
	fdivp				#dzielenie liczb zmiennoprzecinkowcyh
	#========================================

end_operations:

	movl $SYS_EXIT, %eax		#kod wyjścia
	movl $STATUS_SUCCESS, %ebx	#status wyjścia z programu
	int $0x80			#wywołanie komendy systemowej
