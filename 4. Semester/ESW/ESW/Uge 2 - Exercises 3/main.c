#include <stdio.h>

//Exercise 3.1
/*
int main() {
	//Divide operator
	float a, b;

	a = 7;
	b = 3;
	printf("Divide operator:\n");
	printf("Using floats: %.2f / %.2f = %.2f\n", a, b, a / b);
	printf("Using integers: %d %% %d = %d\n", a, b, a / b);

	//Modulu operator
	int x, y;

	x = 7;
	y = 3;
	printf("\nModulus operator:\n");
	printf("Using integers: %d %% %d = %d\n", x, y, x % y);
	printf("Using floats: %d %% %d = %d\n", x, y, x % y);

}*/


//Exercise 3.2
int main() {
	char text[] = "The quick brown fox jumps over lazy dog"; 
	char*endS = text + 39; /* Don't worry about this */
	printf("The string now says: \"%s\n", text); *endS = '\0';
	printf("The string now says: \"%s\n", text);
	//Repeat the following three lines in your own example, but experiment 
	//with different values thanjust subtracting 1 from endS
	printf("End s: %s\n",endS);
	endS = endS -1;
	printf("End s: %s\n", endS);
	*endS = '\0';
	printf("*End s: %s\n", *endS);
	printf ("The string now says: \"%s\n", text);
	return 0;
}