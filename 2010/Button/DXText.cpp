#include "DXText.h"
void DXTEXT::Begin()
{
	T_TextS->Begin(D3DXSPRITE_ALPHABLEND);
}
void DXTEXT::End()
{
	T_TextS->End();
}
void DXTEXT::Release()
{
	T_TextS->Release();
	T_d3dfont->Release();
}
void DXTEXT::PrintText(LPCSTR str, int x,int y,int a,int r,int g,int b)
{
	if(r==NULL)
		r=0;
	if(g==NULL)
		g=0;
	if(b==NULL)
		b=0;
	if(a==NULL)
		a=255;
	RECT textbox;
	SetRect(&textbox,x,y,WIDTH,y+T_FONTSIZE);
    T_d3dfont->DrawText(T_TextS,
                      str,
                      strlen(str),
                      &textbox,
                      DT_LEFT,
                      D3DCOLOR_ARGB(a,r,g,b));
}
void DXTEXT::Init(int FontSize, LPCSTR Font)
{
	T_FONTSIZE=FontSize;
	D3DXCreateFont( d3ddev,FontSize, 0, FW_BOLD, 0, FALSE, DEFAULT_CHARSET, 
					OUT_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, 
					TEXT("Arial"), &T_d3dfont );
	D3DXCreateSprite(d3ddev,&T_TextS);
}
