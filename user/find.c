#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

//turn the path name to the file name
char* fmtname(char *path)
{
    static char buf[DIRSIZ+1];
    char *p;
    
    for(p = path + strlen(path); p >= path && *p != '/'; p--)
        ;
    p++;

    if(strlen(p) >= DIRSIZ) return p;

    memmove(buf, p, strlen(p)+1);
    return buf;
}

//find the findname in the path
void find(char *path, char *findname)
{
    int fd;
    struct stat st;

    if((fd = open(path, 0)) < 0){
        fprintf(2, "find error: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
        fprintf(2, "find error: cannot stat %s\n", path);
        close(fd);
        return;
    }

    char buf[512], *p;
    struct dirent de;

    switch(st.type){
        //if the *path is a file
        case T_FILE:
            if(strcmp(fmtname(path), findname) == 0){
                printf("%s\n", path);
            }
            break;

        //if the *path is a path
        case T_DIR:     
            if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
                printf("find error: path too long\n");
                break;
            }
            strcpy(buf, path);
            p = buf + strlen(buf);
            *p = '/';
            p++;

            while(read(fd, &de, sizeof(de)) == sizeof(de)){
                if(de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) continue;
                memmove(p, de.name, DIRSIZ);
                p[DIRSIZ] = 0;
                //printf("point 1\n");
                //printf("size:%d\n", strlen(de.name));
                //printf("path:%s\n", buf);
                find(buf, findname);
            }
            break;
    }
    close(fd);
    return;
}

int main(int argc, char *argv[])
{
    if(argc < 3){
        printf("find error:  format is find <path> <filename>");
        exit(1);
    }
    find(argv[1], argv[2]);
    exit(0);
}