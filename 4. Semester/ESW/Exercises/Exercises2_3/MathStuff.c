
int esw_power(int x, int y) {

	int sum = 1;

	for (int i = 0; i < y; i++) {
		sum = sum * x;
	}

	return sum;
}

void esw_multiSwap(int *x, int *y, int *z) {
	
	int temp = *z;
	*z = *x;
	*x = *y;
	*y = temp;

}