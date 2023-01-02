//show 1000 messages ever 2 seconds with process id and message number
//compile with gcc -o 5 5.c -lrt
//run with ./5

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    int i;
        for (i = 0; i < 1000; i++)
        {
            printf(" process id: %d, message number: %d \n", getpid(), i);
            sleep(2);
        }
}
