#dzielenie wektorów a=a/b sekwencyjnie
#
#argumenty funckji
# aptr - wskaźnik na początek wektora A
# bpos0 - pozycja 3 wektora B
# bpos1 - pozycja 2 wektra B
# bpos2 - pozycja 1 wektroa B
# bpos3 - pozycja 0 wektroa B
#

.section .data
	.equ aptr, 8
	.equ bpos0, 12
	.equ bpos1, 16
	.equ bpos2, 20
	.equ bpos3, 24
.section .text

.global divSISD

.type divSISD, @function
divSISD:
	pushl %ebp
	movl %esp, %ebp			#prolog funkcji
	
	movl $0, %ecx			#indeks pamięci wskaźnika A

	movl aptr(%ebp), %eax		#wczytanie adresu początku wektora do rejestru

	fld (%eax, %ecx, 4)		#adres pamięci wetkra A do rejestru
	fdiv bpos0(%ebp) 		#dzielenie przez wartość wektora B 0 pozycju
	fstp (%eax, %ecx, 4) 		#zwrocenie wyniku do wektora A 0 pozycji
	incl %ecx			#zwiekszenie indeksu

	fld (%eax, %ecx, 4)		#adres pamięci wetkra A do rejestru
	fdiv bpos1(%ebp) 		#dzielenie przez wartość wektora B 1 pozycju
	fstp (%eax, %ecx, 4) 		#zwrocenie wyniku do wektora A 1 pozycji
	incl %ecx			#zwiekszenie indeksu

	fld (%eax, %ecx, 4)		#adres pamięci wetkra A do rejestru
	fdiv bpos2(%ebp) 		#dzielenie przez wartość wektora B 2 pozycju
	fstp (%eax, %ecx, 4) 		#zwrocenie wyniku do wektora A 2 pozycji
	incl %ecx			#zwiekszenie indeksu

	fld (%eax, %ecx, 4)		#adres pamięci wetkra A do rejestru
	fdiv bpos3(%ebp) 		#dzielenie przez wartość wektora B 3 pozycju
	fstp (%eax, %ecx, 4) 		#zwrocenie wyniku do wektora A 3 pozycji

	movl %ebp, %esp			#odtworzenie starego stosu
	popl %ebp
	ret
