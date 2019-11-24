#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "list.h"

// Return 0 if item added else -1
int addItem(struct Node** head, int new_data) {
	
	//New Node
	struct Node* new_node = (struct Node*) malloc(sizeof(struct Node));
	
	//Check if the memory has been succesfully allocated
	if (new_node == NULL) {
		printf("New node memory hasn't been allocated. \n");
		return -1;
	}
	printf("New node memory has succesfully been allocated. \n");

	//Set the data of new node
	new_node->data = new_data;
	
	//Assign the connection from the new node to head (soon to be old head) 
	new_node->next = *head;
	
	//Set the new node as head
	*head = new_node;

	//Test line
	printf("Data for new node: %d \n\n",new_data);

	//Free memory 
	//free(new_node);
	return 0;
}

// Return pointer to item at given index in the list
void*getItem(uint16_t index) {}

// Return no of items in list
int noOfItems(struct Node* head) {

	int counter = 0;
	while (head->next != NULL) {
		printf("noOfItems => Data: %d \n\n", head->data);
		counter++;
		head = head->next;
	}

	return counter;
}


// Return 0 if item removed else -1
int removeItem(void* item) {
	return 0;
}

void FreeNodes(struct Node* head) {
	struct Node* node;

	while (head->next != NULL) {
		node = head;
		head = head->next;
		free(node);
	}
	free(head);
}
