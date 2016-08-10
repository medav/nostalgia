#ifndef _DIRECTX_H
#define _DIRECTX_H
#include <d3dx9.h>
#include <d3d9.h>
#include <time.h>
#include <dxerr.h>
#include <D3dx9core.h>
#include <stdio.h>
#include "Dinput.h"
#define TITLE "Pong"
#define KEY_DOWN(vk_code) ((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
#define KEY_UP(vk_code)((GetAsyncKeyState(vk_code) & 0x8000) ? 1 : 0)
extern int WIDTH;
extern int HEIGHT;
extern LPDIRECT3D9 d3d;
extern LPDIRECT3DDEVICE9 d3ddev;
extern LPDIRECT3DSURFACE9 backbuffer;
extern LPD3DXSPRITE sprite_handler;
bool Init_DX(HWND hwnd,bool Windowed);
LPDIRECT3DTEXTURE9 LoadTexture(char *filename, D3DCOLOR transcolor);
bool LoadImageFromFile(LPDIRECT3DSURFACE9*destSurface,
					   RECT*destRect,RECT*srcRect,
					   char*filename,int transparency);
LPCSTR convertInt(int number);
int randint(int min,int max);
char* addp(char*str1,char*str2);
bool Reset(HWND hwnd,bool Windowed);
bool CreateSurface(LPDIRECT3DSURFACE9 s,int w,int h);
void Cleanup(HWND);
#endif