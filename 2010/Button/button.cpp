#include "DirectX.h"
#include "DXText.h"
#include "Mouse.h"
#include "UI.cpp"
#include "luna.h"

HWND hwnd=NULL;
HINSTANCE hInst;
bool Wreset=false;
int nCmdSh;
int Menu();
DXTEXT DXT1;
DXTEXT DXT2;
MSG msg;
lua_State *L;
char*con;
#define method(class, name) {#name, &class::name}
class LUABUTTON
{
public:
	static const char className[];
  	static Luna<LUABUTTON>::RegType methods[];
	LUABUTTON(lua_State *LS)
	{
		int x,y,w,h;
		LPCSTR text;
		x=luaL_checknumber(LS,1);
		y=luaL_checknumber(LS,2);
		w=luaL_checknumber(LS,3);
		h=luaL_checknumber(LS,4);
		text=luaL_checkstring(LS,5);

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
	 int update(lua_State *LS)
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
		return 0;
	}
		
	int activated(lua_State *LS)
	{
		lua_pushnumber(LS,click);
		return 1;
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
const char LUABUTTON::className[] = "LUABUTTON";

Luna<LUABUTTON>::RegType LUABUTTON::methods[] = {
  method(LUABUTTON, update),
  method(LUABUTTON, activated),
  {0,0}
};
LRESULT WINAPI WinProc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
	if(KEY_DOWN(VK_F1))
	{
		Cleanup(hWnd);
		exit(0);
	}
    switch( msg )
    {
        case WM_DESTROY:
		{
			if(!Wreset)
			{
				Cleanup(hWnd);
				exit(0);
			}
			Wreset=false;
		}
		case WM_LBUTTONDOWN:
		{
			if(!Mouse_Acquired)
			{
				Mouse_Acquired=true;
				dimouse->Acquire();
				dikeyboard->Acquire();
			}
		}
    }

    return DefWindowProc( hWnd, msg, wParam, lParam );
}
ATOM reg(HINSTANCE hInstance)
{
    //create the window class structure
    WNDCLASSEX wc;
    wc.cbSize = sizeof(WNDCLASSEX); 

    //fill the struct with info
    wc.style         = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc   = (WNDPROC)WinProc;
    wc.cbClsExtra	 = 0;
    wc.cbWndExtra	 = 0;
    wc.hInstance     = hInstance;
    wc.hIcon         = NULL;
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
    wc.lpszMenuName  = NULL;
    wc.lpszClassName = TITLE;
    wc.hIconSm       = NULL;

    //set up the window with the class info
    return RegisterClassEx(&wc);
}
int getfieldN(lua_State *L, const char *key)
{
	int result;
	lua_pushstring(L, key);
	lua_gettable(L,-2);
	if(!lua_isnumber(L,-1))
		MessageBox(NULL,"Table value is not a number","Lua:",MB_OK);
	result= (int)lua_tonumber(L,-1);
	lua_pop(L,1);
	return result;
}
void call_va( const char *func, const char *sig, ...) {
      va_list vl;
      int narg, nres;  /* number of arguments and results */
    
      va_start(vl, sig);
      lua_getglobal(L, func);  /* get function */
    
      /* push arguments */
      narg = 0;
      while (*sig) {  /* push arguments */
        switch (*sig++) {
    
          case 'd':  /* double argument */
            lua_pushnumber(L, va_arg(vl, double));
            break;
    
          case 'i':  /* int argument */
            lua_pushnumber(L, va_arg(vl, int));
            break;
    
          case 's':  /* string argument */
            lua_pushstring(L, va_arg(vl, char *));
            break;
    
          case '>':
            goto endwhile;
    
          default:;
            /*error(L, "invalid option (%c)", *(sig - 1));*/
        }
        narg++;
        luaL_checkstack(L, 1, "too many arguments");
      } endwhile:
    
      /* do the call */
      nres = strlen(sig);  /* number of expected results */
      if (lua_pcall(L, narg, nres, 0) != 0)  /* do the call */
        /*error(L, "error running function `%s': %s",
                 func, lua_tostring(L, -1));*/
    
      /* retrieve results */
      nres = -nres;  /* stack index of first result */
      while (*sig) {  /* get results */
        switch (*sig++) {
    
          case 'd':  /* double result */
            if (!lua_isnumber(L, nres))
              /*error(L, "wrong result type");*/
            *va_arg(vl, double *) = lua_tonumber(L, nres);
            break;
    
          case 'i':  /* int result */
            if (!lua_isnumber(L, nres))
              /*error(L, "wrong result type");*/
            *va_arg(vl, int *) = (int)lua_tonumber(L, nres);
            break;
    
          case 's':  /* string result */
            if (!lua_isstring(L, nres))
              /*error(L, "wrong result type");*/
            *va_arg(vl, const char **) = lua_tostring(L, nres);
            break;
    
          default:;
            /*error(L, "invalid option (%c)", *(sig - 1));*/
        }
        nres++;
      }
      va_end(vl);
    }
int START()
{
	if(hwnd!=NULL)
	{
		DestroyWindow(hwnd);
	}
	int xPos=125,yPos=125;
	L = lua_open();
	luaL_openlibs(L);
	Luna<LUABUTTON>::Register(L);
	luaL_loadfile(L, "Test2.lua");
 	lua_pcall(L,0,0,0);
	lua_getglobal(L,"win");
	if(!lua_istable(L,-1))
	{
		MessageBox(NULL,"Couldn't Initialize","Lua:",MB_OK);
	}
	reg(hInst);
	
    hwnd = CreateWindow(
		TITLE,
		TITLE,
		WS_SYSMENU | WS_BORDER,   //window style
        xPos,         //x position of window
        yPos,         //y position of window
        WIDTH,                   //width of the window
        HEIGHT,                   //height of the window
        NULL,                  //parent window
        NULL,                  //menu
        hInst,             //application instance
        NULL);
	
	if(hwnd==NULL){
		MessageBox(hwnd,"Failed to create window","Error",MB_OK);}
    ShowWindow(hwnd, nCmdSh);
    UpdateWindow(hwnd);
	
	


    if (!Init_DX(hwnd,1))
        return 0;
	Wreset=false;
    return Menu();
}
int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR     lpCmdLine,
                   int       nCmdShow)
{
	nCmdSh=nCmdShow;
	WIDTH=320;
	HEIGHT=200;
	hInst=hInstance;
	return START();
}


