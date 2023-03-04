#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    /*
    xargs后面的参数存在 *argv[]里面，
    |xargs前的参数，即前一条指令的标准输出，将从标准输入里接收，read(0, buf, size)
    */
    char input_buf[32];          //stand input buf
    char *child_argv[32];        //the child's argv
    int child_argc = 0;
    //char unit[32];              //the unit of the child_argv 

    int i;
    //将xargs后面的参数装入
    for(i = 1; i < argc; i++){   
        child_argv[child_argc++] = argv[i];
    }

    int buf_counter; 
    //child_argv[child_argc++] = (char*) malloc(32*sizeof(char));
    char *p = (char*) malloc(32*sizeof(char));
    int p_counter = 0;
    child_argv[child_argc++] = p;

    while((buf_counter = read(0, input_buf, 32)) > 0){
        for(i = 0; i < buf_counter; i++){
            if(input_buf[i] == '\n'){
                p[p_counter++] = 0;
                child_argv[child_argc] = 0;
                //child_argc = argc -1;

                if(fork() == 0){
                    exec(argv[1], child_argv);
                }
                wait(0);

            }else if(input_buf[i] == ' '){
                p[p_counter++] = 0;
                child_argv[child_argc++] = p+p_counter;
                
            }else{
                //input_buf[i]为字符
                p[p_counter++] = input_buf[i];
            }
        }
    }
    exit(0);
}