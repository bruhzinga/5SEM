#include <windows.h>
#include <iostream>
using namespace std;

DWORD WINAPI OS04_02_T1(LPVOID lpParam)
{
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();
	for (int i = 0; i < 50; i++)
	{
		cout << "\n--------------------- T1----------------------- \n";
		cout << "Process ID: " << pid << endl;
		cout << "Thread ID: " << tid << endl;
		Sleep(1000);
	}
	return 0;
}

DWORD WINAPI OS04_02_T2(LPVOID lpParam)
{
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();
	for (int i = 0; i < 125; i++)
	{
		cout << "\n--------------------- T2----------------------- \n";
		cout << "Process ID: " << pid << endl;
		cout << "Thread ID: " << tid << endl;
		Sleep(1000);
	}
	return 0;
}

int main()
{
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();
	HANDLE hThread1 = CreateThread(NULL, 0, OS04_02_T1, NULL, 0, NULL);
	HANDLE hThread2 = CreateThread(NULL, 0, OS04_02_T2, NULL, 0, NULL);
	for (int i = 0; i < 100; i++)
	{
		cout << "\n--------------------- MAIN----------------------- \n";
		cout << "Process ID: " << pid << endl;
		cout << "Thread ID: " << tid << endl;
		Sleep(1000);
	}

	WaitForSingleObject(hThread1, INFINITE);
	WaitForSingleObject(hThread2, INFINITE);
	CloseHandle(hThread1);
	CloseHandle(hThread2);
	return 0;
}