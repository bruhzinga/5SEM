#include <time.h>
#include <pthread.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h> 

int main()
{
    time_t t = 0;
    t = time(&t);
    printf("dd.mm.yyyy hh:mm:ss\n");
    struct tm *tmprt;
    tmprt = localtime(&t);
    printf("%d.%d.%d %d:%d:%d\n",tmprt->tm_mday, tmprt->tm_mon+1,tmprt->tm_year+1900,tmprt->tm_hour,tmprt->tm_min,tmprt->tm_sec);

}