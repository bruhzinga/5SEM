#include <iostream>
#include<Windows.h>
#include<TlHelp32.h>
#include<iomanip>
#include <process.h>
using namespace std;

int main()
{
	const auto snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);

	PROCESSENTRY32 pe_process_entry; //Описывает запись из списка процессов,
	//находящихся в системном адресном пространстве при создании моментального снимка.

	pe_process_entry.dwSize = sizeof(PROCESSENTRY32);
	try
	{
		if (!Process32First(snapshot, &pe_process_entry))
			throw L"error";

		do
		{
			wcout << L"Name = " << pe_process_entry.szExeFile << endl
				<< L"PID = " << pe_process_entry.th32ProcessID
				<< L", Parent PID = " << pe_process_entry.th32ParentProcessID;

			wcout << endl << L"----------------------" << endl;
		} while (Process32Next(snapshot, &pe_process_entry));
	}
	catch (char* msg)
	{
		wcout << L"Error : " << msg << endl;
	}
	system("pause");
	return 0;
}