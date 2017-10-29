/**
 * Michael Davies
 * mdavies@iastate.edu
 * CprE 185 Section E
 * Programming Practice 7
 *
 * Reflection 1:
 * 		I was trying to create a program that would read in a matrix
 * 		in a specific format. In its current state it reads in only
 * 		square matrices to memory.
 *
 * Reflection 2:
 * 		I was successful. It was a little difficult getting the size
 * 		that the user wanted from what they inputed.
 *
 * Reflection 3:
 * 		If I were to do this over, I would figured out a way to do
 * 		non square matrices, as well as using 2D arrays instead
 * 		of a 1D array for storing the data.
 *
 * Reflection 4:
 * 		I learned how to scan in data in a varying size format.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define dbg(M) printf("%s:%d:%s : ", __FILE__, __LINE__, __func__); \
			   printf(M); \
			   printf("\n");

struct matrix {
	double * data;
	int rows;
	int cols;
};

struct matrix * readMatrix();
void putData(struct matrix * m, double * rowArr, int rowNum);
void printMatrix(struct matrix * m);

int main() {

	struct matrix * m;
	m = readMatrix();
	printMatrix(m);

	return 0;
}

struct matrix * readMatrix() {
	struct matrix * m = malloc(sizeof(struct matrix));
	int sz = 0, i, j;
	char row[100];
	double data[100];
	double d;
	char c;
	i = 0;
	j = 0;

	while(1) {
		scanf("%lf", &d);
		c = getchar();

		data[j] = d;

		j++;

		if(c == '\n') {
			if(i == 0) {
				sz = j;
				m->rows = sz;
				m->cols = sz;

				m->data = malloc(sz * sz * sizeof(double));
			}

			putData(m, data, i);

			i++;
			j=0;
		}

		if(i == sz - 1 && j == sz - 1)
			break;

	}
	scanf("%lf", &d);
	data[j] = d;

	putData(m, data, i);

	return m;
}



void putData(struct matrix * m, double * rowArr, int rowNum) {
	int i;
	for(i = 0; i < m->rows; i++) {
		m->data[rowNum * m->cols + i] = rowArr[i];
	}
}

void printMatrix(struct matrix * m) {
	int i, j;
	printf("[");
	for(i = 0; i < m->rows; i++) {
		if(i > 0)
			printf(" ");

		printf("[");
		for(j = 0; j < m->cols; j++) {
			printf("%.1lf", m->data[i * m->cols + j]);
			if(j < m->cols - 1)
				printf(",");
		}
		printf("]");

		if(i < m->rows - 1)
			printf("\n");
	}
	printf("]\n");
}
