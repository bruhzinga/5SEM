#include <Windows.h>
#include <iostream>

int main() {
	const auto process_id = GetCurrentProcessId();
	for (auto i = 0; i < 1000; i++) {
		std::cout << i + 1 << ": " << process_id << std::endl;
		Sleep(5000);
	}
}