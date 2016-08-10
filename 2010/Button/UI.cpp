#include "DirectX.h"
#include "Mouse.h"
#include "DXText.h"
#include <string>
#include "LuaF.h"




class BUTTON
{
public:

	void Init(float x,float y,float w,float h,LPCSTR text)
	{
		click=0;
		txt=text;
		int f;
		f=29-strlen(text);
		if(f<2) 
			f=12;
		dxt.Init(f,"arial");
		B.left=x;
		B.right=x+w;
		B.top=y;
		B.bottom=y+h;
		B1.bottom=B.bottom+2;
		B1.left=B.left+2;
		B1.right=B.right+2;
		B1.top=B.top+2;

		d3ddev->CreateOffscreenPlainSurface(w,h,D3DFMT_X8R8G8B8,D3DPOOL_DEFAULT,&b,NULL);
		d3ddev->CreateOffscreenPlainSurface(w,h,D3DFMT_X8R8G8B8,D3DPOOL_DEFAULT,&sh,NULL);
		d3ddev->ColorFill(b,NULL,D3DCOLOR_XRGB(128,128,128));
		d3ddev->ColorFill(sh,NULL,D3DCOLOR_XRGB(0,0,0));

	}
	 void inline update()
	{
		click=0;

		
		d3ddev->StretchRect(sh,NULL,backbuffer,&B1,D3DTEXF_NONE);
		if(MouseOverRect(B))
		{
			if(Mouse_Button(0))
			{
				click=1;

				d3ddev->StretchRect(b,NULL,backbuffer,&B1,D3DTEXF_NONE);
				dxt.Begin();
				dxt.PrintText(txt,(B1.left+B1.right)/2-strlen(txt)*dxt.T_FONTSIZE/4,(B1.top+B1.bottom)/2-dxt.T_FONTSIZE/2,255,255,255,255);
				dxt.End();
			}
		}
			

		if(click==0)
		{
			
			d3ddev->StretchRect(b,NULL,backbuffer,&B,D3DTEXF_NONE);
			dxt.Begin();
			dxt.PrintText(txt,(B.left+B.right)/2-strlen(txt)*dxt.T_FONTSIZE/4,(B.top+B.bottom)/2-dxt.T_FONTSIZE/2,255,255,255,255);
			dxt.End();
		}
	}
		
