#odejmowanie wielkich liczb
#rejestry:
# %edi - indeks liczba1
# %esi - indeks liczba2
# %ecx - indeks wynik
# %eax - pobrana część liczba1
# %ebx - pobrana część liczba2
#zmienne:
# liczba1 - odjemna
# liczba2 - odjemnik
# wynik - wynik odejmowania
#stałe:
# SYS_EXIT - komenda systemowa wyjścia z programu
# STATUS_SUCCESS - wartość zwracana przez program przy powodzeniu wykonania
# GREATER - należy tu podać która z wielkości liczb LICZBA1_LEN, LICZBA2_LEN będzie większa
#funkcje:
# l1_sign - generuje dla liczba1 0x00000000 lub 0xffffffff w zaleznosci od znaku jezeli poza zakresem
# l2_sign - to samo co w l1_sign tylko dla liczba2
.section .data
	.equ SYS_EXIT, 1
	.equ STATUS_SUCCESS, 0
	.equ GREATER, LICZBA1_LEN	#ktora z liczb jest wieksza
liczba1:
	.long 0x08570030, 0x08570030, 0x08570030, 0x08570030
	.equ LICZBA1_LEN, (. - liczba1)/4
liczba2:
	.long 0x701100FF, 0x701100FF, 0x701100FF
	.equ LICZBA2_LEN, (. - liczba2)/4
wynik:
	.space (GREATER+1)*4, 0
	.equ WYNIK_LEN, (. - wynik)/4
.section .text

.global _start
_start:
	movl $LICZBA1_LEN, %edi		#indeks liczby 1
	movl $LICZBA2_LEN, %esi		#indeks liczby 2
	movl $WYNIK_LEN, %ecx		#indeks wyniku
	clc				#wyczyszczenie flag
	pushf				#wstawienie flag na stos
subtraction:
	cmpl $0, %edi
	je l1_aut			#jeśli indeks l1 jest równy 0
	decl %edi			#dekrementacja pozycji l1
	movl liczba1(,%edi,4), %eax	#wczytanie l1
	jmp l1_notaut
l1_aut:
	call l1_sign
l1_notaut:

	cmpl $0, %esi
	je l2_aut			#jeśli indeks l2 jest równy 0
	decl %esi			#dekrementacja pozycji l2
	movl liczba2(,%esi,4), %ebx	#wczytanie l2
	jmp l2_notaut
l2_aut:
	call l2_sign
l2_notaut:
	popf				#zdjecie ze stosu flag
	sbbl %ebx, %eax			#odejmowanie od siebie liczb
	decl %ecx
	movl %eax, wynik(,%ecx,4)	#dodanie kolejnych cyfr wyniku
	pushf				#dodanie do stosu flag
	cmpl $0, %edi			#czy indeks l1 jest 0
	je check_l2
	jmp subtraction			#jeśli nie to wroc
check_l2:
	cmpl $0, %esi			#czy indeks l2 jest 0
	jne subtraction			#jesli nie to wroc
	
	call l1_sign
	call l2_sign
	popf
	sbbl %ebx, %eax			#ostatnie odejmowanie dla przepelnienia
	decl %ecx
	movl %eax, wynik(,%ecx,4)

	movl $SYS_EXIT, %eax		#kod wyjścia
	movl $STATUS_SUCCESS, %ebx	#status wyjścia z programu
	int $0x80			#wywołanie komendy systemowej

#wczytuje do eax wartosci wedlug znaku
l1_sign:
	movl $0, %edi	
	movl liczba1(,%edi,4), %eax	#przenies ostatnia cyfre do rejestru
	andl $0x80000000, %eax		#zostawienie tylko ostatniego bitu rejestru
	cmpl $0, %eax			#jesli jest zero to dodatnia
	je l1_positive
	movl $0xFFFFFFFF, %eax		#jesli ujemna to kolejne beda same 1
	jmp l1_negative
l1_positive:
	movl $0x00000000, %eax		#jesli dodatnia to beda same 0
l1_negative:
	ret

#wczytuje do ebx wartosci wedlug znaku
l2_sign:
	movl $0, %esi			
	movl liczba2(,%esi,4), %ebx	#przenies ostatnia cyfre do rejestru
	andl $0x80000000, %ebx		#zostawienie tylko ostatniego bitu rejestru
	cmpl $0, %ebx			#jesli jest zero to dodatnia
	je l2_positive
	movl $0xFFFFFFFF, %ebx		#jesli ujemna to kolejne beda same 2
	jmp l2_negative
l2_positive:
	movl $0x00000000, %ebx		#jesli dodatnia to beda same 0
l2_negative:
	ret
