#include <CppUTest/TestHarness.h>
#include<CppUTest/TestHarness_c.h>

extern"C"{
	// #include <xxxx.h> // Header files from production code is included here
	#include "list.h"
};
TEST_GROUP(TestLinkedList){
	void setup(){}
	void teardown(){}
};



TEST(TestLinkedList, Test_AddItem) {
	
	Node* head = NULL;

	for (int i = 1; i < 10; i++) {
		addItem(&head, i+i);
	}
	printf("Number of Items: %d",noOfItems(head));
	
	FreeNodes(head);
}