	bool activated()
	{
		return click;
	}
	void deactivate()
	{
		click=false;
	}
protected:
	LPCSTR txt;
	DXTEXT dxt;
	LPDIRECT3DSURFACE9 sh,b;
	bool click;
	RECT B,B1;
};
/*
class BUTTONALT
{
public:

	void Init(float x,float y,float w,float h,
				char*fButton,char*fOverButton,
				LPCSTR t)
	{
		txt=t;
		MouseOverB=NULL;
		Button=NULL;
		click=0;
		B.left=x;
		B.right=x+w;
		B.top=y;
		B.bottom=y+h;
		Button=LoadTexture(fButton,D3DCOLOR_XRGB(0,0,0));
		MouseOverB=LoadTexture(fOverButton,D3DCOLOR_XRGB(0,0,0));
		int x1=x,y1=strlen(t);
		text.Init(16,"arial");
	}
	 void inline update()
	{
		click=0;
		D3DXVECTOR3 pos(0,0,0);
		pos.x=B.left;
		pos.y=B.top;
		
		sprite_handler->Draw(
				 Button, 
				 NULL,
				 NULL,
				 &pos,
				 D3DCOLOR_XRGB(255,255,255));
		
		if(MouseOverRect(B))
		{
			sprite_handler->Draw(
			 MouseOverB, 
			 NULL,
			 NULL,
			 &pos,
			 D3DCOLOR_XRGB(255,255,255));
			if(Mouse_Button(0))
			{
				click=1;
			}
		}
		sprite_handler->End();
		text.Begin();
		text.PrintText(txt,((B.left+B.right)/2)-(strlen(txt)/2*8),(B.bottom+B.top)/2-5,255,0,0,0);
		text.End();
		sprite_handler->Begin(D3DXSPRITE_ALPHABLEND);
	}
		
	bool activated()
	{
		return click;
	}
	void deactivate()
	{
		click=false;
	}
protected:
	LPDIRECT3DTEXTURE9 Button;
	LPDIRECT3DTEXTURE9 MouseOverB;
	DXTEXT text;
	bool click;
	LPCSTR txt;
	RECT B;
};
class TEXTDLG
{
public:
	void Init(RECT r,char*bgfile)
	{
		pointer=1;
		active=0;
		enter=0;
		dtext="";
		rect=r;
		TXT.Init(rect.bottom-rect.top-4,"arial");
		bg=LoadTexture(bgfile,D3DCOLOR_XRGB(0,0,0));

	}
	LPCSTR state()
	{
		return dtext;
	}
	void update()
	{
		enter=0;
		if(MouseOverRect(rect) && Mouse_Button(0))
			active=1;
		if(!MouseOverRect(rect) && Mouse_Button(0))
			active=0;
		if(active==1)
		{
			Poll_Keyboard();
			if(Key_Down(DIK_A))
			{
				while(Key_Down(DIK_A)){
					uMouse();
					Poll_Keyboard();}
				dtext=addp(dtext,"a");
			}
			if(Key_Down(DIK_B))
			{
				while(Key_Down(DIK_B)){
					uMouse();
					Poll_Keyboard();}
				dtext=addp(dtext,"b");
			}
			if(Key_Down(DIK_C))
			{
				while(Key_Down(DIK_C)){
					uMouse();
					Poll_Keyboard();}
				dtext=addp(dtext,"c");
			}
			if(Key_Down(DIK_D))
			{
				while(Key_Down(DIK_D)){
					uMouse();
					Poll_Keyboard();}
				dtext=addp(dtext,"d");
			}

			if(Key_Down(DIK_E))
			{
				while(Key_Down(DIK_E)){
					uMouse();
					Poll_Keyboard();}
				dtext=addp(dtext,"e");
			}
			if(Key_Down(DIK_F))
			{
				while(Key_Down(DIK_F)){
					uMouse();
					Poll_Keyboard();}
				dtext=addp(dtext,"f");
			}
			if(Key_Down(DIK_G))
			{
				while(Key_Down(DIK_G)){
					uMouse();
					Poll_Keyboard();}
				dtext=addp(dtext,"g");
			}
			if(Key_Down(DIK_H))
			{
				while(Key_Down(DIK_H))
					Poll_Keyboard();
				dtext=addp(dtext,"h");
			}

			if(Key_Down(DIK_I))
			{
				while(Key_Down(DIK_I))
					Poll_Keyboard();
				dtext=addp(dtext,"i");
			}
			if(Key_Down(DIK_J))
			{
				while(Key_Down(DIK_J))
					Poll_Keyboard();
				dtext=addp(dtext,"j");
			}
			if(Key_Down(DIK_K))
			{
				while(Key_Down(DIK_K))
					Poll_Keyboard();
				dtext=addp(dtext,"k");
			}
			if(Key_Down(DIK_L))
			{
				while(Key_Down(DIK_L))
					Poll_Keyboard();
				dtext=addp(dtext,"l");
			}

			if(Key_Down(DIK_M))
			{
				while(Key_Down(DIK_M))
					Poll_Keyboard();
				dtext=addp(dtext,"m");
			}
			if(Key_Down(DIK_N))
			{
				while(Key_Down(DIK_N))
					Poll_Keyboard();
				dtext=addp(dtext,"n");
			}
			if(Key_Down(DIK_O))
			{
				while(Key_Down(DIK_O))
					Poll_Keyboard();
				dtext=addp(dtext,"o");
			}
			if(Key_Down(DIK_P))
			{
				while(Key_Down(DIK_P))
					Poll_Keyboard();
				dtext=addp(dtext,"p");
			}

			if(Key_Down(DIK_Q))
			{
				while(Key_Down(DIK_Q))
					Poll_Keyboard();
				dtext=addp(dtext,"q");
			}
			if(Key_Down(DIK_R))
			{
				while(Key_Down(DIK_R))
					Poll_Keyboard();
				dtext=addp(dtext,"r");
			}
			if(Key_Down(DIK_S))
			{
				while(Key_Down(DIK_S))
					Poll_Keyboard();
				dtext=addp(dtext,"s");
			}
			if(Key_Down(DIK_T))
			{
				while(Key_Down(DIK_T))
					Poll_Keyboard();
				dtext=addp(dtext,"t");
			}

			if(Key_Down(DIK_U))
			{
				while(Key_Down(DIK_U))
					Poll_Keyboard();
				dtext=addp(dtext,"u");
			}
			if(Key_Down(DIK_V))
			{
				while(Key_Down(DIK_V))
					Poll_Keyboard();
				dtext=addp(dtext,"v");
			}
			if(Key_Down(DIK_W))
			{
				while(Key_Down(DIK_W))
					Poll_Keyboard();
				dtext=addp(dtext,"w");
			}
			if(Key_Down(DIK_X))
			{
				while(Key_Down(DIK_X))
					Poll_Keyboard();
				dtext=addp(dtext,"x");
			}

			if(Key_Down(DIK_Y))
			{
				while(Key_Down(DIK_Y))
					Poll_Keyboard();
				dtext=addp(dtext,"y");
			}
			if(Key_Down(DIK_Z))
			{
				while(Key_Down(DIK_Z))
					Poll_Keyboard();
				dtext=addp(dtext,"z");
			}

			if(Key_Down(DIK_1))
			{
				while(Key_Down(DIK_1))
					Poll_Keyboard();
				dtext=addp(dtext,"1");
			}
			if(Key_Down(DIK_2))
			{
				while(Key_Down(DIK_2))
					Poll_Keyboard();
				dtext=addp(dtext,"2");
			}
			if(Key_Down(DIK_3))
			{
				while(Key_Down(DIK_3))
					Poll_Keyboard();
				dtext=addp(dtext,"3");
			}
			if(Key_Down(DIK_4))
			{
				while(Key_Down(DIK_4))
					Poll_Keyboard();
				dtext=addp(dtext,"4");
			}

			if(Key_Down(DIK_5))
			{
				while(Key_Down(DIK_5))
					Poll_Keyboard();
				dtext=addp(dtext,"5");
			}
			if(Key_Down(DIK_6))
			{
				while(Key_Down(DIK_6))
					Poll_Keyboard();
				dtext=addp(dtext,"6");
			}
			if(Key_Down(DIK_7))
			{
				while(Key_Down(DIK_7))
					Poll_Keyboard();
				dtext=addp(dtext,"7");
			}
			if(Key_Down(DIK_8))
			{
				while(Key_Down(DIK_8))
					Poll_Keyboard();
				dtext=addp(dtext,"8");
			}

			if(Key_Down(DIK_9))
			{
				while(Key_Down(DIK_9))
					Poll_Keyboard();
				dtext=addp(dtext,"9");
			}
			if(Key_Down(DIK_0))
			{
				while(Key_Down(DIK_0))
					Poll_Keyboard();
				dtext=addp(dtext,"0");
			}
			
			if(Key_Down(DIK_BACKSPACE))
			{
				while(Key_Down(DIK_BACKSPACE))
					Poll_Keyboard();
				if(strlen(dtext)>0)
				{
					dtext[strlen(dtext)-1]=NULL;
				}
			}
			if(Key_Down(DIK_RETURN))
				enter=1;
		}
		sprite_handler->Begin( D3DXSPRITE_ALPHABLEND);
		D3DXVECTOR3 pos(rect.left,rect.top,0);
		sprite_handler->Draw(
				 bg, 
				 NULL,
				 NULL,
				 &pos,
				 D3DCOLOR_XRGB(255,255,255));
		
		sprite_handler->End();
		TXT.Begin();
		TXT.PrintText(dtext,rect.left+5,(rect.top+rect.bottom)/2-(TXT.T_FONTSIZE/2),255,0,0,0);
		TXT.End();
		
	}
	bool enter;
protected:
	RECT rect;
	DXTEXT TXT;
	LPDIRECT3DTEXTURE9 bg;
	bool active;
	int pointer;
	char* dtext;
};
*/