#generowanie liczb pseudolosowych wektora
#generowanie jest podobne do starndardowego z c 
#
#Dane:
# seed - zmienna globalna przechowująca aktualny seed losowania
#
#argumenty funckji
# vector - wskaźnik na początek wektora
#
#stałe
#
# randA - do liczby pseudolosowej rand = randA*seed+randC
# randC - do liczby pseudolosowej rand = randA*seed+randC
# randDiv - według standardu C wynik rand jest dzielony przez randDiv
# randRemainder - według standardu C wynikiem rand jest reszta z dzielenia przez randRemainder
#

.section .data
	.equ vector, 8
	.equ randA, 1103515245
	.equ randC, 12345
	.equ randDiv, 65536
	.equ randRemainder, 32768
.section .text

.global random_vec, seed

.type random_vec, @function
random_vec:
	pushl %ebp
	movl %esp, %ebp				#prolog funkcji 
	pushl %esi				#zachowanie zarezerowwanego elementu

	movl seed, %eax				#pobranie aktualnego seedu

	movl $0, %esi				#iteracja pętli
random_loop:
	movl $randA, %edx			#randA jako argument mnożenia
	mull %edx				#mnożenie razy randA (radA*seed+randC)
	addl $randC, %eax  			#dodanie randC
	pushl %eax				#zachowanie wyniku

	xorl %edx, %edx				#druga część dzielnej jest 0
	movl $randDiv, %ecx			#wartość, przez którą trzeba podzielić
	divl %ecx				#dzielenie
	xorl %edx, %edx				#druga część dzielnej jest 0
	movl $randRemainder, %ecx		#wartość, przez którą trzeba podzielić
	divl %ecx				#dzielenie
	movl vector(%ebp), %eax			#wkskaźnik na wektor
	cvtsi2ss %edx, %xmm0			#konwersja na typ zmiennoprzecinkowy
	movss %xmm0, (%eax, %esi, 4)		#przeniesienie wyniku do odpowiedniej pozycji wektora
	popl %eax				#pobranie wyniku
	incl %esi
	cmpl $4, %esi
	jb random_loop				#wykonaj dla wszystkich pozycji wektora

	movl %eax, seed 			#nowy seed do pamięci

	popl %esi				#zwrócenie zarazerwowanego elementu
	movl %ebp, %esp				#odtworzenie starego stosu
	popl %ebp
	ret
