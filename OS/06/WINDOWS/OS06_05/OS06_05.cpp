#include <iostream>
#include <Windows.h>

#define KB (1024)

using namespace std;

void sh(HANDLE pheap);

int main() {
	HANDLE heap = HeapCreate(HEAP_NO_SERIALIZE | HEAP_ZERO_MEMORY, 4096 * KB, 0);

	cout << "---------------Before---------------\n";
	sh(heap);

	int* m = (int*)HeapAlloc(heap, HEAP_NO_SERIALIZE | HEAP_ZERO_MEMORY, 300000 * sizeof(int));
	cout << "-- m = " << hex << m << "\n";

	cout << "\n------------After--------------\n";
	sh(heap);

	HeapFree(heap, HEAP_NO_SERIALIZE, m);
	cout << "\n------------HeapFree--------------\n";
	sh(heap);

	HeapDestroy(heap);

	system("pause");
}

void sh(HANDLE pheap) {
	PROCESS_HEAP_ENTRY phe;
	phe.lpData = NULL;
	while (HeapWalk(pheap, &phe)) {
		cout << "-- address = " << hex << phe.lpData
			<< ", size = " << dec << phe.cbData
			<< ((phe.wFlags & PROCESS_HEAP_REGION) ? " R" : "") // начало непрерывной области
			<< ((phe.wFlags & PROCESS_HEAP_UNCOMMITTED_RANGE) ? " U" : "") // нераспределенная область
			<< ((phe.wFlags & PROCESS_HEAP_ENTRY_BUSY) ? " B" : "") // распределенная область
			<< "\n";
	}
	cout << "-----------------------------------\n\n";
}