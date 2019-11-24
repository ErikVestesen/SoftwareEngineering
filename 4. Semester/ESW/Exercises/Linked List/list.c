#include <stdint.h>
#include <stdio.h>
#include "list.h"


/*
	I will test the linked list for following:
	-	Adding an item and checking the number of items is plus one
	-	Getting the number of items in the list
	-	Getting the pointer of a certain item
	-	Removing an item and check the number of items is minus one
*/

struct Node
{
	int data;
	struct Node* next;
};

int addItem(void* item) { // Return 0 if item added else -1
	item = (struct Node*)malloc(sizeof(struct Node));



	return 0;
}

void* getItem(uint16_t index) { // Return pointer to item at given index in the list

}

int noOfItems(struct Node* node) {  // Return no of items in list
	int counter = 0;

	while (node != NULL) {
		counter++;
		printf("Data: %d \n", node->data);
		node = node->next;
	}
	return counter;
}
int removeItem(void* item) { // Return 0 if item removed else -1

}