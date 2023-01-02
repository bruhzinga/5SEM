//Разработайте консольное Windows - приложение OS05_03, принимающее следующие параметры :
//-P1 : целое число, задающее маску доступности процессоров(affinity mask);
//-P2: целое число, задающее класс приоритет процесса;
//-P3: целое число, задающее  приоритет   первого  дочернего потока;
//-P4: целое число, задающее  приоритет   второго  дочернего потока.
// Приложение  OS05_03  включает в себя потоковую  функцию TA, выполняющую  цикл в 1млн  итераций, аналогичный  циклу  в задании 02.
// Приложение  OS05_03  должно вывести в свое консольное окно  заданные параметры  и запустить два одинаковых дочерних потока(потоковая функция TA), осуществляющих вывод консольное окно и имеющих  заданные в параметрах  приоритеты.

#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <iostream>
#include <string>
#include "../OS05_01/Funcs.h"
using namespace std;

DWORD WINAPI TA(LPVOID lpParam)
{
	clock_t start = clock();
	int i = 0;
	while (i < 1000000)
	{
		if (i % 1000 == 0)
		{
			cout << "Номер итерации: " << i << endl;
			cout << "Идентификатор процесса: " << GetCurrentProcessId() << endl;
			cout << "Идентификатор потока: " << GetCurrentThreadId() << endl;
			cout << "Класс приоритета процесса: ";
			getProcessPriority(GetCurrentProcess());
			cout << "Приоритет потока: ";
			getThreadPriority(GetCurrentThread());
			cout << "Номер назначенного процессора: " << GetCurrentProcessorNumber() << endl;
			Sleep(200);
		}
		i++;
	}
	clock_t end = clock();
	std::cout << "Time: " << (end - start) / 1000.0 << std::endl;
	return 0;
}

int main(int argc, char* argv[])
{
	setlocale(LC_ALL, "Russian");
	int P1;
	DWORD P2;
	DWORD P3;
	DWORD P4;
	/*cout << "1- all processors normal normal normal" << endl;
	cout << "2- all processors normal lowes highest " << endl;
	cout << "3- 1 processors normal lowest highest " << endl;
	cout << "4-custom " << endl;
	int mode;
	cin >> mode;
	switch (mode)
	{
	case 1:
		P1 = 0xff;
		P2 = NORMAL_PRIORITY_CLASS;
		P3 = THREAD_PRIORITY_NORMAL;
		P4 = THREAD_PRIORITY_NORMAL;
		break;
	case 2:
		P1 = 0xff;
		P2 = NORMAL_PRIORITY_CLASS;
		P3 = THREAD_PRIORITY_LOWEST;
		P4 = THREAD_PRIORITY_HIGHEST;
		break;
	case 3:
		P1 = 0x01;
		P2 = NORMAL_PRIORITY_CLASS;
		P3 = THREAD_PRIORITY_LOWEST;
		P4 = THREAD_PRIORITY_HIGHEST;
		break;
	case 4:
		args
		P1 = atoi(argv[1]);
		P2 = atoi(argv[2]);
		P3 = atoi(argv[3]);
		P4 = atoi(argv[4]);
	}*/
	P1 = atoi(argv[1]);
	P2 = atoi(argv[2]);
	P3 = atoi(argv[3]);
	P4 = atoi(argv[4]);

	cout << "Маска доступности процессоров: " << P1 << endl;
	cout << "Класс приоритета процесса: " << P2 << endl;
	cout << "Приоритет первого дочернего потока: " << P3 << endl;
	cout << "Приоритет второго дочернего потока: " << P4 << endl;
	HANDLE hThread1 = CreateThread(NULL, 0, TA, NULL, 0, NULL);
	HANDLE hThread2 = CreateThread(NULL, 0, TA, NULL, 0, NULL);
	SetProcessAffinityMask(GetCurrentProcess(), P1);
	SetPriorityClass(GetCurrentProcess(), P2);
	SetThreadPriority(hThread1, P3);
	SetThreadPriority(hThread2, P4);
	WaitForSingleObject(hThread1, INFINITE);
	WaitForSingleObject(hThread2, INFINITE);
	CloseHandle(hThread1);
	CloseHandle(hThread2);
	system("pause");
	return 0;
}