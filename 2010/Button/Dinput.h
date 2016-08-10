#ifndef _DINPUT_H
#define _DINPUT_H

#include <dinput.h>

//function prototypes
int Init_DirectInput(HWND);
int Init_Keyboard(HWND);
void Poll_Keyboard();
int Key_Down(int);
void Kill_Keyboard();
void Poll_Mouse();
int Init_Mouse(HWND);
int Mouse_Button(int);
int Mouse_X();
int Mouse_Y();
void Kill_Mouse();
extern bool Mouse_Acquired;

//DirectInput objects, devices, and states
extern LPDIRECTINPUT8 dinput;
extern LPDIRECTINPUTDEVICE8 dimouse;
extern LPDIRECTINPUTDEVICE8 dikeyboard;
extern DIMOUSESTATE mouse_state;


#endif