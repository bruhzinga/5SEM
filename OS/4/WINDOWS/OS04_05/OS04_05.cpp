#include <Windows.h>
#include <iostream>
using namespace std;

DWORD WINAPI OS04_05_T1(LPVOID lpParam)
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

DWORD WINAPI OS04_05_T2(LPVOID lpParam)
{
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();
	for (int i = 0; i < 125; i++)
	{
		cout << "\n----------------------T2------------------------- \n";
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
	HANDLE hThread1 = CreateThread(NULL, 0, OS04_05_T1, NULL, 0, NULL);
	HANDLE hThread2 = CreateThread(NULL, 0, OS04_05_T2, NULL, 0, NULL);
	for (int i = 0; i < 100; i++)
	{
		cout << "\n---------------------Main----------------------- \n";
		cout << "Process ID: " << pid << endl;
		cout << "Thread ID: " << tid << endl;
		Sleep(1000);
		if (i == 40)
		{
			TerminateThread(hThread2, 0);
			cout << "\n---------------------------THREAD 2 TERMINATED-------------------------- \n";
		}
	}
	WaitForSingleObject(hThread1, INFINITE);
	WaitForSingleObject(hThread2, INFINITE);
	CloseHandle(hThread1);
	CloseHandle(hThread2);
	return 0;
}