#include <Windows.h>
#include <iostream>

int main()
{
	const auto application_name_1 = L"OS03_02_1.exe";
	const auto application_name_2 = L"OS03_02_2.exe";

	STARTUPINFO si1, si2;
	PROCESS_INFORMATION pi1, pi2;
	ZeroMemory(&si1, sizeof(STARTUPINFO));
	si1.cb = sizeof(STARTUPINFO);
	ZeroMemory(&si2, sizeof(STARTUPINFO));
	si2.cb = sizeof(STARTUPINFO);

	//BOOL CreateProcess
	//(
	//	LPCTSTR lpApplicationName,                 // имя исполняемого модуля
	//	LPTSTR lpCommandLine,                      // Командная строка
	//	LPSECURITY_ATTRIBUTES lpProcessAttributes, // Указатель на структуру SECURITY_ATTRIBUTES
	//	LPSECURITY_ATTRIBUTES lpThreadAttributes,  // Указатель на структуру SECURITY_ATTRIBUTES
	//	BOOL bInheritHandles,                      // Флаг наследования текущего процесса
	//	DWORD dwCreationFlags,                     // Флаги способов создания процесса
	//	LPVOID lpEnvironment,                      // Указатель на блок среды
	//	LPCTSTR lpCurrentDirectory,                // Текущий диск или каталог
	//	LPSTARTUPINFO lpStartupInfo,               // Указатель нас структуру STARTUPINFO
	//	LPPROCESS_INFORMATION lpProcessInformation // Указатель нас структуру PROCESS_INFORMATION
	//)

	if (CreateProcess(application_name_1, nullptr, nullptr, nullptr, FALSE, CREATE_NEW_CONSOLE, nullptr, nullptr, &si1,
		&pi1))
		std::cout << "— Process OS03_02_01 created\n";
	else
		std::cout << "— Process OS03_02_01 not created\n";

	if (CreateProcess(application_name_2, nullptr, nullptr, nullptr, FALSE, CREATE_NEW_CONSOLE, nullptr, nullptr, &si2,
		&pi2))
		std::cout << "— Process OS03_02_02 created\n";
	else
		std::cout << "— Process OS03_02_02 not created\n";

	const auto process_id = GetCurrentProcessId();
	for (int i = 0; i < 100; i++)
	{
		std::cout << i + 1 << ": " << process_id << std::endl;
		Sleep(1000);
	}

	WaitForSingleObject(pi1.hProcess, INFINITE);
	WaitForSingleObject(pi2.hProcess, INFINITE);
	CloseHandle(pi1.hProcess);
	CloseHandle(pi2.hProcess);
}