#include <iostream>
#include <Windows.h>
#include <ctime>

using namespace std;

int main()
{
    DWORD pid = GetCurrentProcessId();
    HANDLE hs = OpenSemaphore(SEMAPHORE_ALL_ACCESS, FALSE, L"Sem");
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

    CloseHandle(hs);
    system("pause");
    return 0;
}
