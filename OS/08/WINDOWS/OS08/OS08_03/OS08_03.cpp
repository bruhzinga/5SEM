#include <iostream>
#include <ctime>
#include <Windows.h>
#include <stdio.h>
#include <tchar.h>

#define SECOND 10000000
clock_t start;
int iteration;
bool finish = false;
using namespace std;

VOID CALLBACK TimerAPCProc(LPVOID lpArg, DWORD dwTimerLowValue, DWORD dwTimerHighValue)
{
	cout << "- " << iteration << ", c - " << clock() - start << endl;
	if ((clock() - start) / CLOCKS_PER_SEC >= 15)
	{
		finish = true;
	}
}

int main(void)
{
	HANDLE          hTimer;
	BOOL            bSuccess;
	LARGE_INTEGER   liDueTime;

	hTimer = CreateWaitableTimer(NULL, FALSE, TEXT("MyTimer"));
	if (hTimer != NULL)
	{
		__try
		{
			liDueTime.QuadPart = -30000000LL;

			bSuccess = SetWaitableTimer(hTimer, &liDueTime, 3000, TimerAPCProc, NULL, FALSE);   //30 миллионов 100 наносекунд
			start = clock();
			if (bSuccess)
			{
				for (iteration = 0;; iteration++)
				{
					SleepEx(0, TRUE);  // уступить поток выполнения функции другим потокам
					if (finish)
					{
						break;
					}
				}
			}
			else
			{
				printf("SetWaitableTimer failed with error %d\n", GetLastError());
			}
		}
		__finally
		{
			CloseHandle(hTimer);
		}
	}
	else
	{
		printf("CreateWaitableTimer failed with error %d\n", GetLastError());
	}

	return 0;
}