/*
	I will write test for each of the following methods and for some check if the number of items changes aswell.
*/
struct Node {
	struct Node* next;
	int data;
};

int addItem(struct Node** head, int new_data);// Return 0 if item added else -1
void* getItem(uint16_t index);// Return pointer to item at given indexin the list
int noOfItems(struct Node* head);// Return no of items in list
int removeItem(void* item);// Return 0 if item removed else -1


void FreeNodes(struct Node* head); //Frees memory of all nodes