int Menu()
{
	int r=64,g=64,b=64;
	bool bgch=false;
	LPDIRECT3DSURFACE9 BG;
	d3ddev->CreateOffscreenPlainSurface(
		WIDTH,HEIGHT,D3DFMT_X8R8G8B8,    //surface format
        D3DPOOL_DEFAULT,    //memory pool to use
        &BG,           //pointer to the surface
        NULL);
	
	d3ddev->ColorFill(BG,NULL,D3DCOLOR_XRGB(64,64,64));
	Mouse_Init();
	Poll_Mouse();
	MouseX+=Mouse_X();
	MouseY+=Mouse_Y();
	bool done=false;
	BUTTON test;
	test.Init(50,50,100,64,"Epilepsy!");
	BUTTON test1;
	test1.Init(160,50,100,64,"Bye...");

	while(!done)
	{
		if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) 
		{
			if(msg.message==WM_QUIT)
				done=1;
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		if (d3ddev == NULL)
			break;
		D3DXVECTOR3 position(0,0,0);
		d3ddev->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &backbuffer);
		d3ddev->ColorFill(backbuffer,NULL,D3DCOLOR_XRGB(r,g,b));
		
		if (d3ddev->BeginScene())
		{
			
			//d3ddev->StretchRect(BG,NULL,backbuffer,NULL,D3DTEXF_NONE);
			test.update();
			test1.update();
			call_va("Think",">");
			if(test1.activated())
			{
				Cleanup(hwnd);
				exit(0);
			}
			if(test.activated())
			{
				bool t=true;
				if(bgch)
					t=false;
				bgch=t;
			}
			if(bgch)
			{
				r=randint(0,255);
				g=randint(0,255);
				b=randint(0,255);
			}
			sprite_handler->Begin(D3DXSPRITE_ALPHABLEND);
			uMouse();
			sprite_handler->End();
			d3ddev->EndScene();
		}
		d3ddev->Present(NULL, NULL, NULL, NULL);
	}
	return msg.wParam;
}

