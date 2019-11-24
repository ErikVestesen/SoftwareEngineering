#include <stdint.h>
int addItem(void* item);// Return 0 if item added else -1
void*getItem(uint16_t index);// Return pointer to item at given indexin the list
int noOfItems(struct Node* node);// Return no of items in list
int removeItem(void* item);