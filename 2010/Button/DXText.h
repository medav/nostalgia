#ifndef _DXTEXT_H
#define _DXTEXT_H
#include "DirectX.h"
class DXTEXT
{
public:
	void Init(int FontSize,LPCSTR Font);
	void PrintText(LPCSTR str, int x,int y,int a,int r,int g,int b);
	void Begin();
	void End();
	void Release();
	int T_FONTSIZE;
private:
	LPD3DXFONT T_d3dfont;
	ID3DXSprite*T_TextS;
};
#endif