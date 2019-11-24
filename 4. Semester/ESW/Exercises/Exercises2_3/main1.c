#include <stdio.h>
/*
Exercise 3.1 Working with integers, floats and doubles
Notes about basic data types:

when using the / operator, use floats instead of integers.
when using the % operator, use integers instead of floats.

*/
int main1(void) {
	//Divide operator
	float a, b;

	a = 7;
	b = 3;

	printf("%d // %d = %d\n", a, b, a / b);

	//Modulu operator
	int x, y;

	x = 7;
	y = 3;

	printf("%d %% %d = %d\n", x, y, x % y);

	return 0;
}
