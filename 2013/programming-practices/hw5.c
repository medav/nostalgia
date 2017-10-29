/**
 * Michael Davies
 * mdavies@iastate.edu
 * CprE 185 Section E
 * Programming Practice 5
 *
 * Reflection 1:
 * 		I was playing with the idea of an algorithm and how
 * 		different algorithms can make a task 100s of times
 * 		faster than others. I used an example of a fibinacci
 * 		sequence generator to do this. The first algorithm uses
 * 		recursion to compute a specific value. The second
 * 		uses a linear sequence to compute values. If you run
 * 		the code, you will see how the first one hangs when
 * 		computing the 40th value, while the second one does not.
 * 		This is due to the algorithm design.
 *
 * Reflection 2:
 * 		I was successful. It was fun and cool to see how it all
 * 		works. It really shows how a design of a program, when
 * 		scaled up thousands of times, can make a program
 * 		considerably slower than a more efficient design.
 *
 * Reflection 3:
 * 		If I were to do this over, I would add a way to time the
 * 		two algorithms to give a rough estimate of how much
 * 		faster the linear algorithm is.
 *
 * Reflection 4:
 * 		I learned that recursion is generally not a good idea.
 * 		In a lot of cases, recursion can lead to memory
 * 		leaks (when not handled correctly). Recursion also
 * 		has a tendancy to make for less efficient algorithms
 *
 */

#include <stdio.h>



// Algorithm 1
int fib(int a) {
	if(a < 2)
		return 1;

	return fib(a-1) + fib(a-2);
}

// Algorithm 2
int fib2(int a) {
	int current = 1;
	int prev = 1;
	int temp;
	int index;

	// offset to make it calculate the correct
	// values for each index (to match with
	// Algorithm 1)
	a-=2;

	for(index = 0; index <= a; index++) {
		temp = current;
		current = current + prev;
		prev = temp;
	}

	return current;

}


int main() {
	int i;
	printf("Algorithm 1 (recursive)\n");

	// Alg 1
	for(i = 0; i <= 10; i++)
		printf("%d : %d\n", i, fib(i));

	printf("%d : %d\n", 40, fib(40));

	printf("\n\nAlgorithm 2 (linear)\n");

	// Alg 2
	for(i = 0; i <= 10; i++)
		printf("%d : %d\n", i, fib2(i));

	printf("%d : %d\n", 40, fib2(40));

	return 0;
}
