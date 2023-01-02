#include <ctime>
#include <iostream>
#include <Windows.h>

int main()
{
    tm tm;
    time_t t1;
    t1 = time(&t1);
    localtime_s(&tm, &t1);
    std::cout << "dd.mm.yyyy hh:mm:ss\n";
    std::cout << tm.tm_mday << "." << tm.tm_mon + 1 << "." << tm.tm_year + 1900 << "  " << tm.tm_hour << ":" << tm.tm_min << ":" << tm.tm_sec << std::endl;
}
