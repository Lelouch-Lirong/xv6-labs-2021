#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

/*
int getpid()
int pipe(int p[])   create a pipe,put read/write FD in p[0] and p[1]
int write(int fd, char *buf, int n)
int read(int fd, char *buf, int n)
*/

int main()
{
    /*
    pro1[0] the read of child
    pro1[1] the write of parent

    pro2[0] the read of parent
    pro2[1] the write of child
    */
    int pro1[2], pro2[2]; 
    
    char buf[1];
    int length = sizeof(buf);
    pipe(pro1);
    pipe(pro2);

    if(fork() == 0){
        //the child 
        close(pro1[1]);
        close(pro2[0]);
        if(read(pro1[0], buf, length) != 1){
            printf("parent -> child recive error!\n");
            exit(1);
        }else{
            printf("%d: received ping\n", getpid());
        }
        if(write(pro2[1], buf, length) != 1){
            printf("child -> parent write error!\n");
            exit(1);
        }

    } else{
        //the parent
        close(pro1[0]);
        close(pro2[1]);
        buf[0] = 'A';
        if(write(pro1[1], buf, length) != 1){
            printf("parent -> child write error!\n");
            exit(1);
        }

        if(read(pro2[0], buf, length) != 1){
            printf("child -> parent recive error!\n");
            exit(1);
        }else{
            printf("%d: received pong\n", getpid());
        }
    }
    wait(0);
    exit(0);

}