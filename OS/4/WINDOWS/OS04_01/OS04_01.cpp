#include <windows.h>
#include <iostream>
using namespace std;

int main()
{
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();
	for (int i = 0; i < 100; i++)
	{
		cout << "Process ID: " << pid << endl;
		cout << "Thread ID: " << tid << endl;
		Sleep(1000);
	}
	return 0;
}