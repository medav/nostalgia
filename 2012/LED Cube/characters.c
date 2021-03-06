#include "globals.h"

static unsigned short CH_A[5][5][5] =
       {{{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,1,0,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,1,0,1,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,1,1,1,1}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}}};
        
static unsigned short CH_B[5][5][5] =
       {{{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,1,1,0,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,1,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,1,1,0,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,1,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,1,1,0,0}}};
        
static unsigned short CH_C[5][5][5] =
       {{{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,1,1,1,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,1,1,1,0}}};

static unsigned short CH_D[5][5][5] =
       {{{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,1,1,1,0}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,0,0,0,1}},
        {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{1,1,1,1,0}}};

static void write_chr(unsigned short * chr[5][5][5])
{
     int row;
     int rRow;
     int rCol;
     
     for(row = 0; row < 5; row++) {
         for(rRow = 0; rRow < 5; rRow++) {
             for(rCol = 0; rCol < 5; rCol++) {
                 cube[row][rRow][rCol] = (*chr)[row][rRow][rCol];
             }
         }
     }
}

static void draw_chr(char ch, int row)
{
     switch(ch)
     {
     case 'a':
     case 'A':
          write_chr(&CH_A);
          break;
     default:
          break;
     }
}

static void draw_chr_anim(int ch)
{
}