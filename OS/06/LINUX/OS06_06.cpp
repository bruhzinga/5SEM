#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <pthread.h>
#include <sys/syscall.h>
#include <sched.h>

int main() {
	pid_t pid = getpid();
	nice(0);

	for(int i = 0; i < 1000000000; i++) {
		printf("OS06_06 PID %d\n", pid);
		sleep(2);
	}
	
	exit(0);
}