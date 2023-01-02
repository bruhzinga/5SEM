#include <iostream>
#include <Windows.h>
#include <ctime>

using namespace std;
HANDLE he = CreateEvent(NULL, TRUE, FALSE, L"aEvent");

void main() {
	DWORD pid = GetCurrentProcessId();

	LPCWSTR an = L"OS07_05A.exe";
	LPCWSTR an2 = L"OS07_05B.exe";
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
		if (i == 15)
		{
			PulseEvent(he);
		}
		Sleep(100);
		cout << "PID = " << pid << " : " << i << std::endl;
	}

	WaitForSingleObject(pi1.hProcess, INFINITE);
	WaitForSingleObject(pi2.hProcess, INFINITE);

	CloseHandle(he);

	CloseHandle(pi1.hProcess);
	CloseHandle(pi2.hProcess);
}