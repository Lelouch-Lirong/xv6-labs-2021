#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void primise_programme(int *buf, int length)
{
    if(length == 1){
        printf("prime %d\n", *buf);
        exit(0);
    }

    printf("prime %d\n", *buf);
    int i, FD[2]; 
    pipe(FD);

    if(fork() != 0){
        //parent programme
        for(i = 1; i < length; i++){
            if(buf[i] % buf[0] != 0){
                write(FD[1], buf+i, 4);
                //printf("point4: %d\n", buf[i]);
            }
        }
        close(FD[1]); //close the write interface
        wait(0);
        exit(0);
    }else{
        //child programme
        //sleep(1);
        close(FD[1]); //close the write interface
        char buf_read[4];
        int counter = 0;
        while(read(FD[0], buf_read, 4) != 0){
            *buf = *(int*)buf_read;
            //printf("point1: %d\n", *buf);
            counter ++;
            buf += 1;
            //printf("point2: %d\n", *(buf-1));
        }
        close(FD[0]);
        //printf("1\n");
        //printf("point3:%d,%d\n" ,*(buf -counter), counter);
        primise_programme(buf - counter, counter);
        exit(0);
    }
}

int main()
{
    int buf[34];
    int i;
    for(i = 0; i < 34; i++){
        buf[i] = i+2;
    }
    primise_programme(buf, 34);
    exit(0);
}

