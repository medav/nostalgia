#include <Windows.h>
#include "..\CalcStaticLibrary\CalculatorDevice.h"

class CALCULATOR : public CALCULATORDEVICE
{
	int add(int,int);
	int sub(int,int);
	int mul(int,int);
	int div(int,int);
};