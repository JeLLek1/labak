#include <stdio.h> 
#include <time.h>

//struktura przechowująca wektor liczb
typedef struct{
	float pos0, pos1, pos2, pos3;
}Number;

typedef struct{
	double sisd, simd;
}timeMeasure;

//dodawanie wektorów a+b sekwencyjnie
void addSISD(Number *a, Number b);
//odejmowanie wektorów a-b sekwencyjnie
void subSISD(Number *a, Number b);
//mnożenie wektorów a*b sekewencyjnie
void mulSISD(Number *a, Number b);
//dzielenie wektorów a/b sekwencyjnie
void divSISD(Number *a, Number b);

//dodawanie wektorów a+b jednocześnie
void addSIMD(Number *a, Number b);
//odejmowanie wektorów a-b jednocześnie
void subSIMD(Number *a, Number b);
//mnożenie wektorów a*b jednocześnie
void mulSIMD(Number *a, Number b);
//dzielenie wektorów a/b jednocześnie
void divSIMD(Number *a, Number b);

//pseudo losowanie wartości wektora
void random_vec(Number *a);
//inizjalizowanie wartości pseudolosowej według czasu systemowego
void srand_vec();

//pomiar czasu dodawania
timeMeasure measureAdd(int n){
	//liczby dodawane
	Number numberA;
	Number numberB;
	Number numberA1;
	Number numberB1;
	//czas startu i końca
	clock_t start;
	clock_t end;
	//struktura przechowująca całkowity czas
	timeMeasure timeRun;
	timeRun.sisd = 0;
	timeRun.simd = 0;
	//pomiar dodawania
	for(int i=0; i<10; i++){
		for(int j=0; j<n; j++){
			random_vec(&numberA);
			random_vec(&numberB);
			numberA1=numberA;
			numberB1=numberB;
			start = clock();
			addSISD(&numberA, numberB);
			end = clock();
			timeRun.sisd+=(double)(end-start)/CLOCKS_PER_SEC;
			start = clock();
			addSIMD(&numberA1, numberB1);
			end = clock();
			timeRun.simd+=(double)(end-start)/CLOCKS_PER_SEC;
		}
	}
	timeRun.sisd/=10;
	timeRun.simd/=10;

	return timeRun;
}

//pomiar czasu odejmowania
timeMeasure measureSub(int n){
	//liczby odejmowane
	Number numberA;
	Number numberB;
	Number numberA1;
	Number numberB1;
	//czas startu i końca
	clock_t start;
	clock_t end;
	//struktura przechowująca całkowity czas
	timeMeasure timeRun;
	timeRun.sisd = 0;
	timeRun.simd = 0;
	//pomiar dodawania
	for(int i=0; i<10; i++){
		for(int j=0; j<n; j++){
			random_vec(&numberA);
			random_vec(&numberB);
			numberA1=numberA;
			numberB1=numberB;
			start = clock();
			subSISD(&numberA, numberB);
			end = clock();
			timeRun.sisd+=(double)(end-start)/CLOCKS_PER_SEC;
			start = clock();
			subSIMD(&numberA1, numberB1);
			end = clock();
			timeRun.simd+=(double)(end-start)/CLOCKS_PER_SEC;
		}
	}
	timeRun.sisd/=10;
	timeRun.simd/=10;

	return timeRun;
}

//pomiar czasu mnożenia
timeMeasure measureMul(int n){
	//liczby mnożone
	Number numberA;
	Number numberB;
	Number numberA1;
	Number numberB1;
	//czas startu i końca
	clock_t start;
	clock_t end;
	//struktura przechowująca całkowity czas
	timeMeasure timeRun;
	timeRun.sisd = 0;
	timeRun.simd = 0;
	//pomiar dodawania
	for(int i=0; i<10; i++){
		for(int j=0; j<n; j++){
			random_vec(&numberA);
			random_vec(&numberB);
			numberA1=numberA;
			numberB1=numberB;
			start = clock();
			mulSISD(&numberA, numberB);
			end = clock();
			timeRun.sisd+=(double)(end-start)/CLOCKS_PER_SEC;
			start = clock();
			mulSIMD(&numberA1, numberB1);
			end = clock();
			timeRun.simd+=(double)(end-start)/CLOCKS_PER_SEC;
		}
	}
	timeRun.sisd/=10;
	timeRun.simd/=10;

	return timeRun;
}


//pomiar czasu dzielenia
timeMeasure measureDiv(int n){
	//liczby dzielone
	Number numberA;
	Number numberB;
	Number numberA1;
	Number numberB1;
	//czas startu i końca
	clock_t start;
	clock_t end;
	//struktura przechowująca całkowity czas
	timeMeasure timeRun;
	timeRun.sisd = 0;
	timeRun.simd = 0;
	//pomiar dodawania
	for(int i=0; i<10; i++){
		for(int j=0; j<n; j++){
			random_vec(&numberA);
			random_vec(&numberB);
			numberA1=numberA;
			numberB1=numberB;
			start = clock();
			divSISD(&numberA, numberB);
			end = clock();
			timeRun.sisd+=(double)(end-start)/CLOCKS_PER_SEC;
			start = clock();
			divSIMD(&numberA1, numberB1);
			end = clock();
			timeRun.simd+=(double)(end-start)/CLOCKS_PER_SEC;
		}
	}
	timeRun.sisd/=10;
	timeRun.simd/=10;

	return timeRun;
}

int main(){
	//otwarcie pliku do zapisu
	FILE *file;
	if(!(file=fopen("wynik.txt", "w"))){
		printf("Nie udalo sie otworzyc pliku wynik.txt");
		return 0;
	}
	//zmienne wektorów używane do obliczeń
	Number numberA;
	Number numberB;
	//czas wykonywania
	
	timeMeasure timeRun = measureAdd(512);
	//wynik do pliku
	fprintf(file, "Czas dodawania dla 2048 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	timeRun = measureAdd(1024);
	//wynik do pliku
	fprintf(file, "Czas dodawania dla 4096 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	timeRun = measureAdd(2048);
	//wynik do pliku
	fprintf(file, "Czas dodawania dla 8192 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);

	timeRun = measureSub(512);
	//wynik do pliku
	fprintf(file, "Czas odejmowania dla 2048 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	timeRun = measureSub(1024);
	//wynik do pliku
	fprintf(file, "Czas odejmowania dla 4096 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	timeRun = measureSub(2048);
	//wynik do pliku
	fprintf(file, "Czas odejmowania dla 8192 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);

	timeRun = measureMul(512);
	//wynik do pliku
	fprintf(file, "Czas mnozenia dla 2048 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	timeRun = measureMul(1024);
	//wynik do pliku
	fprintf(file, "Czas mnozenia dla 4096 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	timeRun = measureMul(2048);
	//wynik do pliku
	fprintf(file, "Czas mnozenia dla 8192 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);

	timeRun = measureDiv(512);
	//wynik do pliku
	fprintf(file, "Czas dzielenia dla 2048 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	timeRun = measureDiv(1024);
	//wynik do pliku
	fprintf(file, "Czas dzielenia dla 4096 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	timeRun = measureDiv(2048);
	//wynik do pliku
	fprintf(file, "Czas dzielenia dla 8192 liczb: \nSISD: %f \nSIMD: %f \n\n", timeRun.sisd, timeRun.simd);
	return 0;
} 
