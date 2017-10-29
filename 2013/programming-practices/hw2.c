/**
 * Michael Davies
 * mdavies@iastate.edu
 * CprE 185 Section E
 * Programming Practice 2
 *
 * Reflection 1:
 * 		Here is my attempt at a basic "Linked List" implementation.
 * 		The idea is that you have a list of object linked to eachother
 * 		by pointer in a linear list. You access elements by searching
 * 		the list in order from the beginning.
 *
 * Reflection 2:
 * 		I was successful. I have done similar things to this before,
 * 		so it was relatively easy to bring it all together into a
 * 		program like this.
 *
 * Reflection 3:
 * 		If I were to start this over, I would implement jump tables
 * 		in the ITEMLIST struct. That way a user of this code could
 * 		have some sense of data containment and object -
 * 		orientedness through the use of function pointers in the
 * 		ITEMLIST struct.
 *
 * Reflection 4:
 * 		I learned how to implement a dynamicly sizing item list that
 * 		can eventually be scaled up to store any kind of data, be it
 * 		just text, or strictly formatted data (ex. bib citations,
 * 		etc...)
 *
 */


#include <string.h>
#include <stdio.h>
#include <stdlib.h>

struct ITEM {
	char name[50];
	char value[100];

	struct ITEM * prev;
	struct ITEM * next;
};

struct ITEMLIST {
	struct ITEM * first;
	struct ITEM * last;
};

int init_linked_list(struct ITEMLIST * IL);
struct ITEM * get_item(struct ITEMLIST * IL, char * itemName);
int add_item(struct ITEMLIST * IL, struct ITEM * I);
int rmv_item(struct ITEMLIST * IL, char * itemName);
void free_list(struct ITEMLIST * IL);

struct ITEM * new_item(char * itemName, char * itemValue);

void usr_add_item(struct ITEMLIST * IL);
void usr_rmv_item(struct ITEMLIST * IL);
void view_items(struct ITEMLIST * IL);

int main() {
	// Declare the item list
	struct ITEMLIST IL;

	// Let the init function set it up
	init_linked_list(&IL);

	int cmd;
	cmd = 0;

	// Here is a menu loop that allows the user
	// to perform basic operations on the list
	while(cmd < 4)
	{
		printf("\n\n========================\n");
		printf("1. Add Item\n");
		printf("2. Remove Item\n");
		printf("3. View Items\n");
		printf("4. Quit\n");
		printf(">");

		scanf("%d", &cmd);
		printf("\n");

		switch(cmd)
		{
		case 1:
			usr_add_item(&IL);
			break;
		case 2:
			usr_rmv_item(&IL);
			break;
		case 3:
			view_items(&IL);
			break;
		case 4:
			break;
		default:
			printf("\nInvalid Option.\n");
			break;
		}
		printf("========================\n");
	}
	free_list(&IL);

	return 0;
}

void usr_add_item(struct ITEMLIST * IL) {
	// Here we are going to ask for item
	// data, then let new_item create a
	// ITEM for us. We then will pass it to
	// add_item to add it to our list
	char itemName[50];
	char itemValue[100];

	printf("Item Name : ");
	scanf("%s", itemName);

	printf("Value : ");
	scanf("%s", itemValue);

	// Make the new item
	struct ITEM * I = new_item(itemName, itemValue);

	// Add it to our list
	add_item(IL, I);
}

void usr_rmv_item(struct ITEMLIST * IL) {
	// We ask for the item to remove here,
	// then allow rmv_item look for it, and
	// remove it if necessary
	char itemName[50];

	printf("Item Name : ");
	scanf("%s", itemName);

	// remove the item (if it exists)
	rmv_item(IL, itemName);
}

void view_items(struct ITEMLIST * IL) {
	// This loops through the whole list and
	// displays the data from each item
	struct ITEM * I;

	I = IL->first;
	printf("Items:\n\n");

	// Simply iterate through the list and
	// print data found
	while(I)
	{
		printf("Item Name : %s\n", I->name);
		printf("Value : %s\n\n", I->value);

		I = I->next;
	}
}

void free_list(struct ITEMLIST * IL) {
	// This is similar to "view_list"
	// but instead of printing item data,
	// it simply frees the memory used
	struct ITEM * I;
	struct ITEM * nextI;

	I = IL->first;

	while(I)
	{
		nextI = I->next;
		// free the malloc's!
		free(I);
		I = nextI;
	}
}


int init_linked_list(struct ITEMLIST * IL) {
	// This sets the linked list's values to 0
	IL->first = 0;
	IL->last = 0;
	return 1;
}

int add_item(struct ITEMLIST * IL, struct ITEM * I) {
	// This routine adds an Item to the list. It first
	// calls get_item to make sure an item with the
	// same name doesn't already exist. If it does, then
	// this routine will do nothing and return.

	if(get_item(IL, I->name) != 0) {
		printf("Item already exists!\n");
		return 0;
	}

	I->next = 0;
	I->prev = 0;

	// Check if this is the first item being added
	// to the list
	if(IL->last) {
		// Make this the last item by setting
		// the previous last item's next value
		// to this item, set this items prev value
		// to the previous last item, and set the
		// list's last item to this new item
		IL->last->next = I;
		I->prev = IL->last;
		IL->last = I;
	}
	else {
		// no need to link to other items,
		// just set as first and last item
		// in list
		IL->first = I;
		IL->last = I;
	}

	return 1;
}

int rmv_item(struct ITEMLIST * IL, char * itemName) {
	// This routine removes an item from the list.
	// It first searches the list for the item. If it
	// does not exist, this routine does nothing and
	// returns. If it does, it will appropriately
	// relink the list so that the item is removed, then
	// free the memory used by the item.
	struct ITEM * I = get_item(IL, itemName);

	// If I is not found, we are done!
	if(!I) {
		return 0;
	}

	// If I has a prev value - not the first
	// value in the list, we need to re link
	// the previous item's next to this item's
	// next before we remove it
	if(I->prev)
		I->prev->next = I->next;
	else {
		if(I->next)
			IL->first = I->next;
		else
			IL->first = 0;
	}

	// Same idea for next item
	if(I->next)
		I->next->prev = I->prev;
	else {
		if(I->prev)
			IL->last = I->prev;
		else
			IL->last = 0;
	}

	// free the malloc's!
	free(I);

	return 1;
}

struct ITEM * get_item(struct ITEMLIST * IL, char * itemName) {
	// This function searches through a list and returns
	// a pointer to the item whos name matches the given
	// itemName. If it does not exist, this will return
	// a null pointer
	struct ITEM * I = IL->first;

	if(!I)
		return 0;

	// iterate through the list while we still
	// haven't found the item we are looking for
	while(strcmp(I->name,itemName) != 0) {
		if(I->next)
			I = I->next;
		else
			return 0;
	}

	// This is the item we are looking for
	return I;
}

struct ITEM * new_item(char * itemName, char * itemValue) {
	// This function creates a new Item, and
	// allocates memory for it. From there,
	// it will fill the item with the given
	// values and return the result.
	struct ITEM * I = malloc(sizeof(struct ITEM));

	strncpy(I->name, itemName, 50);
	strncpy(I->value, itemValue, 100);

	I->next = 0;
	I->prev = 0;

	return I;
}


