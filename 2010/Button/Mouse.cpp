#include "Mouse.h"
LPDIRECT3DTEXTURE9 cursor=NULL;
int MouseX=0;
int MouseY=0;
bool Mouse_Active;
bool MouseOverRect(RECT r)
{
	if(MouseX>=r.left && MouseX<=r.right &&
		MouseY>=r.top && MouseY<=r.bottom)
		return true;
	return false;
}
void uMouse()
{
	Poll_Mouse();
	MouseX+=Mouse_X();
	MouseY+=Mouse_Y();
	D3DXVECTOR3 pos(MouseX,MouseY,0);
	sprite_handler->Draw(
				 cursor, 
				 NULL,
				 NULL,
				 &pos,
				 D3DCOLOR_XRGB(255,255,255));
}
void Activate_Mouse()
{
	uMouse();
	Mouse_Active=true;
	return;
}
void Mouse_Init()
{
	cursor=LoadTexture("Cursor.bmp",D3DCOLOR_XRGB(0,0,0));
}