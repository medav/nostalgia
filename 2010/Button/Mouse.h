#ifndef _MOUSE_H
#define _MOUSE_H
#include "DirectX.h"
extern int MouseX;
extern int MouseY;
extern bool Mouse_Active;
bool MouseOverRect(RECT r);
void uMouse();
void Activate_Mouse();
void Mouse_Init();
#endif