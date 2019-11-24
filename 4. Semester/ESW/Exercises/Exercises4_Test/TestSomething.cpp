#include <CppUTest/TestHarness.h>
#include <CppUTest/TestHarness_c.h>


extern"C"{
	// #include <xxxx.h> // Header files from production code is included here
	//#include "list.h"
};
TEST_GROUP(TestSomething){
	void setup(){}
	void teardown(){}
};

TEST(TestSomething, TestCountItems){

	struct Node* head = NULL;
	for (int i = 0; i < 10; i++) {
		//addItem(head, i);
	}

}
 