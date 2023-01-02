#include <ctime>
#include <iostream>
#include <Windows.h>

int main()
{
	clock_t t1 = clock();
	bool fl = 0;
	for (int i = 0;; i++)
	{
		float sec = (clock() - t1) / CLOCKS_PER_SEC;
		if ((sec == 5) && (fl == 0))
		{
			std::cout << sec << "  sec: " << i << std::endl;
			fl = 1;
		}
		if ((sec == 10) && (fl == 1))
		{
			std::cout << sec << " sec: " << i << std::endl;
			fl = 0;
		}
		if (sec == 15)
		{
			std::cout << sec << " sec: " << i;
			break;
		}
	}

	exit(0);
}