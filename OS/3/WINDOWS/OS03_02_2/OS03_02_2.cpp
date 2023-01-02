#include <Windows.h>
#include <iostream>

int main() {
	const auto process_id = GetCurrentProcessId();

	for (auto i = 0; i < 125; i++) {
		std::cout << "os03_02_2 : " << i + 1 << " : " << process_id << std::endl;
		Sleep(1000);
	}
}