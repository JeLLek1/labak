#odjęcie wektorów a=a-b jednocześnie
#
#argumenty funckji
# aptr - wskaźnik na początek wektora A
# b - wektor B
#

.section .data
	.equ aptr, 8
	.equ b, 12
.section .text

.global subSIMD

.type subSIMD, @function
subSIMD:
	pushl %ebp
	movl %esp, %ebp			#prolog funkcji

	movl aptr(%ebp), %eax		#wskaźnik na pierwszy wektor
	movups (%eax), %xmm0		#pierwszy wektor do dodania
	movups b(%ebp), %xmm1		#drugi wektor do dodania
	subps %xmm1, %xmm0		#odjęcie od siebie wektorów
	movups %xmm0, (%eax)		#przeniesienie wyniku do pamięci
	
	movl %ebp, %esp			#odtworzenie starego stosu
	popl %ebp
	ret
