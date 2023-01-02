#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pthread.h>

void* OS04_07_T1(void* arg){
    pid_t pid = getpid();
    pid_t tid = gettid();
    for(int i=0;i<75;++i){
        sleep(1);
        printf("Child: %d-%d-%d\n",pid,i,tid);
    }   
    pthread_exit("Child thread");
}

int main(){
    pthread_t threadA ;
    void* thr_result;
    pid_t pid = getpid();
    int res = pthread_create(&threadA,NULL,OS04_07_T1,NULL);
    for(int i=0;i<100;++i){
        sleep(1);
        printf("%d-%d\n",pid,i);
    }
    int status = pthread_join(threadA, &thr_result);
    printf("Thread joined, status = %d, result = %s\n", status, (char*)thr_result);    
    exit(0);
}
