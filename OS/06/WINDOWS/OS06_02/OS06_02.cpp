#include <iostream>
#include <Windows.h>

using namespace std;

int main()
{
	long i;
	for (i = 0; i < 10000; i++)
	{
		cout << i << endl;
		Sleep(1000);
	}

	return 0;
}