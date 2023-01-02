#include <stdio.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

void cycle(int countIteration, char* str) {
	for (int i = 0; i < countIteration; i++) {
		sleep(2);
		printf("%s PID: %d-#%d\n", str, getpid(), i);
	}
}

int main() {
    const char *child_name = "os03_05_1";
	pid_t pid;
	switch(pid=fork()) {
		case -1:
			perror("fork");
			exit(1);
            break;
		case 0:
        if (prctl(PR_SET_NAME, (unsigned long)child_name) == -1) {
            perror("prctl() failed");
            return 1;
        }
			cycle(50, "03_05_1");
            break;
		default:
			cycle(100, "03_05");	
            
	}

	exit(0);
}
