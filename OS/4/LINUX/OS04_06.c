// Разработайте на языке консольное Linux-приложение OS04_06 на языке С, выполняющее длинный цикл с временной задержкой
//  и с выводом на консоль идентификатора процесса.

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main(void) {
    const pid_t pid = getpid();
    for (int i = 0; i < 1000; ++i) {
        printf("%d-%d\n", pid, i);
        sleep(1);
    }
}