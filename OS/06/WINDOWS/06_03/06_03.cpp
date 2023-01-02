#include <iostream>
#include <Windows.h>

#define KB (1024)
#define PG (4 * KB)

using namespace std;

//З C7 199  смещение  = 199*4 = 796 = 0x31C
//в E2 226 смещение  = 226*4 = 904 = 0x0388
//о EE 238 смещение  = 238*4 = 952 = 0x03B8

//З C7
//в E2
//о EE
//страница С7 =199
//смещение E2E = 3630
//Адрес  = 199*pg+3630 = 0x00000000000C4E2E(-2)

int main() {
	int pages = 256;
	int countItems = pages * PG / sizeof(int);

	LPVOID xmemaddr = VirtualAlloc(NULL, pages * PG, MEM_COMMIT, PAGE_READWRITE);
	int* arr = (int*)xmemaddr;
	for (int i = 0; i < countItems; i++) {
		arr[i] = i;
	}
	cout << endl;

	getchar();

	VirtualFree(xmemaddr, NULL, MEM_RELEASE);
	system("pause");
}