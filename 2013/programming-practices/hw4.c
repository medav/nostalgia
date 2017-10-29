/**
 * Michael Davies
 * mdavies@iastate.edu
 * CprE 185 Section E
 * Programming Practice 4
 *
 * Reflection 1:
 * 		I was trying to play with function pointers some more,
 * 		and iterating through arrays with memory addresses
 *
 * Reflection 2:
 * 		I was successful. It was fun and cool to see how it all
 * 		works. Also, these kinds of concepts are scalable to more
 * 		complicated projects.
 *
 * Reflection 3:
 * 		If I were to do this over, I would do different operations,
 * 		allow for a user inputed list, etc...
 *
 * Reflection 4:
 * 		I learned how arrays deal with data - they simply line
 * 		up the values in the memory, allowing for pointers to
 * 		iterate through the array easily.
 *
 */
#include <stdio.h>

void addOne(int * num);
void squareOne(int * num);
void printNum(int * num);

void doOp(int * nums, int size, void (*func)(int *));

int main() {
	int numArray[] = {1, 2, 3, 4, 5};

	void (*disp)(int *);
	disp = printNum;

	void (*op)(int *);
	op = addOne;

	doOp(numArray, 5, disp);
	printf("\n");

	doOp(numArray, 5, op);

	doOp(numArray, 5, disp);
	printf("\n");

	op = squareOne;
	doOp(numArray, 5, op);

	doOp(numArray, 5, disp);
	printf("\n");


	return 0;
}

void addOne(int * num) {
	(*num)++;
}

void squareOne(int * num) {
	(*num) = (*num) * (*num);
}

void printNum(int * num) {
	printf("%d ", *num);
}


void doOp(int * nums, int size, void (*func)(int *)) {
	int * i;

	for(i = nums; i < size + nums; i++) {
		func(i);
	}
}
