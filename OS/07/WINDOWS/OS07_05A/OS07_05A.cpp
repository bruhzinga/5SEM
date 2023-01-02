#include <iostream>
#include <Windows.h>
#include <ctime>

using namespace std;
int main()
{
    DWORD pid = GetCurrentProcessId();
    HANDLE he = OpenEvent(EVENT_ALL_ACCESS, FALSE, L"aEvent");
    cout << "Process Start" << endl;
    WaitForSingleObject(he, INFINITE);
    for (int i = 0; i < 90; i++) 
    {
        Sleep(100);
        cout << "PID = " << pid << " : " << i << endl;
    }

    CloseHandle(he);
    system("pause");
    return 0;
}
