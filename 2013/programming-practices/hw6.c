/**
 * Michael Davies
 * mdavies@iastate.edu
 * CprE 185 Section E
 * Programming Practice 6
 *
 * Reflection 1:
 * 		I was trying to add to what we were doing in class -
 * 		Language analytics - by adding sentence and word counts.
 * 		Also, I wrote my own version of the histogram function
 * 		That gives more information.
 *
 * Reflection 2:
 * 		I was successful. It is interesting to see what happens when
 * 		large amount of english are passed to it because the histogram
 * 		generally takes on a specific form.
 *
 * Reflection 3:
 * 		If I were to do this over, I would figure out another way to
 * 		terminate the program than a key word. I would also add
 * 		paragraph counts and other analytics.
 *
 * Reflection 4:
 * 		I learned how to scan in strings one word at a time and how
 * 		to do simple analytics on input.
 *
 */
#include <stdio.h>
#include <string.h>

void printHisto(int * counts, int size);

int main() {
	printf("Start typing:\n");
	char word[20];
	char c;

	int words = 0;
	int sentences = 0;

	int i;

	int counts[26] = {0};

	do {
		words++;
		scanf("%s", word);
		for(i = 0; i < strlen(word); i++) {
			c = word[i];

			if(c == '.') sentences++;

			if(c > 90) c-=32;
			counts[c - 65]++;
		}
	} while(strcmp(word, "exit"));

	printHisto(counts, 26);
	printf("Words : %d\n", words);
	printf("Sentences : %d\n", sentences);
}

void printHisto(int * counts, int size) {
	int i, j;

	for(i = 0; i < size; i++) {
		if(counts[i] > 0) {
			printf("%c | ", (char) (i + 65));

			for(j = 0; j < counts[i]; j++, printf("="));

			printf("\n");
		}
	}
}

