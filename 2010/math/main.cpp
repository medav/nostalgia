#include <iostream>
#include <math.h>
using namespace std;
float PI=3.14159265358979323846264338;



double fact(int num)
{
	double result=1;
	for(int t=1;t<=num;t++)
	{
		result=result*t;
	}
	return result;
}

float mysin(float n)
{

	while(n>=360)
	{
		n-=360;
	}
	if(n>180)
	{
		n-=180;
		n=-n;
	}
	if(n==45)
		return 45;
	if(n==30)
		return 0.5;
	
	n=n*PI/180;
	return (n-pow(n,3)/fact(3)+pow(n,5)/fact(5)-pow(n,7)/fact(7)+pow(n,9)/fact(9));
}


int main()
{
	float (*mysin2)(float)=mysin;
	for(float x=1;x<6232;x++)
	{
		if(mysin(x)==45)
		{
			cout << "mySin(" << x << ")=sqrt(2)/2" << "\n";
		}
		else if(mysin(x)==.5)
		{
			cout << "mySin(" << x << ")=1/2" << "\n";
		}
		else
		{
			cout << "mySin(" << x << ")=" << mysin2(x) << "\n";
		}
		cout << "Sin(" << x << ")===" << sin(x*PI/180) << "\n";
		system("pause");
		system("cls");
	}
	system("pause");
	return 0;
}