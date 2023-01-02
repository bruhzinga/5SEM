// Разработайте консольное Windows - приложение OS05_02, принимающее следующие параметры :
//-P1 : целое число, задающее маску доступности процессоров(affinity mask);
//-P2: целое число, задающее класс приоритета первого дочернего процесса;
//-P3: целое число, задающее класс приоритета второго  дочернего процесса.
// Приложение OS05_02 должно вывести в свое консольное окно  заданные параметры  и запустить два одинаковых дочерних процесса OS05_02x,осуществляющих вывод в отдельные консольные окна и имеющих  заданные в параметрах  приоритеты.

#include <windows.h>
#include <iostream>
#include "../OS05_01/Funcs.h"
using namespace std;

int main(int argc, char* argv[])
{
	setlocale(LC_ALL, "Russian");

	////get parameters from user
	//cout << "Chose mode of operation" << endl;
	//cout << "1- All processor available Normal Normal " << endl;
	//cout << "2- All processor available BelowNormal High " << endl;
	//cout << "3- 1 processor available BelowNormlal High " << endl;
	//cout << "4- Custom" << endl;

	int mask;
	DWORD priority1;
	DWORD priority2;

	//int mode;
	//cin >> mode;
	//switch (mode)
	//{
	//case 1:
	//	mask = 0xff;
	//	priority1 = NORMAL_PRIORITY_CLASS;
	//	priority2 = NORMAL_PRIORITY_CLASS;
	//	break;
	//case 2:
	//	mask = 0xff;
	//	priority1 = BELOW_NORMAL_PRIORITY_CLASS;
	//	priority2 = HIGH_PRIORITY_CLASS;
	//	break;

	//case 3:
	//	mask = 0x01;
	//	priority1 = BELOW_NORMAL_PRIORITY_CLASS;
	//	priority2 = HIGH_PRIORITY_CLASS;
	//	break;
	//case 4:
	//	mask = atoi(argv[1]);
	//	priority1 = atoi(argv[2]);
	//	priority2 = atoi(argv[3]);
	//	break;
	//}

	mask = atoi(argv[1]);
	priority1 = atoi(argv[2]);
	priority2 = atoi(argv[3]);

	cout << "Маска доступности процессоров: " << mask << endl;
	cout << "Приоритет первого дочернего процесса: " << priority1 << endl;
	cout << "Приоритет второго дочернего процесса: " << priority2 << endl;
	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	ZeroMemory(&pi, sizeof(pi));
	if (CreateProcess(L"OS05_02x.exe", NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE | priority1, NULL, NULL, &si, &pi))
	{
		SetProcessAffinityMask(pi.hProcess, mask);
		cout << "Child process 1 created" << endl;
		CloseHandle(pi.hProcess);
		CloseHandle(pi.hThread);
	}
	if (CreateProcess(L"OS05_02x.exe", NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE | priority2, NULL, NULL, &si, &pi))
	{
		SetProcessAffinityMask(pi.hProcess, mask);
		cout << "Child process 2 created" << endl;
		CloseHandle(pi.hProcess);
		CloseHandle(pi.hThread);
	}
}