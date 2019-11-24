#include <stdio.h>
#include "myStr.h"

int my_strlen(char* input) {
	char* p_input = input;
	int length = 0;

	while (*p_input != '\0') {
		length++;
		p_input++;
	}
	return length;
}

int my_strdiff(const char* a, const char* b) {
	char* p_a = a;
	char* p_b = b;
	 
	int result = -1;
	int counter = 0;

	//Check if one is empty and the other one isnt.
	if (*p_a != *p_b) {
		result = 0;
	}

	while (*p_a != '\0' && *p_b != '\0') {
		if (*p_a != *p_b && result == -1) {
			result = counter; 
		}
		p_a++;
		p_b++;
		counter++;
	}
	return result;
}

char* my_strcpy(char* dest, const char* src) {
	char* p_dest = dest;
	char* p_src = src;

	while (*p_src != '\0' && *p_dest != '\0') {
		*p_dest = *p_src;

		p_src++; p_dest++;
	}
	
	return *p_dest;
	
}

int main(void) {
	
	printf("Running \n \n");

	const char str1[] = "Hello World";
	const char str2[] = "";
	const char str3[] = "Hello, World";
	char str4[] = "Something";
	const char str5[] = "Yeeting this oof";
	printf("Size of: %s => %d \n",str1,my_strlen(str1));
	printf("Size of: %s => %d \n", str2, my_strlen(str2));
	printf("Size of: %s => %d \n \n", str3, my_strlen(str3));

	printf("Diff: '%s' compared to '%s' => %d \n", str1, str1, my_strdiff(str1,str1));
	printf("Diff: '%s' compared to '%s' => %d \n", str1, str2, my_strdiff(str1, str2));
	printf("Diff: '%s' compared to '%s' => %d \n", str2, str2, my_strdiff(str2, str2));
	printf("Diff: '%s' compared to '%s' => %d \n \n", str1, str3, my_strdiff(str1, str3));

	printf("Copy: '%s' to '%s' \n", str5, str4);
	char* p1 = my_strcpy(str4, str5);
	printf("Now is: '%s'", p1);


	return 0;
}