/**
 * Michael Davies
 * mdavies@iastate.edu
 * CprE 185 Section E
 * Programming Practice 3
 *
 * Reflection 1:
 * 		I was trying to make a simple program that would compute
 * 		all of the integer factor pairs of a number.
 *
 * Reflection 2:
 * 		I was successful. I created a similar program in Ti-Basic
 * 		(for the Ti-83+ family of calulators). Writing it in C
 * 		was quite a bit different, however.
 *
 * Reflection 3:
 * 		If I were to do this over, I would find a way to accept
 * 		larger numbers and maybe take advantage of multicore
 * 		processors to do computations
 *
 * Reflection 4:
 * 		I learned how to deal with incorrect input from the user -
 * 		i.e. if they were to type characters, or too large of a
 * 		number, etc...
 *
 */

#include <stdio.h>
#include <math.h>

void printFactors(unsigned long long int num) {
	// If the number they entered exceeds
	// the bounds, it will register as
	// 64 1's in binary or 0xFFFFFFFFFFFFFFFF
	// in hex
	if(num == 0xFFFFFFFFFFFFFFFF) {
		printf("Overflow!\n\n");
		return;
	}
	// Search range is 1 to sqrt(num)
	// This way we capture all pairs
	// without repeating.
	unsigned long long int searchRange = floor(sqrt(num));
	unsigned long long int i;

	// Search for factors, print as we go
	for(i = 1; i <= searchRange; i++) {
		if(num % i == 0)
			printf("%llu x %llu\n", i, num / i);
	}
	// Divider so they know we are done
	printf("===============\n\n");

}

int main() {
	unsigned long long int num = 0;
	int temp = 1;

	// Tell the user what our bounds are
	// we are not perfect - we can only go
	// as far as an unsigned 64-bit int
	// can hold
	printf("Enter a number between 0 and 18446744073709551614\n");

	// Loop to accept user input
	// Will exit when the user does not
	// enter an integer number
	while(temp == 1) {
		// Print first, ask later
		// this is to avoid the printFactors()
		// being called on what ever was left
		// when the user breaks the program
		// with a non-int value
		printFactors(num);
		temp = scanf("%llu", &num);

	}

	return 0;
}
