#include <Windows.h>
#include <iostream>

DWORD WINAPI OS04_03_T1(LPVOID lpParam) {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	for (int i = 0; i < 50; ++i) {
		Sleep(1000);
		std::cout << std::endl << "----------------------------T1-------------------------" << std::endl;
		std::cout << i << ". T1 PID = " << pid << ", TID = " << tid << std::endl;
	}

	return 0;
}

DWORD WINAPI OS04_03_T2(LPVOID lpParam) {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	for (int i = 0; i < 125; ++i) {
		Sleep(1000);
		std::cout << std::endl << "----------------------------T2-------------------------" << std::endl;
		std::cout << i << ". T2 PID = " << pid << ", TID = " << tid << std::endl;
	}

	return 0;
}

int main() {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	HANDLE hChild1 = CreateThread(NULL, 0, OS04_03_T1, NULL, 0, NULL);
	HANDLE hChild2 = CreateThread(NULL, 0, OS04_03_T2, NULL, 0, NULL);

	for (int i = 0; i < 100; ++i) {
		Sleep(1000);
		std::cout << std::endl << "----------------------------MAIN-------------------------" << std::endl;
		std::cout << i << ". Parent Thread PID = " << pid << ", TID = " << tid << std::endl;

		if (i == 20) {
			SuspendThread(hChild1);
			std::cout << "\n-----------Suspend Thread Child1-------------\n";
		}
		if (i == 60) {
			ResumeThread(hChild1);
			std::cout << "\n-----------Resume Thread Child1-------------\n";
		}
		if (i == 40) {
			SuspendThread(hChild2);
			std::cout << "\n-----------Suspend Thread Child2-------------\n";
		}
	}
	ResumeThread(hChild2);
	std::cout << "\n-----------Resume Thread Child2-------------\n";

	WaitForSingleObject(hChild1, INFINITE);
	WaitForSingleObject(hChild2, INFINITE);

	CloseHandle(hChild1);
	CloseHandle(hChild2);

	return 0;
}