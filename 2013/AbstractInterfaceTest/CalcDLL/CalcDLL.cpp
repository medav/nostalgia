#include "CalcDLL.h"

int CALCULATOR::add(int a, int b)
{
	return a + b;
}

int CALCULATOR::sub(int a, int b)
{
	return a - b;
}

int CALCULATOR::mul(int a, int b)
{
	return a * b;
}

int CALCULATOR::div(int a, int b)
{
	return a / b;
}

extern "C"{
	__declspec(dllexport) bool CreateCalculatorDevice(HINSTANCE hDLL, CALCULATORDEVICE **pDevice)
	{
		*pDevice = new CALCULATOR();

		return true;
	}

	__declspec(dllexport) bool ReleaseCalculatorDevice(CALCULATORDEVICE **pDevice)
	{
		if(!*pDevice)
			return false;

		delete *pDevice;
		*pDevice = NULL;

		return true;
	}
}