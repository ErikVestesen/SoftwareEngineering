/*
Exercise 3.2 How does string (character arrays) work in C
Notes about pointers:

In this exercise im setting the pointer to the last element minus 1 in the text 
and changing that to the zero char \0, which makes the printf think that the entire
char array is one character smaller.

All this happens because i set the reference of endS to the last element, 
which in this case is the zero character(text.length + 1) .
Then i deref endS to the zero character, which it already is, making it print out the same.
Now i make endS point towards the character behind the current and deref endS once again towars the zero character.
This makes it print the text.length - 1, because the print see the zero character before the actual text end.
*/

#include "MathStuff.h"

#include <stdio.h>
int main() {
	
	//char text[] = "The quick brown fox jumps over lazy dog";
	//char* endS = text + 39; /* Don't worry about this */
	//printf("The string now says: \"%s\n", text);
	//*endS = '\0';
	//printf("The string now says: \"%s\n", text);
	// Repeat the following three lines in your own example, but experiment
	// with different values than just subtracting 1 from endS
	//endS = endS - 1;
	//*endS = '\0';
	//printf("The string now says: \"%s\n", text);
	int x = 2;
	int y = 3;
	int power = esw_power(x,y);
	printf("Power of %d ^ %d is %d \n",x,y,power);

	int a = 2;
	int b = 3;
	int c = 4;
	printf("a => %d b => %d c => %d \n", a, b, c);
	esw_multiSwap(&a, &b, &c);
	printf("a => %d b => %d c => %d ", a, b, c);

	return 0;
}





void my_to_upper(char* str_in, char* str_out) {
	char* p_out = str_out;
	char* p_in = str_in;
	while (*p_in != '\0') {
		if (*p_in >= 'a' && *p_out <= 'z') {
			*p_out = *p_in - 32;
		}
		else {
			*p_out = *p_in;
		}
		p_in++;
		p_out++;
	}
	*p_out = *p_in;
}