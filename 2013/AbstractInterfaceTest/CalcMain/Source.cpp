#include <Windows.h>
#include <iostream>
#include "..\CalcStaticLibrary\Calculator.h"

int main()
{
	CALCULATOR calci;
	calci.CreateDevice();

	int result;
	result = calci.GetDevice()->mul(5,6);

	std::cout << result << std::endl;
	system("pause");

	return 0;
}