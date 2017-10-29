/**
 * Michael Davies
 * mdavies@iastate.edu
 * CprE 185 Section E
 * Programming Practice 8
 *
 * Reflection 1:
 * 		I was trying to create a program that would take in some number
 * 		of bytes from the input stream and encrypt them using XOR
 * 		encryption.
 *
 * Reflection 2:
 * 		I was successful. It isn't the strongest algorithm by any means because
 * 		it essentially is a block cipher with a blocksize of 64 bytes. That and
 * 		the key gen algorithm doesn't do a great job of randomizing the password
 * 		data to create a strong key.
 *
 * Reflection 3:
 * 		If I were to do this over, I would develop a better key gen
 * 		algorithm. Possibly a standard hashing function to aid in making
 * 		a strong symmetric key.
 *
 * Reflection 4:
 * 		I learned how to use XOR encryption.
 *
 * Note on usage:
 * 		To encrypt a file use this:
 * 			./hw8 password < file > file.enc
 *
 * 		To decrypt a file use this:
 * 			./hw8 password < file.enc
 *
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void printUsage();
void crypt(char * key);
void getSaltedKey(char * password, char ** key);
void printBytes(char * data, int len);

int main(int argc, char * argv[]) {
	char * key;

	if(argc < 2)
		return 0;

	getSaltedKey(argv[1], &key);

	crypt(key);

	free(key);

	return 0;
}

void printBytes(char * data, int len) {
    int i;
    printf("[");

    for(i = 0; i < len; i++)
        printf("%2x ", data[i]);

    printf("]\n");
}

void printUsage() {
	printf("Usage for en/decryption:\n");
	printf("\t./hw8 <PASSWORD>\n");
}

void crypt(char * key) {
	char c, out;

	int i = 0;

	while(scanf("%c", &c) == 1) {
		out = c ^ key[i % 64];
		printf("%c", out);
		fflush(stdout);
		i++;
	}
}

void getSaltedKey(char * password, char ** key) {
	char salt[] = {0xDE, 0xAD, 0xFA, 0xCE, 0xBE, 0xEF, 0xAA, 0x11,
            		  0xED, 0xAD, 0xAF, 0x1E, 0xBE, 0xE1, 0x0A, 0x11};

	(*key) = malloc(64 * sizeof(char));

	int rounds = 10000;
	int r, i;
	char temp;

	for(i = 0; i < 64; i++) {
		(*key)[i] = password[i % strlen(password)];
	}

	for(r = 0; r < rounds; r++) {
		for(i = 0; i < 64; i++) {
			if(i % 2 == 0) {
				(*key)[i] -= salt[i % 16];
				(*key)[i] = (*key)[i] << 1;
			}
			else {
				(*key)[i] = (*key)[i] >> 1;
				(*key)[i] += salt[i % 16];
			}


		}

		temp = (*key)[63];
		memcpy((*key) + 1, (*key), 63);
		(*key)[0] = temp;
	}
}
