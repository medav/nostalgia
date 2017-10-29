/**
 * Michael Davies
 * mdavies@iastate.edu
 * CprE 185 Section E
 * Programming Practice 1
 *
 * Reflection 1:
 *	I ws trying to make a simple 4 function calculator that could add,
 *	subtract, multiply, or divide 2 numbers. I also wanted to play with
 *	jump tables in C.
 *
 * Reflection 2:
 *	I was successful. The program can handle any two numbers that fit in
 *	the 'double' data type.
 *
 * Reflection 3:
 *	If I were to do it again, I would leave out the jump table as it
 *	is uneccessary for this specific use case. It only makes it look
 *	more complicated.
 *
 * Reflection 4:
 *	I learned more about scanf and how the input stream is read with this
 *	practice.
 */

#include <stdio.h>

// The 'jump table'. Basically it's a struct of function pointers.
// It's kind of a way to 'cheat' to make C somewhat object oriented :)
struct calculator {
	double (*add)(double, double);
	double (*sub)(double, double);
	double (*mul)(double, double);
	double (*div)(double, double);
};

// These 4 functions are pretty straight foward,
// they just do the 4 basic math functions
double add(double a, double b) {
	return a+b;
}

double sub(double a, double b) {
	return a-b;
}

double mul(double a, double b) {
	return a*b;
}

double div(double a, double b) {
	return a/b;
}

// Main - sets up the jump table,
// asks for input from the user, then based
// on the input, performs 1 of the 4 basic
// math operations and displays the result.
int main(int argc, char * argv[]) {
	double a,b;
	char c;
	double result;

	// Fill the table
	struct calculator calc = {add, sub, mul, div};

	printf("Simple 4-function calculator\n");
	printf("Enter expression in format of a (+|-|*|/) b below:\n");

	// Ask for an expression
	scanf("%lf%c%lf", &a, &c, &b);

	// Call the function we want
	switch(c) {
	case '+':
		result = calc.add(a, b);
		break;
	case '-':
		result = calc.sub(a, b);
		break;
	case '*':
		result = calc.mul(a, b);
		break;
	case '/':
		result = calc.div(a, b);
		break;
	default:
		printf("Invalid action!\n");
		// Exit now so we don't print "=0.0000000"
		return 0;
	}

	// Display the result
	printf("=%.2lf\n", result);

	return 0;
}
