#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(){
    printf("Parent process has started\n");
    char *args[]={"./os03_05_1",NULL};
    execv(args[0],args);

    for(int i=0;i<100;++i){
        sleep(1);
        printf("%d-%d \n", getpid(),i);
    }
    exit(0);
}