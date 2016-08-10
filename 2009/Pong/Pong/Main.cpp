#include <d3d9.h>
#include <d3dx9.h>
#include <time.h>
#include <dxerr.h>
#include "dxinput.h"
#include <D3dx9core.h>
#include <string.h>
#include <string>
#define width 1280
#define height 800
#define apptitle "Pong V0.1b"
LPDIRECT3D9 d3d=NULL;
LPDIRECT3DDEVICE9 d3ddev=NULL;
LPDIRECT3DSURFACE9 backbuffer=NULL;
LPDIRECT3DSURFACE9 bg_image=NULL;
LPD3DXSPRITE sprite_handler;
LPDIRECT3DTEXTURE9 ball_image;
LPDIRECT3DTEXTURE9 paddle_image;
LPD3DXFONT d3dfont;
ID3DXSprite*TextS = NULL;
#define KEY_DOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
#define KEY_UP(vk_code)((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
int globalR=0,globalG=0,globalB=0;
int DIFFICULTY=width-215;
void Run(HWND);
int AIscore;
int HUMANscore=0;
LPCSTR convertInt(int number)
{
	LPCSTR str;
	char buffer[512];
	sprintf(buffer,"%d",number);
	str=buffer;
	return str;
}
void PrintText(LPCSTR str, int x,int y)
{
	RECT textbox;
	SetRect(&textbox,x,y,width,y+50);
    d3dfont->DrawText(TextS,
                      str,
                      strlen(str),
                      &textbox,
                      DT_LEFT,
                      D3DCOLOR_XRGB(255,255,255));
}
int randint(int min,int max)
{return rand()%(max-min)+min;}
struct SPRITE
{
	int x;
	int y;
	int movex,movey;
	int speed;
	int w,h;
	RECT rect;
};
SPRITE ball;
SPRITE AIpaddle;
SPRITE HUMANpaddle;
void End(HWND hwnd);


