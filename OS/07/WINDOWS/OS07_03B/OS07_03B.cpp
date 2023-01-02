#include <iostream>
#include <Windows.h>
#include <ctime>

using namespace std;
int main()
{
    DWORD pid = GetCurrentProcessId();
    HANDLE hm = OpenMutex(SYNCHRONIZE, FALSE, L"aMutex");
    for (int i = 0; i < 90; i++) 
    {
        if (i == 30) 
        {
            WaitForSingleObject(hm, INFINITE);
        }
        else if (i == 60) 
        {
            ReleaseMutex(hm);
        }
        Sleep(100);
        cout << "PID = " << pid << " : " << i << endl;
    }
    system("pause");
    return 0;
}