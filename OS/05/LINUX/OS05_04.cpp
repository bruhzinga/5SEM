// Разработайте  консольное Linux-приложение OS05_04 на языке С++, выводящее на консоль следующую информации:
// -	идентификатор текущего процесса;
// -	идентификатор текущего (main) потока;
// -	приоритет (nice) текущего потока;
// -	номера доступных процессоров.

#include <iostream>
#include <unistd.h>
#include <sched.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/resource.h>

using namespace std;

int main()
{
    cout << "PID: " << getpid() << endl;
    cout << "TID: " << syscall(SYS_gettid) << endl;
    cout << "Nice: " << getpriority(PRIO_PROCESS, 0) << endl;
    cpu_set_t mask;
    CPU_ZERO(&mask);
    sched_getaffinity(0, sizeof(mask), &mask);
    cout << "CPU: ";
    for (int i = 0; i < CPU_SETSIZE; i++)
        if (CPU_ISSET(i, &mask))
            cout << i << " ";
    cout << endl;
    
    return 0;
}
