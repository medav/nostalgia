#include "CalculatorDevice.h"

typedef bool (*CREATECALCULATORDEVICE)(HINSTANCE hDLL, CALCULATORDEVICE **pInterface);
typedef bool (*RELEASECALCULATORDEVICE)(CALCULATORDEVICE **pInterface);

class CALCULATOR
{
public:
	LPCALCULATORDEVICE GetDevice() {return m_DEVICE;}

	bool CreateDevice();
	void Release();

private:
	CALCULATORDEVICE *m_DEVICE;
	HINSTANCE m_hDLL;
};