#include <iostream>
#include <Windows.h>
#include <ctime>

using namespace std;

HANDLE hs = CreateSemaphore(NULL, 2, 3, L"Sem");

void main() {
	DWORD pid = GetCurrentProcessId();

	LPCWSTR an = L"OS07_04A.exe";
	LPCWSTR an2 = L"OS07_04B.exe";
	STARTUPINFO si1;
	STARTUPINFO si2;
	PROCESS_INFORMATION pi1;
	PROCESS_INFORMATION pi2;

	ZeroMemory(&si1, sizeof(STARTUPINFO));
	ZeroMemory(&si2, sizeof(STARTUPINFO));

	si1.cb = sizeof(STARTUPINFO);
	si2.cb = sizeof(STARTUPINFO);

	if (CreateProcess(an, NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si1, &pi1))
		cout << "Child Process created" << endl;
	else
		cout << "Child Process not created" << endl;

	if (CreateProcessW(an2, NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si2, &pi2))
		cout << "Child Process created" << endl;
	else
		cout << "Child Process not created" << endl;

	for (int i = 0; i < 90; i++)
	{
		if (i == 30)
		{
			WaitForSingleObject(hs, INFINITE);
		}
		else if (i == 60)
		{
			LONG prevcount = 0;
			ReleaseSemaphore(hs, 1, &prevcount);
		}
		Sleep(100);
		cout << "PID = " << pid << " : " << i << endl;
	}

	WaitForSingleObject(pi1.hProcess, INFINITE);
	WaitForSingleObject(pi2.hProcess, INFINITE);

	CloseHandle(hs);

	CloseHandle(pi1.hProcess);
	CloseHandle(pi2.hProcess);
}