// Разработайте  консольное Windows-приложение OS05_02x, выполняющее цикл в 1млн  итераций.
// Каждая итерация осуществляет задержку на 200 мс через каждые 1тыс итераций и выводит следующую информацию :
//-номер итерации;
//-идентификатор процесса;
//-идентификатор потока;
//-класс приоритета процесса;
//-приоритет потока :
//-номер назначенного процессора.

#include <windows.h>
#include <iostream>
#include "..\OS05_01\Funcs.h"
using namespace std;

int main()
{
	setlocale(LC_ALL, "Russian");
	int i = 0;
	clock_t start = clock();

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

	system("pause");
}