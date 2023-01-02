// Разработайте  консольное Linux-приложение OS05_06 на языке С, выполняющее  длинный цикл с задержкой в 1сек в  каждой итерации.
// Продемонстрируйте запуск  нескольких приложения OS05_06  в фоновом режиме, и команды bg, fg, jobs, Ctrl+Z,            kill -9  

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    int i;
    for (i = 0; i < 10000000000; i++)
    {
        printf("%d\n", i);
        sleep(1);
    }
    return 0;
}