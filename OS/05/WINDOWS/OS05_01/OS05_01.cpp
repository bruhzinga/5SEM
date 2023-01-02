//1. Разработайте  консольное Windows-приложение OS05_01 на языке С++, выводящее на консоль следующую информации:
//-идентификатор текущего процесса;
//-идентификатор текущего(main) потока;
//-приоритет(приоритетный класс) текущего процесса;
//-приоритет текущего потока;
//-маску(affinity mask) доступных процессу процессоров в двоичном виде;
//-количество процессоров доступных  процессу;
//-процессор, назначенный текущему потоку.

#include<intrin.h>
#include <iomanip>
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <iostream>
#include <bitset>
#include"Funcs.h"
using namespace std;
void getProcessPriority(HANDLE hp);
void getThreadPriority(HANDLE ht);
void getAffinityMask(HANDLE hp, HANDLE ht);
int main()
{
	HANDLE hp = GetCurrentProcess();
	HANDLE ht = GetCurrentThread();
	//идентификатор текущего процесса;
	cout << "Process ID: " << GetCurrentProcessId() << endl;
	//идентификатор текущего main потока;
	cout << "Thread ID: " << GetCurrentThreadId() << endl;
	getProcessPriority(hp);
	getThreadPriority(ht);
	getAffinityMask(hp, ht);
	system("pause");
	return 0;
}