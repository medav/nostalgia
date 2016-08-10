#include "Calculator.h"

bool CALCULATOR::CreateDevice()
{
	m_hDLL = LoadLibrary("CalcDLL.dll");
	
	if(!m_hDLL)
	{
		std::cout << "Could not load library!\n";
		return false;
	}

	CREATECALCULATORDEVICE _CreateCalculatorDevice = 0;
	_CreateCalculatorDevice = (CREATECALCULATORDEVICE) GetProcAddress(m_hDLL,"CreateCalculatorDevice");

	if(!_CreateCalculatorDevice)
	{
		std::cout << "Could not locate CREATECALULATORDEVICE!\n";
		return false;
	}

	bool result;
	result = _CreateCalculatorDevice(m_hDLL, &m_DEVICE);

	if(!result)
	{
		std::cout << "Failed to create calculator device!\n";
		return false;	
	}
	
	return true;
}

void CALCULATOR::Release()
{
	RELEASECALCULATORDEVICE _ReleaseCalculatorDevice = 0;
	_ReleaseCalculatorDevice = (RELEASECALCULATORDEVICE) GetProcAddress(m_hDLL,"ReleaseCalculatorDevice");

	bool result;
	result = _ReleaseCalculatorDevice(&m_DEVICE);

	if(!result)
	{
		m_DEVICE = NULL;
	}
	
}