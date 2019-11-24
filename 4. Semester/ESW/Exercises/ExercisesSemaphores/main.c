void taskATask(void pvParameters) {
	
	//Remove compiler warnings
	(void)pvParameters;

		for (;;) {
			puts("R");
			xSemaphoreGive(_bSem);
			xSemaphoreTake(_aSem, portMAX_DELAY);
			puts("OK");

			vTaskSuspend(NULL);
		}

		/*
		taskBTask
			xSemaphoreTake(_bSem);
			puts("I");
			xSemaphoreGive(_cSem);
			xSemaphoreGive(_bSem, portMAX_DELAY);
			puts("OK");

			vTaskSuspend(NULL);
		*/
}

void main(void) {
	xTaskCreate(
		taskATask,
		"Task A", // text name for the task
		TASK_A_STACK, //stack size in words, not bytes
		(void*)1, //parameter passed into the task
		TASK_A_PRIORITY, // Task prio
	)
}
