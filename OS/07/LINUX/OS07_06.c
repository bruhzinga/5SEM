#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>

pthread_mutex_t mx;

void* A(void* arg)
{
	for (int i = 0; i < 90; i++)
	{
		usleep(100000);
		printf("A: %d\n", i);
		if (i == 29)
			pthread_mutex_lock(&mx);
		else if (i == 59)
			pthread_mutex_unlock(&mx);
	}
	pthread_exit("Child thread A");
}

void* B(void* arg)
{
	for (int i = 0; i < 90; i++)
	{
		usleep(100000);
		printf("B: %d\n", i);
		if (i == 29)
			pthread_mutex_lock(&mx);
		else if (i == 59)
			pthread_mutex_unlock(&mx);
	}
	pthread_exit("Child thread B");
}

int main()
{
	pthread_mutex_init(&mx, NULL);
	pthread_t a_th1, a_th2;
	void *r_th1, *r_th2;
	pid_t pid = getpid();

	printf("main: pid = %d \n", pid);

	int res1 = pthread_create(&a_th1, NULL, A, NULL);
	int res2 = pthread_create(&a_th2, NULL, B, NULL);
	for (int i = 0; i < 90; i++)
	{
		usleep(100000);
		printf("Main: %d\n", i);
		if (i == 29)
			pthread_mutex_lock(&mx);
		else if (i == 59)
			pthread_mutex_unlock(&mx);
	}

	int status1 = pthread_join(a_th1, (void**)&r_th1);
	int status2 = pthread_join(a_th2, (void**)&r_th2);
	pthread_mutex_destroy(&mx);
	exit(0);
}