LRESULT WINAPI WinProc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
    switch( msg )
    {
        case WM_DESTROY:
            End(hWnd);
            PostQuitMessage(0);
            return 0;
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
    wc.lpszClassName = apptitle;
    wc.hIconSm       = NULL;

    //set up the window with the class info
    return RegisterClassEx(&wc);
}
LPDIRECT3DTEXTURE9 LoadTexture(char *filename, D3DCOLOR transcolor)
{
    //the texture pointer
    LPDIRECT3DTEXTURE9 texture = NULL;

    //the struct for reading bitmap file info
    D3DXIMAGE_INFO info;

    //standard Windows return value
    HRESULT result;
    
    //get width and height from bitmap file
    result = D3DXGetImageInfoFromFile(filename, &info);
    if (result != D3D_OK)
        return NULL;

    //create the new texture by loading a bitmap image file
	D3DXCreateTextureFromFileEx( 
        d3ddev,              //Direct3D device object
        filename,            //bitmap filename
        info.Width,          //bitmap image width
        info.Height,         //bitmap image height
        1,                   //mip-map levels (1 for no chain)
        D3DPOOL_DEFAULT,     //the type of surface (standard)
        D3DFMT_UNKNOWN,      //surface format (default)
        D3DPOOL_DEFAULT,     //memory class for the texture
        D3DX_DEFAULT,        //image filter
        D3DX_DEFAULT,        //mip filter
        transcolor,          //color key for transparency
        &info,               //bitmap file info (from loaded file)
        NULL,                //color palette
        &texture );          //destination texture

    //make sure the bitmap textre was loaded correctly
    if (result != D3D_OK)
        return NULL;

    return texture;
}
int Init(HWND hwnd)
{

    //initialize Direct3D
    d3d = Direct3DCreate9(D3D_SDK_VERSION);
    if (d3d == NULL)
    {
        MessageBox( hwnd, "Error initializing Direct3D", "Error", MB_OK);
        return 0;
    }

    //set Direct3D presentation parameters
    D3DPRESENT_PARAMETERS d3dpp; 
    ZeroMemory(&d3dpp, sizeof(d3dpp));
    d3dpp.Windowed = true;
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
    d3dpp.BackBufferFormat = D3DFMT_X8R8G8B8;
    d3dpp.BackBufferCount = 1;
    d3dpp.BackBufferWidth = width;
    d3dpp.BackBufferHeight = height;
    d3dpp.hDeviceWindow = hwnd;

    //create Direct3D device
    d3d->CreateDevice(
        D3DADAPTER_DEFAULT, 
        D3DDEVTYPE_HAL, 
        hwnd,
        D3DCREATE_SOFTWARE_VERTEXPROCESSING,
        &d3dpp, 
        &d3ddev);
    if (d3ddev == NULL)
    {
        MessageBox(hwnd, "Error creating Direct3D device", "Error", MB_OK);
        return 0;
    }
	HRESULT result;
	Init_DirectInput(hwnd);
	Init_Keyboard(hwnd);
	Init_Mouse(hwnd);
	
	D3DXCreateSprite(d3ddev, &sprite_handler);
	ball_image = LoadTexture("ball.bmp", D3DCOLOR_XRGB(0,0,0));
	paddle_image = LoadTexture("paddle.bmp", D3DCOLOR_XRGB(0,0,0));
	d3ddev->CreateOffscreenPlainSurface(
		width,height,D3DFMT_X8R8G8B8,    //surface format
        D3DPOOL_DEFAULT,    //memory pool to use
        &bg_image,           //pointer to the surface
        NULL);
	result = D3DXLoadSurfaceFromFile(
        bg_image,            //destination surface
        NULL,               //destination palette
        NULL,               //destination rectangle
        "bg.bmp",     //source filename
        NULL,               //source rectangle
        D3DX_DEFAULT,       //controls how image is filtered
        0,                  //for transparency (0 for none)
        NULL);
	D3DXCreateFont( d3ddev, 50, 0, FW_BOLD, 0, FALSE, DEFAULT_CHARSET, 
					OUT_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, 
					TEXT("Arial"), &d3dfont );
	if(FAILED(D3DXCreateSprite(d3ddev,&TextS)))
		return false;
	ball.movex=-8;
	ball.movey=-1;
	ball.x=width/2;
	ball.y=height/2;
	ball.speed=1;
	ball.rect.left=ball.x-10;
	ball.rect.right=ball.x+10;
	ball.rect.top=ball.y-10;
	ball.rect.bottom=ball.y+10;
	ball.w=20;
	ball.h=20;
	AIpaddle.speed=0;
	AIpaddle.x=width-13;
	AIpaddle.y=height/2;
	AIpaddle.movex=0;
	AIpaddle.movey=0;
	AIpaddle.h=130;
	AIpaddle.w=26;
	HUMANpaddle.speed=0;
	HUMANpaddle.x=13;
	HUMANpaddle.y=height/2;
	HUMANpaddle.h=130;
	HUMANpaddle.w=26;
	
	//set random number seed
	srand(time(NULL));
    //return okay
	d3ddev->Clear(0, NULL, D3DCLEAR_TARGET, D3DCOLOR_XRGB(128,128,128), 1.0f, 0);
	AIscore=-1;
	AIscore++;
    return 1;
}
int Collision(SPRITE sprite1, SPRITE sprite2)
{
    RECT rect1;
    rect1.left = sprite1.x-sprite1.w/2;
    rect1.top = sprite1.y-sprite1.h/2;
    rect1.right = sprite1.x+sprite1.w/2;
    rect1.bottom = sprite1.y+sprite1.h/2;

    RECT rect2;
    rect2.left = sprite2.x-sprite2.w/2;
    rect2.top = sprite2.y-sprite2.h/2;
    rect2.right = sprite2.x+sprite2.w/2;
    rect2.bottom = sprite2.y+sprite2.h/2;
    RECT dest;
    return IntersectRect(&dest, &rect1, &rect2);
}
int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR     lpCmdLine,
                   int       nCmdShow)
{
    // declare variables
	MSG msg;
	// register the class
	reg(hInstance);
    // initialize application 
    //note--got rid of initinstance
    HWND hWnd=NULL;
    //create a new window
    hWnd = CreateWindow(
		apptitle,
		apptitle,
		WS_SYSMENU | WS_BORDER,   //window style
        25,         //x position of window
        25,         //y position of window
        width,                   //width of the window
        height,                   //height of the window
        NULL,                  //parent window
        NULL,                  //menu
        hInstance,             //application instance
        NULL);
	if(hWnd==NULL){
		MessageBox(hWnd,"Failed to create window","Error",MB_OK);}

    //was there an error creating the window?

    //display the window
    ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);
	
	//initialize the game
    if (!Init(hWnd))
        return 0;


    // main message loop
    int done = 0;
	while (!done)
    {
        if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) 
	    {
            //look for quit message
            if (msg.message == WM_QUIT)
                done = 1;

            //decode and pass messages on to WndProc
		    TranslateMessage(&msg);
		    DispatchMessage(&msg);
	    }
        else
            //process game loop (else prevents running after window is closed)
            Run(hWnd);
    }
	end();
	return msg.wParam;
}
void moveBall(HWND hwnd)
{
	if(Collision(ball,AIpaddle))
	{
		ball.x -= ball.movex;
			ball.movex++;
            ball.movex *= -1;
			ball.movey+=AIpaddle.speed;
	}
	if(Collision(ball,HUMANpaddle))
	{
		ball.x -= ball.movex;
            ball.movex *= -1;
			ball.movex+=randint(0,2);
			ball.movey+=HUMANpaddle.speed;
	}
	if (ball.x > width - ball.w +20)
    {
			ball.movex=8;
		ball.movey=(AIpaddle.y-height/2)/((width/2-AIpaddle.x)/8);
		if(ball.movey==0)
			ball.movey++;
		DIFFICULTY-=4;
		ball.x=width/2;
		ball.y=height/2;
		HUMANscore++;
    }
    else if (ball.x < -20)
    {
			ball.movex=-8;
		ball.movey=(HUMANpaddle.y-height/2)/((width/2-HUMANpaddle.x)/8);
		if(ball.movey==0)
			ball.movey++;
		ball.x=width/2;
		ball.y=height/2;
		AIscore++;
    }

    if (ball.y > height-10 )
    {
        ball.y -= ball.h;
        ball.movey *= -1;
    }
    else if (ball.y < 0)
    {
        ball.y += ball.h;
        ball.movey *= -1;
    }
}
void AImove()
{
	AIpaddle.speed=0;
	if(ball.x>=DIFFICULTY)
	{
		if(ball.y<=AIpaddle.y)
		{
			AIpaddle.movey=-4;
			AIpaddle.speed=-3;
		}
		if(ball.y>=AIpaddle.y)
		{
			AIpaddle.movey=4;
			AIpaddle.speed=3;
		}
		AIpaddle.y+=AIpaddle.movey;
		AIpaddle.movey=0;
	}
	return;
}

