#include "types.h"
#include "riscv.h"
<<<<<<< HEAD
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"
=======
#include "param.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
>>>>>>> pgtbl

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
<<<<<<< HEAD
=======
  
>>>>>>> pgtbl
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

<<<<<<< HEAD
=======

>>>>>>> pgtbl
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

<<<<<<< HEAD
=======

#ifdef LAB_PGTBL
// A system call that reports which pages have been accessed. 
// The system call takes three arguments. 
// First, it takes the starting virtual address of the first user page to check. 
// Second, it takes the number of pages to check. 
// Finally, it takes a user address to a buffer 
// to store the results into a bitmask 
// (a datastructure that uses one bit per page 
// and where the first page corresponds to the least significant bit).

int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  uint64 addr;
  int num;
  uint64 dst;
  if(argaddr(0, &addr) < 0){
    return -1;
  }
  if(argint(1, &num) < 0){
    return -1;
  }
  if(argaddr(2, &dst) < 0){
    return -1;
  }
  return pgaccess(addr, num, dst);
}
#endif

>>>>>>> pgtbl
uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
<<<<<<< HEAD

uint64 
sys_trace(void)
{
  int trace_mask;
  if(argint(0, &trace_mask) < 0)  return -1;
  struct proc *p = myproc();
  char *mask = p->mask;
  for(int i = 0; trace_mask > 0; i++, trace_mask >>= 1){
    if(trace_mask % 2 == 1) mask[i] = '1';
    else mask[i] = '0';
  }
  return 0;
}

uint64
sys_sysinfo(void)
{
  struct proc *p = myproc();
  struct sysinfo info;

  info.freemem = get_freemem();
  info.nproc = get_nproc();
  
  uint64 addr;
  if(argaddr(0, &addr) < 0)
    return  -1;
  
  if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
      return -1;

  return 0;
}
=======
>>>>>>> pgtbl
