#include <Windows.h>
#include <iostream>

class CALCULATORDEVICE
{
public:
	virtual int add(int,int) = 0;
	virtual int sub(int,int) = 0;
	virtual int mul(int,int) = 0;
	virtual int div(int,int) = 0;


};

typedef class CALCULATORDEVICE *LPCALCULATORDEVICE;


