short cube[25];
int tdata;

void display() {
     int i;
     short temp;
     
    LATB = 0x00;

    for(i = 0; i < 25; i++)
    {
         LATB = 0x00;
         temp = cube[i];
         temp = temp << 1;
         LATB = temp;
         LATB = temp | 0x01;
         
    }

    //delay_ms(1);
    LATB = 0x00;
    //delay_ms(1);
    LATB = 0x04;
    //delay_ms(1);
    LATB = 0x00;
}

void draw()
{
     cube[(tdata - 1) % 26] = 0;
     cube[tdata] = 1;
     
     tdata++;
     tdata = tdata % 26;
}

void main() {
     int counter;
     short rowOn
     
     TRISB = 0;
     TRISC = 0;
     
     tdata = 0xFFFFFFFF;
     LATC = 0x01;


     while(1) {
         //if(counter > 100)
         //{
              //draw();
              //counter = 0;
         //}
         display();
         LATC = 0x01;
         //counter++;
     }
}