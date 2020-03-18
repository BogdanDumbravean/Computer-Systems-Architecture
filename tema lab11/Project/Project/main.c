#include <stdio.h>
#include <string.h>

// the function declared in modulConcatenate.asm
int solve(int len, char sir[], char P[], char N[]);

int main()
{
	char sir[101];
	char P[51] = "";
	char N[51] = "";

	FILE *file;
	file = fopen("numbers.txt", "r");
	fgets(sir, 100, file);

	int aux = solve(strlen(sir), sir, P, N);

	printf("\nPositive numbers:\n");
	for (int i = 0; i < 50; ++i) {
		if (P[i] != 0)
			printf("%d ", P[i]);
	}

	printf("\nNegative numbers:\n");
	for (int i = 0; i < 50; ++i) {
		if (N[i] != 0)
			printf("%d ", -N[i]);
	}
	
	return 0;
}