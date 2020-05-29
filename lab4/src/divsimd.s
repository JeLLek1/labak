#dzielenie wektorów a=a/b jednocześnie
#
#argumenty funckji
# aptr - wskaźnik na początek wektora A
# b - wektor B
#

.section .data
	.equ aptr, 8
	.equ b, 12
.section .text

.global divSIMD

.type divSIMD, @function
divSIMD:
	pushl %ebp
	movl %esp, %ebp			#prolog funkcji

	movl aptr(%ebp), %eax		#wskaźnik na pierwszy wektor
	movups (%eax), %xmm0		#pierwszy wektor dzielna
	movups b(%ebp), %xmm1		#drugi wektor dzielnik
	divps %xmm1, %xmm0		#dzielenie przez siebie wektorów
	movups %xmm0, (%eax)		#przeniesienie wyniku do pamięci
	
	movl %ebp, %esp			#odtworzenie starego stosu
	popl %ebp
	ret