void Run(HWND hwnd)
{
	Poll_Keyboard();
	Poll_Mouse();
	D3DXVECTOR3 position(0,0,0);
	moveBall(hwnd);
	HUMANpaddle.speed=0;
	AImove();
    //make sure the Direct3D device is valid
    if (d3ddev == NULL)
        return;
	RECT rc,r;
	GetClientRect(hwnd,&rc);
    //start rendering

	
	if(HUMANpaddle.y+65+2*Mouse_Y()<height && HUMANpaddle.y-65+2*Mouse_Y()>0){
		HUMANpaddle.y+=2*Mouse_Y();
		HUMANpaddle.speed=Mouse_Y();}
	if(Key_Down(DIK_UP))
	{
		if(HUMANpaddle.y>65){
			HUMANpaddle.y-=7;
			HUMANpaddle.speed=-3;}
	}
	if(Key_Down(DIK_DOWN))
	{
		if(HUMANpaddle.y<height-65){
			HUMANpaddle.y+=7;
			HUMANpaddle.speed=3;}
	}
	d3ddev->Clear(0, NULL, D3DCLEAR_TARGET, D3DCOLOR_XRGB(globalR,globalG,globalB), 1.0f, 0);
    if (d3ddev->BeginScene())
    {
		ball.x+=ball.movex*ball.speed;
		ball.y+=ball.movey*ball.speed;

		
		d3ddev->GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, &backbuffer);
		d3ddev->StretchRect(bg_image,NULL,backbuffer,NULL,D3DTEXF_NONE);
		
		sprite_handler->Begin(D3DXSPRITE_ALPHABLEND);
        //draw the ball
        position.x =ball.x;
        position.y =ball.y;
        sprite_handler->Draw(
            ball_image, 
            NULL,
            NULL,
            &position,
            D3DCOLOR_XRGB(255,255,255));
        //draw the paddle
        position.x = (float)AIpaddle.x-13;
        position.y = (float)AIpaddle.y-65;
        sprite_handler->Draw(
            paddle_image,
            NULL,
            NULL,
            &position,
            D3DCOLOR_XRGB(255,255,255));
		position.x = (float)HUMANpaddle.x-13;
        position.y = (float)HUMANpaddle.y-65;
        sprite_handler->Draw(
            paddle_image,
            NULL,
            NULL,
            &position,
            D3DCOLOR_XRGB(255,255,255));
        //stop drawing
        sprite_handler->End();
		TextS->Begin(D3DXSPRITE_ALPHABLEND);
			PrintText(convertInt(HUMANscore),width/2-7-strlen(convertInt(HUMANscore))*25,1);
			PrintText(convertInt(AIscore),width/2+10,1);
			TextS->End();
        //stop rendering
        d3ddev->EndScene();
		
    }

    //display the back buffer on the screen
    //check for escape key (to exit program)
	
	d3ddev->Present(NULL, NULL, NULL, NULL);
	if(KEY_DOWN(VK_ESCAPE))
		PostQuitMessage(0);

}
void End(HWND hwnd)
{
    //release the Direct3D device
    if (d3ddev != NULL) 
        d3ddev->Release();

    //release the Direct3D object
    if (d3d != NULL)
        d3d->Release();
}