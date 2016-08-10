#include "DirectX.h"
LPDIRECT3D9 d3d=NULL; 
LPDIRECT3DDEVICE9 d3ddev=NULL;
LPDIRECT3DSURFACE9 backbuffer=NULL;
LPD3DXSPRITE sprite_handler=NULL;
int WIDTH=0,HEIGHT=0;
int randint(int min,int max)
{return rand()%(max-min)+min;}
LPCSTR convertInt(int number)
{
	LPCSTR str;
	char buffer[512];
	sprintf(buffer,"%d",number);
	str=buffer;
	return str;
}
bool Reset(HWND hwnd,bool windowed)
{
	return Init_DX(hwnd,windowed);
}
bool Init_DX(HWND hwnd,bool Windowed)
{
	d3d=Direct3DCreate9(D3D_SDK_VERSION);
	if (d3d == NULL)
    {
		MessageBox( hwnd, "Failed to initalize Direct3D", "Error:", MB_OK);
        return false;
    }
	D3DPRESENT_PARAMETERS d3dpp;
	ZeroMemory(&d3dpp, sizeof(d3dpp));
	if(Windowed==true)
	{
		d3dpp.Windowed=true;
		d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
		d3dpp.BackBufferFormat = D3DFMT_X8R8G8B8;
		d3dpp.BackBufferCount = 1;
		d3dpp.BackBufferWidth = WIDTH;
		d3dpp.BackBufferHeight = HEIGHT;
		d3dpp.hDeviceWindow = hwnd;
	}
	if(Windowed==false)
	{
		d3dpp.Windowed = false;
		d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;
		d3dpp.BackBufferFormat = D3DFMT_X8R8G8B8;
		d3dpp.BackBufferCount = 1;
		d3dpp.BackBufferWidth = WIDTH;
		d3dpp.BackBufferHeight = HEIGHT;
		d3dpp.hDeviceWindow = hwnd;
	}
	d3d->CreateDevice(
        D3DADAPTER_DEFAULT, 
        D3DDEVTYPE_HAL, 
        hwnd,
        D3DCREATE_SOFTWARE_VERTEXPROCESSING,
        &d3dpp, 
        &d3ddev);
	D3DXCreateSprite(d3ddev, &sprite_handler);
	if (d3ddev == NULL)
    {
		MessageBox(hwnd, "Failed to create Direc3D Device", "Error:", MB_OK);
        return false;
    }
	if(!Init_DirectInput(hwnd))
	{
		MessageBox(hwnd, "Failed to initalize Direct Input", "Error:", MB_OK);
        return false;
	}
	if(!Init_Keyboard(hwnd))
	{
		MessageBox(hwnd, "Failed to initalize the keyboard", "Error:", MB_OK);
        return false;
	}
	if(!Init_Mouse(hwnd))
	{
		MessageBox(hwnd, "Failed to initalize the mouse", "Error:", MB_OK);
        return false;
	}
}

LPDIRECT3DTEXTURE9 LoadTexture(char *filename, D3DCOLOR transcolor)
{
    LPDIRECT3DTEXTURE9 texture = NULL;
    D3DXIMAGE_INFO info;
    HRESULT result;
    result = D3DXGetImageInfoFromFile(filename, &info);
    if (result != D3D_OK)
        return NULL;
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
    if (result != D3D_OK)
        return NULL;

    return texture;
}
bool LoadImageFromFile(LPDIRECT3DSURFACE9*destSurface,
					   RECT*destRect,RECT*srcRect,
					   char*filename,int transparency)
{
	HRESULT result;
	result = D3DXLoadSurfaceFromFile(
        *destSurface,				//destination surface
        NULL,						//destination palette
        destRect,					//destination rectangle
        filename,					//source filename
        srcRect,					//source rectangle
        D3DX_DEFAULT,				//controls how image is filtered
        transparency,				//for transparency (0 for none)
        NULL);
	if(result!=D3D_OK)
		return false;
	return true;
}
void Cleanup(HWND hwnd)
{
	Kill_Keyboard();
	Kill_Mouse();
	if(d3ddev!=NULL)
		d3ddev->Release();
	if(d3d!=NULL)
		d3d->Release();
}
bool CreateSurface(LPDIRECT3DSURFACE9 s,int w,int h)
{
	HRESULT ok;
	ok=d3ddev->CreateOffscreenPlainSurface(
		w,h,D3DFMT_X8R8G8B8,    //surface format
        D3DPOOL_DEFAULT,    //memory pool to use
        &s,           //pointer to the surface
        NULL);
	return ok;
}
char* addp(char*str1,char*str2)
{
	char*temp;
	temp=new char [strlen(str1)+strlen(str2)];
	for(int i=0;i<=strlen(str1);i++)
	{
		temp[i]=str1[i];
	}
	for(int i=0;i<=strlen(str2);i++)
	{
		temp[i+strlen(str1)]=str2[i];
	}
	return temp;
}
