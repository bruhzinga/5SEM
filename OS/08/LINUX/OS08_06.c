#define _POSIX_C_SOURCE 199309L
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>

int main() {
	int count = 0;
	
	struct timespec start, end, proc;
	long int tn;   
	int ts;   
	clock_gettime(CLOCK_REALTIME, &start);
	for(;;) {
		count++;
		clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &proc);
		if(proc.tv_sec == 2) break;
	}
	clock_gettime(CLOCK_REALTIME, &end);	
	tn=1000000000*end.tv_sec + end.tv_nsec-1000000000*start.tv_sec - start.tv_nsec;
 	ts=end.tv_sec - start.tv_sec;
	printf("Count: %d\n", count);
	printf("Time: %lds %ldns\n", ts, tn);
	
	exit(0);
}
