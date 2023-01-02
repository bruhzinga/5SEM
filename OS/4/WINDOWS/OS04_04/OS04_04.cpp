#include <Windows.h>
#include <iostream>

DWORD WINAPI OS04_04_T1(LPVOID lpParam) {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	for (int i = 0; i < 50; ++i) {
		Sleep(1000);
		std::cout << i << ". T1 PID = " << pid << ", TID = " << tid << std::endl;
		if (i == 25) {
			std::cout << "\n-----------T1 Sleep----------\n";
			Sleep(10000);
		}
	}

	return 0;
}

DWORD WINAPI OS04_04_T2(LPVOID lpParam) {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	for (int i = 0; i < 125; ++i) {
		Sleep(1000);
		std::cout << i << ". T2 PID = " << pid << ", TID = " << tid << std::endl;
		if (i == 80) {
			std::cout << "\n-----------T2 Sleep----------\n";
			Sleep(15000);
		}
	}

	return 0;
}

int main() {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	HANDLE hChild1 = CreateThread(NULL, 0, OS04_04_T1, NULL, 0, NULL);
	HANDLE hChild2 = CreateThread(NULL, 0, OS04_04_T2, NULL, 0, NULL);

	for (int i = 0; i < 1000; ++i) {
		Sleep(1000);
		std::cout << i << ". Parent Thread PID = " << pid << ", TID = " << tid << std::endl;

		if (i == 30) {
			std::cout << "\n-----------Parent Thread Sleep----------\n";
			Sleep(10000);
		}
	}

	WaitForSingleObject(hChild1, INFINITE);
	WaitForSingleObject(hChild2, INFINITE);

	CloseHandle(hChild1);
	CloseHandle(hChild2);

	return 0;
}