#include <iostream>
#include <Windows.h>
#include <TlHelp32.h>
#include <iomanip>
#include <ctime>

bool stop = false;
DWORD ChildThread();
int simple(int n);

int main()
{
	clock_t start = clock();
	DWORD pid = GetCurrentProcessId();
	HANDLE htimer = OpenWaitableTimer(TIMER_ALL_ACCESS, FALSE, L"OS08_04");

	DWORD ChildId2 = NULL;
	HANDLE hChild2 = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ChildThread, NULL, 0, &ChildId2);

	WaitForSingleObject(htimer, INFINITE);
	stop = true;
	CloseHandle(hChild2);

	std::cout << "time: " << clock() - start << std::endl;

	system("pause");
	return 0;
}

DWORD ChildThread() {
	DWORD tid = GetCurrentThreadId();

	for (int i = 0; ; i++) {
		if (stop) {
			break;
		}

		if (simple(i)) {
			std::cout << i << std::endl;
		}
	}
	return 0;
}

int simple(int n) {
	int i;
	for (i = 2; i <= sqrt(n); i++) {
		if (n % i == 0) {
			return 0;
		}
	}
	return 1;
}