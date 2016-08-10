
#include "characters.c"



void display() {
     int row;
     int index;
     int rRow,rCol;
     int value = 0;

     for(row = 0; row < 5; row++) {
         for(index = 0; index < 25; index++) {
              LATB = 0x00;
              delay_ms(100);
              rRow = index % 5;
              rCol = (index - rRow)/5;
              value = cube[row][rRow][rCol] << 1;

              LATB = value;
              LATB |= 0x01;
              delay_ms(500);
         }
     }
     LATB = 0x00;
}

void draw()
{

}

void main() {
     int row;
     int rRow,rCol;
     TRISB = 0;

     for(row = 0; row < 5; row++) {
         for(rRow = 0; rRow < 5; rRow++) {
              for(rCol = 0; rCol < 5; rCol++) {
                   cube[row][rRow][rCol] = 1;
              }
         }
     }

     draw_chr('a',1);

     while(1)
     {
          draw();
          display();
     }
}