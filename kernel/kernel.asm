
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a3013103          	ld	sp,-1488(sp) # 80008a30 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	003050ef          	jal	ra,80005818 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	156080e7          	jalr	342(ra) # 8000019e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1b8080e7          	jalr	440(ra) # 80006212 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	258080e7          	jalr	600(ra) # 800062c6 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c3e080e7          	jalr	-962(ra) # 80005cc8 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	08e080e7          	jalr	142(ra) # 80006182 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	0e6080e7          	jalr	230(ra) # 80006212 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	182080e7          	jalr	386(ra) # 800062c6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	04c080e7          	jalr	76(ra) # 8000019e <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	158080e7          	jalr	344(ra) # 800062c6 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <get_freemem>:

//返回空闲内存
uint64
get_freemem(void)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  struct run *r;
  r = kmem.freelist;
    8000017e:	00009797          	auipc	a5,0x9
    80000182:	eca7b783          	ld	a5,-310(a5) # 80009048 <kmem+0x18>
  int i;
  for(i = 0; r > 0; i++){
    80000186:	cb91                	beqz	a5,8000019a <get_freemem+0x22>
    80000188:	4501                	li	a0,0
    r = r->next;
    8000018a:	639c                	ld	a5,0(a5)
  for(i = 0; r > 0; i++){
    8000018c:	2505                	addiw	a0,a0,1
    8000018e:	fff5                	bnez	a5,8000018a <get_freemem+0x12>
  }
  
  return i * PGSIZE;
}
    80000190:	00c5151b          	slliw	a0,a0,0xc
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret
  for(i = 0; r > 0; i++){
    8000019a:	4501                	li	a0,0
    8000019c:	bfd5                	j	80000190 <get_freemem+0x18>

000000008000019e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a4:	ce09                	beqz	a2,800001be <memset+0x20>
    800001a6:	87aa                	mv	a5,a0
    800001a8:	fff6071b          	addiw	a4,a2,-1
    800001ac:	1702                	slli	a4,a4,0x20
    800001ae:	9301                	srli	a4,a4,0x20
    800001b0:	0705                	addi	a4,a4,1
    800001b2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b8:	0785                	addi	a5,a5,1
    800001ba:	fee79de3          	bne	a5,a4,800001b4 <memset+0x16>
  }
  return dst;
}
    800001be:	6422                	ld	s0,8(sp)
    800001c0:	0141                	addi	sp,sp,16
    800001c2:	8082                	ret

00000000800001c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ca:	ca05                	beqz	a2,800001fa <memcmp+0x36>
    800001cc:	fff6069b          	addiw	a3,a2,-1
    800001d0:	1682                	slli	a3,a3,0x20
    800001d2:	9281                	srli	a3,a3,0x20
    800001d4:	0685                	addi	a3,a3,1
    800001d6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d8:	00054783          	lbu	a5,0(a0)
    800001dc:	0005c703          	lbu	a4,0(a1)
    800001e0:	00e79863          	bne	a5,a4,800001f0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e4:	0505                	addi	a0,a0,1
    800001e6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e8:	fed518e3          	bne	a0,a3,800001d8 <memcmp+0x14>
  }

  return 0;
    800001ec:	4501                	li	a0,0
    800001ee:	a019                	j	800001f4 <memcmp+0x30>
      return *s1 - *s2;
    800001f0:	40e7853b          	subw	a0,a5,a4
}
    800001f4:	6422                	ld	s0,8(sp)
    800001f6:	0141                	addi	sp,sp,16
    800001f8:	8082                	ret
  return 0;
    800001fa:	4501                	li	a0,0
    800001fc:	bfe5                	j	800001f4 <memcmp+0x30>

00000000800001fe <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fe:	1141                	addi	sp,sp,-16
    80000200:	e422                	sd	s0,8(sp)
    80000202:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000204:	ca0d                	beqz	a2,80000236 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000206:	00a5f963          	bgeu	a1,a0,80000218 <memmove+0x1a>
    8000020a:	02061693          	slli	a3,a2,0x20
    8000020e:	9281                	srli	a3,a3,0x20
    80000210:	00d58733          	add	a4,a1,a3
    80000214:	02e56463          	bltu	a0,a4,8000023c <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	0785                	addi	a5,a5,1
    80000222:	97ae                	add	a5,a5,a1
    80000224:	872a                	mv	a4,a0
      *d++ = *s++;
    80000226:	0585                	addi	a1,a1,1
    80000228:	0705                	addi	a4,a4,1
    8000022a:	fff5c683          	lbu	a3,-1(a1)
    8000022e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000232:	fef59ae3          	bne	a1,a5,80000226 <memmove+0x28>

  return dst;
}
    80000236:	6422                	ld	s0,8(sp)
    80000238:	0141                	addi	sp,sp,16
    8000023a:	8082                	ret
    d += n;
    8000023c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000023e:	fff6079b          	addiw	a5,a2,-1
    80000242:	1782                	slli	a5,a5,0x20
    80000244:	9381                	srli	a5,a5,0x20
    80000246:	fff7c793          	not	a5,a5
    8000024a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000024c:	177d                	addi	a4,a4,-1
    8000024e:	16fd                	addi	a3,a3,-1
    80000250:	00074603          	lbu	a2,0(a4)
    80000254:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000258:	fef71ae3          	bne	a4,a5,8000024c <memmove+0x4e>
    8000025c:	bfe9                	j	80000236 <memmove+0x38>

000000008000025e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000025e:	1141                	addi	sp,sp,-16
    80000260:	e406                	sd	ra,8(sp)
    80000262:	e022                	sd	s0,0(sp)
    80000264:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000266:	00000097          	auipc	ra,0x0
    8000026a:	f98080e7          	jalr	-104(ra) # 800001fe <memmove>
}
    8000026e:	60a2                	ld	ra,8(sp)
    80000270:	6402                	ld	s0,0(sp)
    80000272:	0141                	addi	sp,sp,16
    80000274:	8082                	ret

0000000080000276 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e422                	sd	s0,8(sp)
    8000027a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000027c:	ce11                	beqz	a2,80000298 <strncmp+0x22>
    8000027e:	00054783          	lbu	a5,0(a0)
    80000282:	cf89                	beqz	a5,8000029c <strncmp+0x26>
    80000284:	0005c703          	lbu	a4,0(a1)
    80000288:	00f71a63          	bne	a4,a5,8000029c <strncmp+0x26>
    n--, p++, q++;
    8000028c:	367d                	addiw	a2,a2,-1
    8000028e:	0505                	addi	a0,a0,1
    80000290:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000292:	f675                	bnez	a2,8000027e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000294:	4501                	li	a0,0
    80000296:	a809                	j	800002a8 <strncmp+0x32>
    80000298:	4501                	li	a0,0
    8000029a:	a039                	j	800002a8 <strncmp+0x32>
  if(n == 0)
    8000029c:	ca09                	beqz	a2,800002ae <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000029e:	00054503          	lbu	a0,0(a0)
    800002a2:	0005c783          	lbu	a5,0(a1)
    800002a6:	9d1d                	subw	a0,a0,a5
}
    800002a8:	6422                	ld	s0,8(sp)
    800002aa:	0141                	addi	sp,sp,16
    800002ac:	8082                	ret
    return 0;
    800002ae:	4501                	li	a0,0
    800002b0:	bfe5                	j	800002a8 <strncmp+0x32>

00000000800002b2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e422                	sd	s0,8(sp)
    800002b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b8:	872a                	mv	a4,a0
    800002ba:	8832                	mv	a6,a2
    800002bc:	367d                	addiw	a2,a2,-1
    800002be:	01005963          	blez	a6,800002d0 <strncpy+0x1e>
    800002c2:	0705                	addi	a4,a4,1
    800002c4:	0005c783          	lbu	a5,0(a1)
    800002c8:	fef70fa3          	sb	a5,-1(a4)
    800002cc:	0585                	addi	a1,a1,1
    800002ce:	f7f5                	bnez	a5,800002ba <strncpy+0x8>
    ;
  while(n-- > 0)
    800002d0:	00c05d63          	blez	a2,800002ea <strncpy+0x38>
    800002d4:	86ba                	mv	a3,a4
    *s++ = 0;
    800002d6:	0685                	addi	a3,a3,1
    800002d8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002dc:	fff6c793          	not	a5,a3
    800002e0:	9fb9                	addw	a5,a5,a4
    800002e2:	010787bb          	addw	a5,a5,a6
    800002e6:	fef048e3          	bgtz	a5,800002d6 <strncpy+0x24>
  return os;
}
    800002ea:	6422                	ld	s0,8(sp)
    800002ec:	0141                	addi	sp,sp,16
    800002ee:	8082                	ret

00000000800002f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002f0:	1141                	addi	sp,sp,-16
    800002f2:	e422                	sd	s0,8(sp)
    800002f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002f6:	02c05363          	blez	a2,8000031c <safestrcpy+0x2c>
    800002fa:	fff6069b          	addiw	a3,a2,-1
    800002fe:	1682                	slli	a3,a3,0x20
    80000300:	9281                	srli	a3,a3,0x20
    80000302:	96ae                	add	a3,a3,a1
    80000304:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000306:	00d58963          	beq	a1,a3,80000318 <safestrcpy+0x28>
    8000030a:	0585                	addi	a1,a1,1
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff5c703          	lbu	a4,-1(a1)
    80000312:	fee78fa3          	sb	a4,-1(a5)
    80000316:	fb65                	bnez	a4,80000306 <safestrcpy+0x16>
    ;
  *s = 0;
    80000318:	00078023          	sb	zero,0(a5)
  return os;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret

0000000080000322 <strlen>:

int
strlen(const char *s)
{
    80000322:	1141                	addi	sp,sp,-16
    80000324:	e422                	sd	s0,8(sp)
    80000326:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000328:	00054783          	lbu	a5,0(a0)
    8000032c:	cf91                	beqz	a5,80000348 <strlen+0x26>
    8000032e:	0505                	addi	a0,a0,1
    80000330:	87aa                	mv	a5,a0
    80000332:	4685                	li	a3,1
    80000334:	9e89                	subw	a3,a3,a0
    80000336:	00f6853b          	addw	a0,a3,a5
    8000033a:	0785                	addi	a5,a5,1
    8000033c:	fff7c703          	lbu	a4,-1(a5)
    80000340:	fb7d                	bnez	a4,80000336 <strlen+0x14>
    ;
  return n;
}
    80000342:	6422                	ld	s0,8(sp)
    80000344:	0141                	addi	sp,sp,16
    80000346:	8082                	ret
  for(n = 0; s[n]; n++)
    80000348:	4501                	li	a0,0
    8000034a:	bfe5                	j	80000342 <strlen+0x20>

000000008000034c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000034c:	1141                	addi	sp,sp,-16
    8000034e:	e406                	sd	ra,8(sp)
    80000350:	e022                	sd	s0,0(sp)
    80000352:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000354:	00001097          	auipc	ra,0x1
    80000358:	aee080e7          	jalr	-1298(ra) # 80000e42 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000035c:	00009717          	auipc	a4,0x9
    80000360:	ca470713          	addi	a4,a4,-860 # 80009000 <started>
  if(cpuid() == 0){
    80000364:	c139                	beqz	a0,800003aa <main+0x5e>
    while(started == 0)
    80000366:	431c                	lw	a5,0(a4)
    80000368:	2781                	sext.w	a5,a5
    8000036a:	dff5                	beqz	a5,80000366 <main+0x1a>
      ;
    __sync_synchronize();
    8000036c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000370:	00001097          	auipc	ra,0x1
    80000374:	ad2080e7          	jalr	-1326(ra) # 80000e42 <cpuid>
    80000378:	85aa                	mv	a1,a0
    8000037a:	00008517          	auipc	a0,0x8
    8000037e:	cbe50513          	addi	a0,a0,-834 # 80008038 <etext+0x38>
    80000382:	00006097          	auipc	ra,0x6
    80000386:	990080e7          	jalr	-1648(ra) # 80005d12 <printf>
    kvminithart();    // turn on paging
    8000038a:	00000097          	auipc	ra,0x0
    8000038e:	0d8080e7          	jalr	216(ra) # 80000462 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000392:	00001097          	auipc	ra,0x1
    80000396:	790080e7          	jalr	1936(ra) # 80001b22 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000039a:	00005097          	auipc	ra,0x5
    8000039e:	e06080e7          	jalr	-506(ra) # 800051a0 <plicinithart>
  }

  scheduler();        
    800003a2:	00001097          	auipc	ra,0x1
    800003a6:	fea080e7          	jalr	-22(ra) # 8000138c <scheduler>
    consoleinit();
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	830080e7          	jalr	-2000(ra) # 80005bda <consoleinit>
    printfinit();
    800003b2:	00006097          	auipc	ra,0x6
    800003b6:	b46080e7          	jalr	-1210(ra) # 80005ef8 <printfinit>
    printf("\n");
    800003ba:	00008517          	auipc	a0,0x8
    800003be:	c8e50513          	addi	a0,a0,-882 # 80008048 <etext+0x48>
    800003c2:	00006097          	auipc	ra,0x6
    800003c6:	950080e7          	jalr	-1712(ra) # 80005d12 <printf>
    printf("xv6 kernel is booting\n");
    800003ca:	00008517          	auipc	a0,0x8
    800003ce:	c5650513          	addi	a0,a0,-938 # 80008020 <etext+0x20>
    800003d2:	00006097          	auipc	ra,0x6
    800003d6:	940080e7          	jalr	-1728(ra) # 80005d12 <printf>
    printf("\n");
    800003da:	00008517          	auipc	a0,0x8
    800003de:	c6e50513          	addi	a0,a0,-914 # 80008048 <etext+0x48>
    800003e2:	00006097          	auipc	ra,0x6
    800003e6:	930080e7          	jalr	-1744(ra) # 80005d12 <printf>
    kinit();         // physical page allocator
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	cf2080e7          	jalr	-782(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	322080e7          	jalr	802(ra) # 80000714 <kvminit>
    kvminithart();   // turn on paging
    800003fa:	00000097          	auipc	ra,0x0
    800003fe:	068080e7          	jalr	104(ra) # 80000462 <kvminithart>
    procinit();      // process table
    80000402:	00001097          	auipc	ra,0x1
    80000406:	990080e7          	jalr	-1648(ra) # 80000d92 <procinit>
    trapinit();      // trap vectors
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	6f0080e7          	jalr	1776(ra) # 80001afa <trapinit>
    trapinithart();  // install kernel trap vector
    80000412:	00001097          	auipc	ra,0x1
    80000416:	710080e7          	jalr	1808(ra) # 80001b22 <trapinithart>
    plicinit();      // set up interrupt controller
    8000041a:	00005097          	auipc	ra,0x5
    8000041e:	d70080e7          	jalr	-656(ra) # 8000518a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000422:	00005097          	auipc	ra,0x5
    80000426:	d7e080e7          	jalr	-642(ra) # 800051a0 <plicinithart>
    binit();         // buffer cache
    8000042a:	00002097          	auipc	ra,0x2
    8000042e:	f64080e7          	jalr	-156(ra) # 8000238e <binit>
    iinit();         // inode table
    80000432:	00002097          	auipc	ra,0x2
    80000436:	5f4080e7          	jalr	1524(ra) # 80002a26 <iinit>
    fileinit();      // file table
    8000043a:	00003097          	auipc	ra,0x3
    8000043e:	59e080e7          	jalr	1438(ra) # 800039d8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000442:	00005097          	auipc	ra,0x5
    80000446:	e80080e7          	jalr	-384(ra) # 800052c2 <virtio_disk_init>
    userinit();      // first user process
    8000044a:	00001097          	auipc	ra,0x1
    8000044e:	cfc080e7          	jalr	-772(ra) # 80001146 <userinit>
    __sync_synchronize();
    80000452:	0ff0000f          	fence
    started = 1;
    80000456:	4785                	li	a5,1
    80000458:	00009717          	auipc	a4,0x9
    8000045c:	baf72423          	sw	a5,-1112(a4) # 80009000 <started>
    80000460:	b789                	j	800003a2 <main+0x56>

0000000080000462 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000462:	1141                	addi	sp,sp,-16
    80000464:	e422                	sd	s0,8(sp)
    80000466:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000468:	00009797          	auipc	a5,0x9
    8000046c:	ba07b783          	ld	a5,-1120(a5) # 80009008 <kernel_pagetable>
    80000470:	83b1                	srli	a5,a5,0xc
    80000472:	577d                	li	a4,-1
    80000474:	177e                	slli	a4,a4,0x3f
    80000476:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000478:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000047c:	12000073          	sfence.vma
  sfence_vma();
}
    80000480:	6422                	ld	s0,8(sp)
    80000482:	0141                	addi	sp,sp,16
    80000484:	8082                	ret

0000000080000486 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000486:	7139                	addi	sp,sp,-64
    80000488:	fc06                	sd	ra,56(sp)
    8000048a:	f822                	sd	s0,48(sp)
    8000048c:	f426                	sd	s1,40(sp)
    8000048e:	f04a                	sd	s2,32(sp)
    80000490:	ec4e                	sd	s3,24(sp)
    80000492:	e852                	sd	s4,16(sp)
    80000494:	e456                	sd	s5,8(sp)
    80000496:	e05a                	sd	s6,0(sp)
    80000498:	0080                	addi	s0,sp,64
    8000049a:	84aa                	mv	s1,a0
    8000049c:	89ae                	mv	s3,a1
    8000049e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004a0:	57fd                	li	a5,-1
    800004a2:	83e9                	srli	a5,a5,0x1a
    800004a4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004a6:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004a8:	04b7f263          	bgeu	a5,a1,800004ec <walk+0x66>
    panic("walk");
    800004ac:	00008517          	auipc	a0,0x8
    800004b0:	ba450513          	addi	a0,a0,-1116 # 80008050 <etext+0x50>
    800004b4:	00006097          	auipc	ra,0x6
    800004b8:	814080e7          	jalr	-2028(ra) # 80005cc8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004bc:	060a8663          	beqz	s5,80000528 <walk+0xa2>
    800004c0:	00000097          	auipc	ra,0x0
    800004c4:	c58080e7          	jalr	-936(ra) # 80000118 <kalloc>
    800004c8:	84aa                	mv	s1,a0
    800004ca:	c529                	beqz	a0,80000514 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004cc:	6605                	lui	a2,0x1
    800004ce:	4581                	li	a1,0
    800004d0:	00000097          	auipc	ra,0x0
    800004d4:	cce080e7          	jalr	-818(ra) # 8000019e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004d8:	00c4d793          	srli	a5,s1,0xc
    800004dc:	07aa                	slli	a5,a5,0xa
    800004de:	0017e793          	ori	a5,a5,1
    800004e2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004e6:	3a5d                	addiw	s4,s4,-9
    800004e8:	036a0063          	beq	s4,s6,80000508 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ec:	0149d933          	srl	s2,s3,s4
    800004f0:	1ff97913          	andi	s2,s2,511
    800004f4:	090e                	slli	s2,s2,0x3
    800004f6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004f8:	00093483          	ld	s1,0(s2)
    800004fc:	0014f793          	andi	a5,s1,1
    80000500:	dfd5                	beqz	a5,800004bc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000502:	80a9                	srli	s1,s1,0xa
    80000504:	04b2                	slli	s1,s1,0xc
    80000506:	b7c5                	j	800004e6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000508:	00c9d513          	srli	a0,s3,0xc
    8000050c:	1ff57513          	andi	a0,a0,511
    80000510:	050e                	slli	a0,a0,0x3
    80000512:	9526                	add	a0,a0,s1
}
    80000514:	70e2                	ld	ra,56(sp)
    80000516:	7442                	ld	s0,48(sp)
    80000518:	74a2                	ld	s1,40(sp)
    8000051a:	7902                	ld	s2,32(sp)
    8000051c:	69e2                	ld	s3,24(sp)
    8000051e:	6a42                	ld	s4,16(sp)
    80000520:	6aa2                	ld	s5,8(sp)
    80000522:	6b02                	ld	s6,0(sp)
    80000524:	6121                	addi	sp,sp,64
    80000526:	8082                	ret
        return 0;
    80000528:	4501                	li	a0,0
    8000052a:	b7ed                	j	80000514 <walk+0x8e>

000000008000052c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000052c:	57fd                	li	a5,-1
    8000052e:	83e9                	srli	a5,a5,0x1a
    80000530:	00b7f463          	bgeu	a5,a1,80000538 <walkaddr+0xc>
    return 0;
    80000534:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000536:	8082                	ret
{
    80000538:	1141                	addi	sp,sp,-16
    8000053a:	e406                	sd	ra,8(sp)
    8000053c:	e022                	sd	s0,0(sp)
    8000053e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000540:	4601                	li	a2,0
    80000542:	00000097          	auipc	ra,0x0
    80000546:	f44080e7          	jalr	-188(ra) # 80000486 <walk>
  if(pte == 0)
    8000054a:	c105                	beqz	a0,8000056a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000054c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000054e:	0117f693          	andi	a3,a5,17
    80000552:	4745                	li	a4,17
    return 0;
    80000554:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000556:	00e68663          	beq	a3,a4,80000562 <walkaddr+0x36>
}
    8000055a:	60a2                	ld	ra,8(sp)
    8000055c:	6402                	ld	s0,0(sp)
    8000055e:	0141                	addi	sp,sp,16
    80000560:	8082                	ret
  pa = PTE2PA(*pte);
    80000562:	00a7d513          	srli	a0,a5,0xa
    80000566:	0532                	slli	a0,a0,0xc
  return pa;
    80000568:	bfcd                	j	8000055a <walkaddr+0x2e>
    return 0;
    8000056a:	4501                	li	a0,0
    8000056c:	b7fd                	j	8000055a <walkaddr+0x2e>

000000008000056e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000056e:	715d                	addi	sp,sp,-80
    80000570:	e486                	sd	ra,72(sp)
    80000572:	e0a2                	sd	s0,64(sp)
    80000574:	fc26                	sd	s1,56(sp)
    80000576:	f84a                	sd	s2,48(sp)
    80000578:	f44e                	sd	s3,40(sp)
    8000057a:	f052                	sd	s4,32(sp)
    8000057c:	ec56                	sd	s5,24(sp)
    8000057e:	e85a                	sd	s6,16(sp)
    80000580:	e45e                	sd	s7,8(sp)
    80000582:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000584:	c205                	beqz	a2,800005a4 <mappages+0x36>
    80000586:	8aaa                	mv	s5,a0
    80000588:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000058a:	77fd                	lui	a5,0xfffff
    8000058c:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000590:	15fd                	addi	a1,a1,-1
    80000592:	00c589b3          	add	s3,a1,a2
    80000596:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000059a:	8952                	mv	s2,s4
    8000059c:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005a0:	6b85                	lui	s7,0x1
    800005a2:	a015                	j	800005c6 <mappages+0x58>
    panic("mappages: size");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	ab450513          	addi	a0,a0,-1356 # 80008058 <etext+0x58>
    800005ac:	00005097          	auipc	ra,0x5
    800005b0:	71c080e7          	jalr	1820(ra) # 80005cc8 <panic>
      panic("mappages: remap");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	ab450513          	addi	a0,a0,-1356 # 80008068 <etext+0x68>
    800005bc:	00005097          	auipc	ra,0x5
    800005c0:	70c080e7          	jalr	1804(ra) # 80005cc8 <panic>
    a += PGSIZE;
    800005c4:	995e                	add	s2,s2,s7
  for(;;){
    800005c6:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ca:	4605                	li	a2,1
    800005cc:	85ca                	mv	a1,s2
    800005ce:	8556                	mv	a0,s5
    800005d0:	00000097          	auipc	ra,0x0
    800005d4:	eb6080e7          	jalr	-330(ra) # 80000486 <walk>
    800005d8:	cd19                	beqz	a0,800005f6 <mappages+0x88>
    if(*pte & PTE_V)
    800005da:	611c                	ld	a5,0(a0)
    800005dc:	8b85                	andi	a5,a5,1
    800005de:	fbf9                	bnez	a5,800005b4 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e0:	80b1                	srli	s1,s1,0xc
    800005e2:	04aa                	slli	s1,s1,0xa
    800005e4:	0164e4b3          	or	s1,s1,s6
    800005e8:	0014e493          	ori	s1,s1,1
    800005ec:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ee:	fd391be3          	bne	s2,s3,800005c4 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005f2:	4501                	li	a0,0
    800005f4:	a011                	j	800005f8 <mappages+0x8a>
      return -1;
    800005f6:	557d                	li	a0,-1
}
    800005f8:	60a6                	ld	ra,72(sp)
    800005fa:	6406                	ld	s0,64(sp)
    800005fc:	74e2                	ld	s1,56(sp)
    800005fe:	7942                	ld	s2,48(sp)
    80000600:	79a2                	ld	s3,40(sp)
    80000602:	7a02                	ld	s4,32(sp)
    80000604:	6ae2                	ld	s5,24(sp)
    80000606:	6b42                	ld	s6,16(sp)
    80000608:	6ba2                	ld	s7,8(sp)
    8000060a:	6161                	addi	sp,sp,80
    8000060c:	8082                	ret

000000008000060e <kvmmap>:
{
    8000060e:	1141                	addi	sp,sp,-16
    80000610:	e406                	sd	ra,8(sp)
    80000612:	e022                	sd	s0,0(sp)
    80000614:	0800                	addi	s0,sp,16
    80000616:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000618:	86b2                	mv	a3,a2
    8000061a:	863e                	mv	a2,a5
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f52080e7          	jalr	-174(ra) # 8000056e <mappages>
    80000624:	e509                	bnez	a0,8000062e <kvmmap+0x20>
}
    80000626:	60a2                	ld	ra,8(sp)
    80000628:	6402                	ld	s0,0(sp)
    8000062a:	0141                	addi	sp,sp,16
    8000062c:	8082                	ret
    panic("kvmmap");
    8000062e:	00008517          	auipc	a0,0x8
    80000632:	a4a50513          	addi	a0,a0,-1462 # 80008078 <etext+0x78>
    80000636:	00005097          	auipc	ra,0x5
    8000063a:	692080e7          	jalr	1682(ra) # 80005cc8 <panic>

000000008000063e <kvmmake>:
{
    8000063e:	1101                	addi	sp,sp,-32
    80000640:	ec06                	sd	ra,24(sp)
    80000642:	e822                	sd	s0,16(sp)
    80000644:	e426                	sd	s1,8(sp)
    80000646:	e04a                	sd	s2,0(sp)
    80000648:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000064a:	00000097          	auipc	ra,0x0
    8000064e:	ace080e7          	jalr	-1330(ra) # 80000118 <kalloc>
    80000652:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000654:	6605                	lui	a2,0x1
    80000656:	4581                	li	a1,0
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	b46080e7          	jalr	-1210(ra) # 8000019e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	6685                	lui	a3,0x1
    80000664:	10000637          	lui	a2,0x10000
    80000668:	100005b7          	lui	a1,0x10000
    8000066c:	8526                	mv	a0,s1
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	fa0080e7          	jalr	-96(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000676:	4719                	li	a4,6
    80000678:	6685                	lui	a3,0x1
    8000067a:	10001637          	lui	a2,0x10001
    8000067e:	100015b7          	lui	a1,0x10001
    80000682:	8526                	mv	a0,s1
    80000684:	00000097          	auipc	ra,0x0
    80000688:	f8a080e7          	jalr	-118(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068c:	4719                	li	a4,6
    8000068e:	004006b7          	lui	a3,0x400
    80000692:	0c000637          	lui	a2,0xc000
    80000696:	0c0005b7          	lui	a1,0xc000
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f72080e7          	jalr	-142(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a4:	00008917          	auipc	s2,0x8
    800006a8:	95c90913          	addi	s2,s2,-1700 # 80008000 <etext>
    800006ac:	4729                	li	a4,10
    800006ae:	80008697          	auipc	a3,0x80008
    800006b2:	95268693          	addi	a3,a3,-1710 # 8000 <_entry-0x7fff8000>
    800006b6:	4605                	li	a2,1
    800006b8:	067e                	slli	a2,a2,0x1f
    800006ba:	85b2                	mv	a1,a2
    800006bc:	8526                	mv	a0,s1
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	f50080e7          	jalr	-176(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c6:	4719                	li	a4,6
    800006c8:	46c5                	li	a3,17
    800006ca:	06ee                	slli	a3,a3,0x1b
    800006cc:	412686b3          	sub	a3,a3,s2
    800006d0:	864a                	mv	a2,s2
    800006d2:	85ca                	mv	a1,s2
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	f38080e7          	jalr	-200(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006de:	4729                	li	a4,10
    800006e0:	6685                	lui	a3,0x1
    800006e2:	00007617          	auipc	a2,0x7
    800006e6:	91e60613          	addi	a2,a2,-1762 # 80007000 <_trampoline>
    800006ea:	040005b7          	lui	a1,0x4000
    800006ee:	15fd                	addi	a1,a1,-1
    800006f0:	05b2                	slli	a1,a1,0xc
    800006f2:	8526                	mv	a0,s1
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f1a080e7          	jalr	-230(ra) # 8000060e <kvmmap>
  proc_mapstacks(kpgtbl);
    800006fc:	8526                	mv	a0,s1
    800006fe:	00000097          	auipc	ra,0x0
    80000702:	5fe080e7          	jalr	1534(ra) # 80000cfc <proc_mapstacks>
}
    80000706:	8526                	mv	a0,s1
    80000708:	60e2                	ld	ra,24(sp)
    8000070a:	6442                	ld	s0,16(sp)
    8000070c:	64a2                	ld	s1,8(sp)
    8000070e:	6902                	ld	s2,0(sp)
    80000710:	6105                	addi	sp,sp,32
    80000712:	8082                	ret

0000000080000714 <kvminit>:
{
    80000714:	1141                	addi	sp,sp,-16
    80000716:	e406                	sd	ra,8(sp)
    80000718:	e022                	sd	s0,0(sp)
    8000071a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	f22080e7          	jalr	-222(ra) # 8000063e <kvmmake>
    80000724:	00009797          	auipc	a5,0x9
    80000728:	8ea7b223          	sd	a0,-1820(a5) # 80009008 <kernel_pagetable>
}
    8000072c:	60a2                	ld	ra,8(sp)
    8000072e:	6402                	ld	s0,0(sp)
    80000730:	0141                	addi	sp,sp,16
    80000732:	8082                	ret

0000000080000734 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000734:	715d                	addi	sp,sp,-80
    80000736:	e486                	sd	ra,72(sp)
    80000738:	e0a2                	sd	s0,64(sp)
    8000073a:	fc26                	sd	s1,56(sp)
    8000073c:	f84a                	sd	s2,48(sp)
    8000073e:	f44e                	sd	s3,40(sp)
    80000740:	f052                	sd	s4,32(sp)
    80000742:	ec56                	sd	s5,24(sp)
    80000744:	e85a                	sd	s6,16(sp)
    80000746:	e45e                	sd	s7,8(sp)
    80000748:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000074a:	03459793          	slli	a5,a1,0x34
    8000074e:	e795                	bnez	a5,8000077a <uvmunmap+0x46>
    80000750:	8a2a                	mv	s4,a0
    80000752:	892e                	mv	s2,a1
    80000754:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000756:	0632                	slli	a2,a2,0xc
    80000758:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000075c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000075e:	6b05                	lui	s6,0x1
    80000760:	0735e863          	bltu	a1,s3,800007d0 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000764:	60a6                	ld	ra,72(sp)
    80000766:	6406                	ld	s0,64(sp)
    80000768:	74e2                	ld	s1,56(sp)
    8000076a:	7942                	ld	s2,48(sp)
    8000076c:	79a2                	ld	s3,40(sp)
    8000076e:	7a02                	ld	s4,32(sp)
    80000770:	6ae2                	ld	s5,24(sp)
    80000772:	6b42                	ld	s6,16(sp)
    80000774:	6ba2                	ld	s7,8(sp)
    80000776:	6161                	addi	sp,sp,80
    80000778:	8082                	ret
    panic("uvmunmap: not aligned");
    8000077a:	00008517          	auipc	a0,0x8
    8000077e:	90650513          	addi	a0,a0,-1786 # 80008080 <etext+0x80>
    80000782:	00005097          	auipc	ra,0x5
    80000786:	546080e7          	jalr	1350(ra) # 80005cc8 <panic>
      panic("uvmunmap: walk");
    8000078a:	00008517          	auipc	a0,0x8
    8000078e:	90e50513          	addi	a0,a0,-1778 # 80008098 <etext+0x98>
    80000792:	00005097          	auipc	ra,0x5
    80000796:	536080e7          	jalr	1334(ra) # 80005cc8 <panic>
      panic("uvmunmap: not mapped");
    8000079a:	00008517          	auipc	a0,0x8
    8000079e:	90e50513          	addi	a0,a0,-1778 # 800080a8 <etext+0xa8>
    800007a2:	00005097          	auipc	ra,0x5
    800007a6:	526080e7          	jalr	1318(ra) # 80005cc8 <panic>
      panic("uvmunmap: not a leaf");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	91650513          	addi	a0,a0,-1770 # 800080c0 <etext+0xc0>
    800007b2:	00005097          	auipc	ra,0x5
    800007b6:	516080e7          	jalr	1302(ra) # 80005cc8 <panic>
      uint64 pa = PTE2PA(*pte);
    800007ba:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007bc:	0532                	slli	a0,a0,0xc
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	85e080e7          	jalr	-1954(ra) # 8000001c <kfree>
    *pte = 0;
    800007c6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ca:	995a                	add	s2,s2,s6
    800007cc:	f9397ce3          	bgeu	s2,s3,80000764 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d0:	4601                	li	a2,0
    800007d2:	85ca                	mv	a1,s2
    800007d4:	8552                	mv	a0,s4
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	cb0080e7          	jalr	-848(ra) # 80000486 <walk>
    800007de:	84aa                	mv	s1,a0
    800007e0:	d54d                	beqz	a0,8000078a <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e2:	6108                	ld	a0,0(a0)
    800007e4:	00157793          	andi	a5,a0,1
    800007e8:	dbcd                	beqz	a5,8000079a <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ea:	3ff57793          	andi	a5,a0,1023
    800007ee:	fb778ee3          	beq	a5,s7,800007aa <uvmunmap+0x76>
    if(do_free){
    800007f2:	fc0a8ae3          	beqz	s5,800007c6 <uvmunmap+0x92>
    800007f6:	b7d1                	j	800007ba <uvmunmap+0x86>

00000000800007f8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f8:	1101                	addi	sp,sp,-32
    800007fa:	ec06                	sd	ra,24(sp)
    800007fc:	e822                	sd	s0,16(sp)
    800007fe:	e426                	sd	s1,8(sp)
    80000800:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000802:	00000097          	auipc	ra,0x0
    80000806:	916080e7          	jalr	-1770(ra) # 80000118 <kalloc>
    8000080a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000080c:	c519                	beqz	a0,8000081a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000080e:	6605                	lui	a2,0x1
    80000810:	4581                	li	a1,0
    80000812:	00000097          	auipc	ra,0x0
    80000816:	98c080e7          	jalr	-1652(ra) # 8000019e <memset>
  return pagetable;
}
    8000081a:	8526                	mv	a0,s1
    8000081c:	60e2                	ld	ra,24(sp)
    8000081e:	6442                	ld	s0,16(sp)
    80000820:	64a2                	ld	s1,8(sp)
    80000822:	6105                	addi	sp,sp,32
    80000824:	8082                	ret

0000000080000826 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000826:	7179                	addi	sp,sp,-48
    80000828:	f406                	sd	ra,40(sp)
    8000082a:	f022                	sd	s0,32(sp)
    8000082c:	ec26                	sd	s1,24(sp)
    8000082e:	e84a                	sd	s2,16(sp)
    80000830:	e44e                	sd	s3,8(sp)
    80000832:	e052                	sd	s4,0(sp)
    80000834:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000836:	6785                	lui	a5,0x1
    80000838:	04f67863          	bgeu	a2,a5,80000888 <uvminit+0x62>
    8000083c:	8a2a                	mv	s4,a0
    8000083e:	89ae                	mv	s3,a1
    80000840:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000842:	00000097          	auipc	ra,0x0
    80000846:	8d6080e7          	jalr	-1834(ra) # 80000118 <kalloc>
    8000084a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000084c:	6605                	lui	a2,0x1
    8000084e:	4581                	li	a1,0
    80000850:	00000097          	auipc	ra,0x0
    80000854:	94e080e7          	jalr	-1714(ra) # 8000019e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000858:	4779                	li	a4,30
    8000085a:	86ca                	mv	a3,s2
    8000085c:	6605                	lui	a2,0x1
    8000085e:	4581                	li	a1,0
    80000860:	8552                	mv	a0,s4
    80000862:	00000097          	auipc	ra,0x0
    80000866:	d0c080e7          	jalr	-756(ra) # 8000056e <mappages>
  memmove(mem, src, sz);
    8000086a:	8626                	mv	a2,s1
    8000086c:	85ce                	mv	a1,s3
    8000086e:	854a                	mv	a0,s2
    80000870:	00000097          	auipc	ra,0x0
    80000874:	98e080e7          	jalr	-1650(ra) # 800001fe <memmove>
}
    80000878:	70a2                	ld	ra,40(sp)
    8000087a:	7402                	ld	s0,32(sp)
    8000087c:	64e2                	ld	s1,24(sp)
    8000087e:	6942                	ld	s2,16(sp)
    80000880:	69a2                	ld	s3,8(sp)
    80000882:	6a02                	ld	s4,0(sp)
    80000884:	6145                	addi	sp,sp,48
    80000886:	8082                	ret
    panic("inituvm: more than a page");
    80000888:	00008517          	auipc	a0,0x8
    8000088c:	85050513          	addi	a0,a0,-1968 # 800080d8 <etext+0xd8>
    80000890:	00005097          	auipc	ra,0x5
    80000894:	438080e7          	jalr	1080(ra) # 80005cc8 <panic>

0000000080000898 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000898:	1101                	addi	sp,sp,-32
    8000089a:	ec06                	sd	ra,24(sp)
    8000089c:	e822                	sd	s0,16(sp)
    8000089e:	e426                	sd	s1,8(sp)
    800008a0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a4:	00b67d63          	bgeu	a2,a1,800008be <uvmdealloc+0x26>
    800008a8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008aa:	6785                	lui	a5,0x1
    800008ac:	17fd                	addi	a5,a5,-1
    800008ae:	00f60733          	add	a4,a2,a5
    800008b2:	767d                	lui	a2,0xfffff
    800008b4:	8f71                	and	a4,a4,a2
    800008b6:	97ae                	add	a5,a5,a1
    800008b8:	8ff1                	and	a5,a5,a2
    800008ba:	00f76863          	bltu	a4,a5,800008ca <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008be:	8526                	mv	a0,s1
    800008c0:	60e2                	ld	ra,24(sp)
    800008c2:	6442                	ld	s0,16(sp)
    800008c4:	64a2                	ld	s1,8(sp)
    800008c6:	6105                	addi	sp,sp,32
    800008c8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ca:	8f99                	sub	a5,a5,a4
    800008cc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ce:	4685                	li	a3,1
    800008d0:	0007861b          	sext.w	a2,a5
    800008d4:	85ba                	mv	a1,a4
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	e5e080e7          	jalr	-418(ra) # 80000734 <uvmunmap>
    800008de:	b7c5                	j	800008be <uvmdealloc+0x26>

00000000800008e0 <uvmalloc>:
  if(newsz < oldsz)
    800008e0:	0ab66163          	bltu	a2,a1,80000982 <uvmalloc+0xa2>
{
    800008e4:	7139                	addi	sp,sp,-64
    800008e6:	fc06                	sd	ra,56(sp)
    800008e8:	f822                	sd	s0,48(sp)
    800008ea:	f426                	sd	s1,40(sp)
    800008ec:	f04a                	sd	s2,32(sp)
    800008ee:	ec4e                	sd	s3,24(sp)
    800008f0:	e852                	sd	s4,16(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fa:	6985                	lui	s3,0x1
    800008fc:	19fd                	addi	s3,s3,-1
    800008fe:	95ce                	add	a1,a1,s3
    80000900:	79fd                	lui	s3,0xfffff
    80000902:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	08c9f063          	bgeu	s3,a2,80000986 <uvmalloc+0xa6>
    8000090a:	894e                	mv	s2,s3
    mem = kalloc();
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	80c080e7          	jalr	-2036(ra) # 80000118 <kalloc>
    80000914:	84aa                	mv	s1,a0
    if(mem == 0){
    80000916:	c51d                	beqz	a0,80000944 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000918:	6605                	lui	a2,0x1
    8000091a:	4581                	li	a1,0
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	882080e7          	jalr	-1918(ra) # 8000019e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000924:	4779                	li	a4,30
    80000926:	86a6                	mv	a3,s1
    80000928:	6605                	lui	a2,0x1
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	c40080e7          	jalr	-960(ra) # 8000056e <mappages>
    80000936:	e905                	bnez	a0,80000966 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000938:	6785                	lui	a5,0x1
    8000093a:	993e                	add	s2,s2,a5
    8000093c:	fd4968e3          	bltu	s2,s4,8000090c <uvmalloc+0x2c>
  return newsz;
    80000940:	8552                	mv	a0,s4
    80000942:	a809                	j	80000954 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f4e080e7          	jalr	-178(ra) # 80000898 <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
}
    80000954:	70e2                	ld	ra,56(sp)
    80000956:	7442                	ld	s0,48(sp)
    80000958:	74a2                	ld	s1,40(sp)
    8000095a:	7902                	ld	s2,32(sp)
    8000095c:	69e2                	ld	s3,24(sp)
    8000095e:	6a42                	ld	s4,16(sp)
    80000960:	6aa2                	ld	s5,8(sp)
    80000962:	6121                	addi	sp,sp,64
    80000964:	8082                	ret
      kfree(mem);
    80000966:	8526                	mv	a0,s1
    80000968:	fffff097          	auipc	ra,0xfffff
    8000096c:	6b4080e7          	jalr	1716(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000970:	864e                	mv	a2,s3
    80000972:	85ca                	mv	a1,s2
    80000974:	8556                	mv	a0,s5
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	f22080e7          	jalr	-222(ra) # 80000898 <uvmdealloc>
      return 0;
    8000097e:	4501                	li	a0,0
    80000980:	bfd1                	j	80000954 <uvmalloc+0x74>
    return oldsz;
    80000982:	852e                	mv	a0,a1
}
    80000984:	8082                	ret
  return newsz;
    80000986:	8532                	mv	a0,a2
    80000988:	b7f1                	j	80000954 <uvmalloc+0x74>

000000008000098a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000098a:	7179                	addi	sp,sp,-48
    8000098c:	f406                	sd	ra,40(sp)
    8000098e:	f022                	sd	s0,32(sp)
    80000990:	ec26                	sd	s1,24(sp)
    80000992:	e84a                	sd	s2,16(sp)
    80000994:	e44e                	sd	s3,8(sp)
    80000996:	e052                	sd	s4,0(sp)
    80000998:	1800                	addi	s0,sp,48
    8000099a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000099c:	84aa                	mv	s1,a0
    8000099e:	6905                	lui	s2,0x1
    800009a0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a2:	4985                	li	s3,1
    800009a4:	a821                	j	800009bc <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009a6:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009a8:	0532                	slli	a0,a0,0xc
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	fe0080e7          	jalr	-32(ra) # 8000098a <freewalk>
      pagetable[i] = 0;
    800009b2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009b6:	04a1                	addi	s1,s1,8
    800009b8:	03248163          	beq	s1,s2,800009da <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009bc:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009be:	00f57793          	andi	a5,a0,15
    800009c2:	ff3782e3          	beq	a5,s3,800009a6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009c6:	8905                	andi	a0,a0,1
    800009c8:	d57d                	beqz	a0,800009b6 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ca:	00007517          	auipc	a0,0x7
    800009ce:	72e50513          	addi	a0,a0,1838 # 800080f8 <etext+0xf8>
    800009d2:	00005097          	auipc	ra,0x5
    800009d6:	2f6080e7          	jalr	758(ra) # 80005cc8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009da:	8552                	mv	a0,s4
    800009dc:	fffff097          	auipc	ra,0xfffff
    800009e0:	640080e7          	jalr	1600(ra) # 8000001c <kfree>
}
    800009e4:	70a2                	ld	ra,40(sp)
    800009e6:	7402                	ld	s0,32(sp)
    800009e8:	64e2                	ld	s1,24(sp)
    800009ea:	6942                	ld	s2,16(sp)
    800009ec:	69a2                	ld	s3,8(sp)
    800009ee:	6a02                	ld	s4,0(sp)
    800009f0:	6145                	addi	sp,sp,48
    800009f2:	8082                	ret

00000000800009f4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009f4:	1101                	addi	sp,sp,-32
    800009f6:	ec06                	sd	ra,24(sp)
    800009f8:	e822                	sd	s0,16(sp)
    800009fa:	e426                	sd	s1,8(sp)
    800009fc:	1000                	addi	s0,sp,32
    800009fe:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a00:	e999                	bnez	a1,80000a16 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a02:	8526                	mv	a0,s1
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	f86080e7          	jalr	-122(ra) # 8000098a <freewalk>
}
    80000a0c:	60e2                	ld	ra,24(sp)
    80000a0e:	6442                	ld	s0,16(sp)
    80000a10:	64a2                	ld	s1,8(sp)
    80000a12:	6105                	addi	sp,sp,32
    80000a14:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a16:	6605                	lui	a2,0x1
    80000a18:	167d                	addi	a2,a2,-1
    80000a1a:	962e                	add	a2,a2,a1
    80000a1c:	4685                	li	a3,1
    80000a1e:	8231                	srli	a2,a2,0xc
    80000a20:	4581                	li	a1,0
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	d12080e7          	jalr	-750(ra) # 80000734 <uvmunmap>
    80000a2a:	bfe1                	j	80000a02 <uvmfree+0xe>

0000000080000a2c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a2c:	c679                	beqz	a2,80000afa <uvmcopy+0xce>
{
    80000a2e:	715d                	addi	sp,sp,-80
    80000a30:	e486                	sd	ra,72(sp)
    80000a32:	e0a2                	sd	s0,64(sp)
    80000a34:	fc26                	sd	s1,56(sp)
    80000a36:	f84a                	sd	s2,48(sp)
    80000a38:	f44e                	sd	s3,40(sp)
    80000a3a:	f052                	sd	s4,32(sp)
    80000a3c:	ec56                	sd	s5,24(sp)
    80000a3e:	e85a                	sd	s6,16(sp)
    80000a40:	e45e                	sd	s7,8(sp)
    80000a42:	0880                	addi	s0,sp,80
    80000a44:	8b2a                	mv	s6,a0
    80000a46:	8aae                	mv	s5,a1
    80000a48:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a4a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a4c:	4601                	li	a2,0
    80000a4e:	85ce                	mv	a1,s3
    80000a50:	855a                	mv	a0,s6
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	a34080e7          	jalr	-1484(ra) # 80000486 <walk>
    80000a5a:	c531                	beqz	a0,80000aa6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a5c:	6118                	ld	a4,0(a0)
    80000a5e:	00177793          	andi	a5,a4,1
    80000a62:	cbb1                	beqz	a5,80000ab6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a64:	00a75593          	srli	a1,a4,0xa
    80000a68:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a6c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a70:	fffff097          	auipc	ra,0xfffff
    80000a74:	6a8080e7          	jalr	1704(ra) # 80000118 <kalloc>
    80000a78:	892a                	mv	s2,a0
    80000a7a:	c939                	beqz	a0,80000ad0 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a7c:	6605                	lui	a2,0x1
    80000a7e:	85de                	mv	a1,s7
    80000a80:	fffff097          	auipc	ra,0xfffff
    80000a84:	77e080e7          	jalr	1918(ra) # 800001fe <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a88:	8726                	mv	a4,s1
    80000a8a:	86ca                	mv	a3,s2
    80000a8c:	6605                	lui	a2,0x1
    80000a8e:	85ce                	mv	a1,s3
    80000a90:	8556                	mv	a0,s5
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	adc080e7          	jalr	-1316(ra) # 8000056e <mappages>
    80000a9a:	e515                	bnez	a0,80000ac6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a9c:	6785                	lui	a5,0x1
    80000a9e:	99be                	add	s3,s3,a5
    80000aa0:	fb49e6e3          	bltu	s3,s4,80000a4c <uvmcopy+0x20>
    80000aa4:	a081                	j	80000ae4 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aa6:	00007517          	auipc	a0,0x7
    80000aaa:	66250513          	addi	a0,a0,1634 # 80008108 <etext+0x108>
    80000aae:	00005097          	auipc	ra,0x5
    80000ab2:	21a080e7          	jalr	538(ra) # 80005cc8 <panic>
      panic("uvmcopy: page not present");
    80000ab6:	00007517          	auipc	a0,0x7
    80000aba:	67250513          	addi	a0,a0,1650 # 80008128 <etext+0x128>
    80000abe:	00005097          	auipc	ra,0x5
    80000ac2:	20a080e7          	jalr	522(ra) # 80005cc8 <panic>
      kfree(mem);
    80000ac6:	854a                	mv	a0,s2
    80000ac8:	fffff097          	auipc	ra,0xfffff
    80000acc:	554080e7          	jalr	1364(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ad0:	4685                	li	a3,1
    80000ad2:	00c9d613          	srli	a2,s3,0xc
    80000ad6:	4581                	li	a1,0
    80000ad8:	8556                	mv	a0,s5
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	c5a080e7          	jalr	-934(ra) # 80000734 <uvmunmap>
  return -1;
    80000ae2:	557d                	li	a0,-1
}
    80000ae4:	60a6                	ld	ra,72(sp)
    80000ae6:	6406                	ld	s0,64(sp)
    80000ae8:	74e2                	ld	s1,56(sp)
    80000aea:	7942                	ld	s2,48(sp)
    80000aec:	79a2                	ld	s3,40(sp)
    80000aee:	7a02                	ld	s4,32(sp)
    80000af0:	6ae2                	ld	s5,24(sp)
    80000af2:	6b42                	ld	s6,16(sp)
    80000af4:	6ba2                	ld	s7,8(sp)
    80000af6:	6161                	addi	sp,sp,80
    80000af8:	8082                	ret
  return 0;
    80000afa:	4501                	li	a0,0
}
    80000afc:	8082                	ret

0000000080000afe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000afe:	1141                	addi	sp,sp,-16
    80000b00:	e406                	sd	ra,8(sp)
    80000b02:	e022                	sd	s0,0(sp)
    80000b04:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b06:	4601                	li	a2,0
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	97e080e7          	jalr	-1666(ra) # 80000486 <walk>
  if(pte == 0)
    80000b10:	c901                	beqz	a0,80000b20 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b12:	611c                	ld	a5,0(a0)
    80000b14:	9bbd                	andi	a5,a5,-17
    80000b16:	e11c                	sd	a5,0(a0)
}
    80000b18:	60a2                	ld	ra,8(sp)
    80000b1a:	6402                	ld	s0,0(sp)
    80000b1c:	0141                	addi	sp,sp,16
    80000b1e:	8082                	ret
    panic("uvmclear");
    80000b20:	00007517          	auipc	a0,0x7
    80000b24:	62850513          	addi	a0,a0,1576 # 80008148 <etext+0x148>
    80000b28:	00005097          	auipc	ra,0x5
    80000b2c:	1a0080e7          	jalr	416(ra) # 80005cc8 <panic>

0000000080000b30 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b30:	c6bd                	beqz	a3,80000b9e <copyout+0x6e>
{
    80000b32:	715d                	addi	sp,sp,-80
    80000b34:	e486                	sd	ra,72(sp)
    80000b36:	e0a2                	sd	s0,64(sp)
    80000b38:	fc26                	sd	s1,56(sp)
    80000b3a:	f84a                	sd	s2,48(sp)
    80000b3c:	f44e                	sd	s3,40(sp)
    80000b3e:	f052                	sd	s4,32(sp)
    80000b40:	ec56                	sd	s5,24(sp)
    80000b42:	e85a                	sd	s6,16(sp)
    80000b44:	e45e                	sd	s7,8(sp)
    80000b46:	e062                	sd	s8,0(sp)
    80000b48:	0880                	addi	s0,sp,80
    80000b4a:	8b2a                	mv	s6,a0
    80000b4c:	8c2e                	mv	s8,a1
    80000b4e:	8a32                	mv	s4,a2
    80000b50:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b52:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b54:	6a85                	lui	s5,0x1
    80000b56:	a015                	j	80000b7a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b58:	9562                	add	a0,a0,s8
    80000b5a:	0004861b          	sext.w	a2,s1
    80000b5e:	85d2                	mv	a1,s4
    80000b60:	41250533          	sub	a0,a0,s2
    80000b64:	fffff097          	auipc	ra,0xfffff
    80000b68:	69a080e7          	jalr	1690(ra) # 800001fe <memmove>

    len -= n;
    80000b6c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b70:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b72:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b76:	02098263          	beqz	s3,80000b9a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b7a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b7e:	85ca                	mv	a1,s2
    80000b80:	855a                	mv	a0,s6
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	9aa080e7          	jalr	-1622(ra) # 8000052c <walkaddr>
    if(pa0 == 0)
    80000b8a:	cd01                	beqz	a0,80000ba2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b8c:	418904b3          	sub	s1,s2,s8
    80000b90:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b92:	fc99f3e3          	bgeu	s3,s1,80000b58 <copyout+0x28>
    80000b96:	84ce                	mv	s1,s3
    80000b98:	b7c1                	j	80000b58 <copyout+0x28>
  }
  return 0;
    80000b9a:	4501                	li	a0,0
    80000b9c:	a021                	j	80000ba4 <copyout+0x74>
    80000b9e:	4501                	li	a0,0
}
    80000ba0:	8082                	ret
      return -1;
    80000ba2:	557d                	li	a0,-1
}
    80000ba4:	60a6                	ld	ra,72(sp)
    80000ba6:	6406                	ld	s0,64(sp)
    80000ba8:	74e2                	ld	s1,56(sp)
    80000baa:	7942                	ld	s2,48(sp)
    80000bac:	79a2                	ld	s3,40(sp)
    80000bae:	7a02                	ld	s4,32(sp)
    80000bb0:	6ae2                	ld	s5,24(sp)
    80000bb2:	6b42                	ld	s6,16(sp)
    80000bb4:	6ba2                	ld	s7,8(sp)
    80000bb6:	6c02                	ld	s8,0(sp)
    80000bb8:	6161                	addi	sp,sp,80
    80000bba:	8082                	ret

0000000080000bbc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bbc:	c6bd                	beqz	a3,80000c2a <copyin+0x6e>
{
    80000bbe:	715d                	addi	sp,sp,-80
    80000bc0:	e486                	sd	ra,72(sp)
    80000bc2:	e0a2                	sd	s0,64(sp)
    80000bc4:	fc26                	sd	s1,56(sp)
    80000bc6:	f84a                	sd	s2,48(sp)
    80000bc8:	f44e                	sd	s3,40(sp)
    80000bca:	f052                	sd	s4,32(sp)
    80000bcc:	ec56                	sd	s5,24(sp)
    80000bce:	e85a                	sd	s6,16(sp)
    80000bd0:	e45e                	sd	s7,8(sp)
    80000bd2:	e062                	sd	s8,0(sp)
    80000bd4:	0880                	addi	s0,sp,80
    80000bd6:	8b2a                	mv	s6,a0
    80000bd8:	8a2e                	mv	s4,a1
    80000bda:	8c32                	mv	s8,a2
    80000bdc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bde:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000be0:	6a85                	lui	s5,0x1
    80000be2:	a015                	j	80000c06 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000be4:	9562                	add	a0,a0,s8
    80000be6:	0004861b          	sext.w	a2,s1
    80000bea:	412505b3          	sub	a1,a0,s2
    80000bee:	8552                	mv	a0,s4
    80000bf0:	fffff097          	auipc	ra,0xfffff
    80000bf4:	60e080e7          	jalr	1550(ra) # 800001fe <memmove>

    len -= n;
    80000bf8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bfc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bfe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c02:	02098263          	beqz	s3,80000c26 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c06:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c0a:	85ca                	mv	a1,s2
    80000c0c:	855a                	mv	a0,s6
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	91e080e7          	jalr	-1762(ra) # 8000052c <walkaddr>
    if(pa0 == 0)
    80000c16:	cd01                	beqz	a0,80000c2e <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c18:	418904b3          	sub	s1,s2,s8
    80000c1c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c1e:	fc99f3e3          	bgeu	s3,s1,80000be4 <copyin+0x28>
    80000c22:	84ce                	mv	s1,s3
    80000c24:	b7c1                	j	80000be4 <copyin+0x28>
  }
  return 0;
    80000c26:	4501                	li	a0,0
    80000c28:	a021                	j	80000c30 <copyin+0x74>
    80000c2a:	4501                	li	a0,0
}
    80000c2c:	8082                	ret
      return -1;
    80000c2e:	557d                	li	a0,-1
}
    80000c30:	60a6                	ld	ra,72(sp)
    80000c32:	6406                	ld	s0,64(sp)
    80000c34:	74e2                	ld	s1,56(sp)
    80000c36:	7942                	ld	s2,48(sp)
    80000c38:	79a2                	ld	s3,40(sp)
    80000c3a:	7a02                	ld	s4,32(sp)
    80000c3c:	6ae2                	ld	s5,24(sp)
    80000c3e:	6b42                	ld	s6,16(sp)
    80000c40:	6ba2                	ld	s7,8(sp)
    80000c42:	6c02                	ld	s8,0(sp)
    80000c44:	6161                	addi	sp,sp,80
    80000c46:	8082                	ret

0000000080000c48 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c48:	c6c5                	beqz	a3,80000cf0 <copyinstr+0xa8>
{
    80000c4a:	715d                	addi	sp,sp,-80
    80000c4c:	e486                	sd	ra,72(sp)
    80000c4e:	e0a2                	sd	s0,64(sp)
    80000c50:	fc26                	sd	s1,56(sp)
    80000c52:	f84a                	sd	s2,48(sp)
    80000c54:	f44e                	sd	s3,40(sp)
    80000c56:	f052                	sd	s4,32(sp)
    80000c58:	ec56                	sd	s5,24(sp)
    80000c5a:	e85a                	sd	s6,16(sp)
    80000c5c:	e45e                	sd	s7,8(sp)
    80000c5e:	0880                	addi	s0,sp,80
    80000c60:	8a2a                	mv	s4,a0
    80000c62:	8b2e                	mv	s6,a1
    80000c64:	8bb2                	mv	s7,a2
    80000c66:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c68:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c6a:	6985                	lui	s3,0x1
    80000c6c:	a035                	j	80000c98 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c6e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c72:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c74:	0017b793          	seqz	a5,a5
    80000c78:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c7c:	60a6                	ld	ra,72(sp)
    80000c7e:	6406                	ld	s0,64(sp)
    80000c80:	74e2                	ld	s1,56(sp)
    80000c82:	7942                	ld	s2,48(sp)
    80000c84:	79a2                	ld	s3,40(sp)
    80000c86:	7a02                	ld	s4,32(sp)
    80000c88:	6ae2                	ld	s5,24(sp)
    80000c8a:	6b42                	ld	s6,16(sp)
    80000c8c:	6ba2                	ld	s7,8(sp)
    80000c8e:	6161                	addi	sp,sp,80
    80000c90:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c92:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c96:	c8a9                	beqz	s1,80000ce8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c98:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c9c:	85ca                	mv	a1,s2
    80000c9e:	8552                	mv	a0,s4
    80000ca0:	00000097          	auipc	ra,0x0
    80000ca4:	88c080e7          	jalr	-1908(ra) # 8000052c <walkaddr>
    if(pa0 == 0)
    80000ca8:	c131                	beqz	a0,80000cec <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000caa:	41790833          	sub	a6,s2,s7
    80000cae:	984e                	add	a6,a6,s3
    if(n > max)
    80000cb0:	0104f363          	bgeu	s1,a6,80000cb6 <copyinstr+0x6e>
    80000cb4:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cb6:	955e                	add	a0,a0,s7
    80000cb8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cbc:	fc080be3          	beqz	a6,80000c92 <copyinstr+0x4a>
    80000cc0:	985a                	add	a6,a6,s6
    80000cc2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cc4:	41650633          	sub	a2,a0,s6
    80000cc8:	14fd                	addi	s1,s1,-1
    80000cca:	9b26                	add	s6,s6,s1
    80000ccc:	00f60733          	add	a4,a2,a5
    80000cd0:	00074703          	lbu	a4,0(a4)
    80000cd4:	df49                	beqz	a4,80000c6e <copyinstr+0x26>
        *dst = *p;
    80000cd6:	00e78023          	sb	a4,0(a5)
      --max;
    80000cda:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cde:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ce0:	ff0796e3          	bne	a5,a6,80000ccc <copyinstr+0x84>
      dst++;
    80000ce4:	8b42                	mv	s6,a6
    80000ce6:	b775                	j	80000c92 <copyinstr+0x4a>
    80000ce8:	4781                	li	a5,0
    80000cea:	b769                	j	80000c74 <copyinstr+0x2c>
      return -1;
    80000cec:	557d                	li	a0,-1
    80000cee:	b779                	j	80000c7c <copyinstr+0x34>
  int got_null = 0;
    80000cf0:	4781                	li	a5,0
  if(got_null){
    80000cf2:	0017b793          	seqz	a5,a5
    80000cf6:	40f00533          	neg	a0,a5
}
    80000cfa:	8082                	ret

0000000080000cfc <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cfc:	7139                	addi	sp,sp,-64
    80000cfe:	fc06                	sd	ra,56(sp)
    80000d00:	f822                	sd	s0,48(sp)
    80000d02:	f426                	sd	s1,40(sp)
    80000d04:	f04a                	sd	s2,32(sp)
    80000d06:	ec4e                	sd	s3,24(sp)
    80000d08:	e852                	sd	s4,16(sp)
    80000d0a:	e456                	sd	s5,8(sp)
    80000d0c:	e05a                	sd	s6,0(sp)
    80000d0e:	0080                	addi	s0,sp,64
    80000d10:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	00008497          	auipc	s1,0x8
    80000d16:	76e48493          	addi	s1,s1,1902 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	8b26                	mv	s6,s1
    80000d1c:	00007a97          	auipc	s5,0x7
    80000d20:	2e4a8a93          	addi	s5,s5,740 # 80008000 <etext>
    80000d24:	04000937          	lui	s2,0x4000
    80000d28:	197d                	addi	s2,s2,-1
    80000d2a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2c:	0000fa17          	auipc	s4,0xf
    80000d30:	954a0a13          	addi	s4,s4,-1708 # 8000f680 <tickslock>
    char *pa = kalloc();
    80000d34:	fffff097          	auipc	ra,0xfffff
    80000d38:	3e4080e7          	jalr	996(ra) # 80000118 <kalloc>
    80000d3c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d3e:	c131                	beqz	a0,80000d82 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d40:	416485b3          	sub	a1,s1,s6
    80000d44:	858d                	srai	a1,a1,0x3
    80000d46:	000ab783          	ld	a5,0(s5)
    80000d4a:	02f585b3          	mul	a1,a1,a5
    80000d4e:	2585                	addiw	a1,a1,1
    80000d50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b905b3          	sub	a1,s2,a1
    80000d5c:	854e                	mv	a0,s3
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	8b0080e7          	jalr	-1872(ra) # 8000060e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d66:	18848493          	addi	s1,s1,392
    80000d6a:	fd4495e3          	bne	s1,s4,80000d34 <proc_mapstacks+0x38>
  }
}
    80000d6e:	70e2                	ld	ra,56(sp)
    80000d70:	7442                	ld	s0,48(sp)
    80000d72:	74a2                	ld	s1,40(sp)
    80000d74:	7902                	ld	s2,32(sp)
    80000d76:	69e2                	ld	s3,24(sp)
    80000d78:	6a42                	ld	s4,16(sp)
    80000d7a:	6aa2                	ld	s5,8(sp)
    80000d7c:	6b02                	ld	s6,0(sp)
    80000d7e:	6121                	addi	sp,sp,64
    80000d80:	8082                	ret
      panic("kalloc");
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	3d650513          	addi	a0,a0,982 # 80008158 <etext+0x158>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	f3e080e7          	jalr	-194(ra) # 80005cc8 <panic>

0000000080000d92 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d92:	7139                	addi	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	e05a                	sd	s6,0(sp)
    80000da4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da6:	00007597          	auipc	a1,0x7
    80000daa:	3ba58593          	addi	a1,a1,954 # 80008160 <etext+0x160>
    80000dae:	00008517          	auipc	a0,0x8
    80000db2:	2a250513          	addi	a0,a0,674 # 80009050 <pid_lock>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	3cc080e7          	jalr	972(ra) # 80006182 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	2a250513          	addi	a0,a0,674 # 80009068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	3b4080e7          	jalr	948(ra) # 80006182 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	00008497          	auipc	s1,0x8
    80000dda:	6aa48493          	addi	s1,s1,1706 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	00007a17          	auipc	s4,0x7
    80000dec:	218a0a13          	addi	s4,s4,536 # 80008000 <etext>
    80000df0:	04000937          	lui	s2,0x4000
    80000df4:	197d                	addi	s2,s2,-1
    80000df6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df8:	0000f997          	auipc	s3,0xf
    80000dfc:	88898993          	addi	s3,s3,-1912 # 8000f680 <tickslock>
      initlock(&p->lock, "proc");
    80000e00:	85da                	mv	a1,s6
    80000e02:	8526                	mv	a0,s1
    80000e04:	00005097          	auipc	ra,0x5
    80000e08:	37e080e7          	jalr	894(ra) # 80006182 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e0c:	415487b3          	sub	a5,s1,s5
    80000e10:	878d                	srai	a5,a5,0x3
    80000e12:	000a3703          	ld	a4,0(s4)
    80000e16:	02e787b3          	mul	a5,a5,a4
    80000e1a:	2785                	addiw	a5,a5,1
    80000e1c:	00d7979b          	slliw	a5,a5,0xd
    80000e20:	40f907b3          	sub	a5,s2,a5
    80000e24:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e26:	18848493          	addi	s1,s1,392
    80000e2a:	fd349be3          	bne	s1,s3,80000e00 <procinit+0x6e>
  }
}
    80000e2e:	70e2                	ld	ra,56(sp)
    80000e30:	7442                	ld	s0,48(sp)
    80000e32:	74a2                	ld	s1,40(sp)
    80000e34:	7902                	ld	s2,32(sp)
    80000e36:	69e2                	ld	s3,24(sp)
    80000e38:	6a42                	ld	s4,16(sp)
    80000e3a:	6aa2                	ld	s5,8(sp)
    80000e3c:	6b02                	ld	s6,0(sp)
    80000e3e:	6121                	addi	sp,sp,64
    80000e40:	8082                	ret

0000000080000e42 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e422                	sd	s0,8(sp)
    80000e46:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e48:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e4a:	2501                	sext.w	a0,a0
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e52:	1141                	addi	sp,sp,-16
    80000e54:	e422                	sd	s0,8(sp)
    80000e56:	0800                	addi	s0,sp,16
    80000e58:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e5a:	2781                	sext.w	a5,a5
    80000e5c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e5e:	00008517          	auipc	a0,0x8
    80000e62:	22250513          	addi	a0,a0,546 # 80009080 <cpus>
    80000e66:	953e                	add	a0,a0,a5
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret

0000000080000e6e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e6e:	1101                	addi	sp,sp,-32
    80000e70:	ec06                	sd	ra,24(sp)
    80000e72:	e822                	sd	s0,16(sp)
    80000e74:	e426                	sd	s1,8(sp)
    80000e76:	1000                	addi	s0,sp,32
  push_off();
    80000e78:	00005097          	auipc	ra,0x5
    80000e7c:	34e080e7          	jalr	846(ra) # 800061c6 <push_off>
    80000e80:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e82:	2781                	sext.w	a5,a5
    80000e84:	079e                	slli	a5,a5,0x7
    80000e86:	00008717          	auipc	a4,0x8
    80000e8a:	1ca70713          	addi	a4,a4,458 # 80009050 <pid_lock>
    80000e8e:	97ba                	add	a5,a5,a4
    80000e90:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e92:	00005097          	auipc	ra,0x5
    80000e96:	3d4080e7          	jalr	980(ra) # 80006266 <pop_off>
  return p;
}
    80000e9a:	8526                	mv	a0,s1
    80000e9c:	60e2                	ld	ra,24(sp)
    80000e9e:	6442                	ld	s0,16(sp)
    80000ea0:	64a2                	ld	s1,8(sp)
    80000ea2:	6105                	addi	sp,sp,32
    80000ea4:	8082                	ret

0000000080000ea6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ea6:	1141                	addi	sp,sp,-16
    80000ea8:	e406                	sd	ra,8(sp)
    80000eaa:	e022                	sd	s0,0(sp)
    80000eac:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eae:	00000097          	auipc	ra,0x0
    80000eb2:	fc0080e7          	jalr	-64(ra) # 80000e6e <myproc>
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	410080e7          	jalr	1040(ra) # 800062c6 <release>

  if (first) {
    80000ebe:	00008797          	auipc	a5,0x8
    80000ec2:	b227a783          	lw	a5,-1246(a5) # 800089e0 <first.1678>
    80000ec6:	eb89                	bnez	a5,80000ed8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ec8:	00001097          	auipc	ra,0x1
    80000ecc:	c72080e7          	jalr	-910(ra) # 80001b3a <usertrapret>
}
    80000ed0:	60a2                	ld	ra,8(sp)
    80000ed2:	6402                	ld	s0,0(sp)
    80000ed4:	0141                	addi	sp,sp,16
    80000ed6:	8082                	ret
    first = 0;
    80000ed8:	00008797          	auipc	a5,0x8
    80000edc:	b007a423          	sw	zero,-1272(a5) # 800089e0 <first.1678>
    fsinit(ROOTDEV);
    80000ee0:	4505                	li	a0,1
    80000ee2:	00002097          	auipc	ra,0x2
    80000ee6:	ac4080e7          	jalr	-1340(ra) # 800029a6 <fsinit>
    80000eea:	bff9                	j	80000ec8 <forkret+0x22>

0000000080000eec <allocpid>:
allocpid() {
    80000eec:	1101                	addi	sp,sp,-32
    80000eee:	ec06                	sd	ra,24(sp)
    80000ef0:	e822                	sd	s0,16(sp)
    80000ef2:	e426                	sd	s1,8(sp)
    80000ef4:	e04a                	sd	s2,0(sp)
    80000ef6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ef8:	00008917          	auipc	s2,0x8
    80000efc:	15890913          	addi	s2,s2,344 # 80009050 <pid_lock>
    80000f00:	854a                	mv	a0,s2
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	310080e7          	jalr	784(ra) # 80006212 <acquire>
  pid = nextpid;
    80000f0a:	00008797          	auipc	a5,0x8
    80000f0e:	ada78793          	addi	a5,a5,-1318 # 800089e4 <nextpid>
    80000f12:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f14:	0014871b          	addiw	a4,s1,1
    80000f18:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f1a:	854a                	mv	a0,s2
    80000f1c:	00005097          	auipc	ra,0x5
    80000f20:	3aa080e7          	jalr	938(ra) # 800062c6 <release>
}
    80000f24:	8526                	mv	a0,s1
    80000f26:	60e2                	ld	ra,24(sp)
    80000f28:	6442                	ld	s0,16(sp)
    80000f2a:	64a2                	ld	s1,8(sp)
    80000f2c:	6902                	ld	s2,0(sp)
    80000f2e:	6105                	addi	sp,sp,32
    80000f30:	8082                	ret

0000000080000f32 <proc_pagetable>:
{
    80000f32:	1101                	addi	sp,sp,-32
    80000f34:	ec06                	sd	ra,24(sp)
    80000f36:	e822                	sd	s0,16(sp)
    80000f38:	e426                	sd	s1,8(sp)
    80000f3a:	e04a                	sd	s2,0(sp)
    80000f3c:	1000                	addi	s0,sp,32
    80000f3e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f40:	00000097          	auipc	ra,0x0
    80000f44:	8b8080e7          	jalr	-1864(ra) # 800007f8 <uvmcreate>
    80000f48:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f4a:	c121                	beqz	a0,80000f8a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f4c:	4729                	li	a4,10
    80000f4e:	00006697          	auipc	a3,0x6
    80000f52:	0b268693          	addi	a3,a3,178 # 80007000 <_trampoline>
    80000f56:	6605                	lui	a2,0x1
    80000f58:	040005b7          	lui	a1,0x4000
    80000f5c:	15fd                	addi	a1,a1,-1
    80000f5e:	05b2                	slli	a1,a1,0xc
    80000f60:	fffff097          	auipc	ra,0xfffff
    80000f64:	60e080e7          	jalr	1550(ra) # 8000056e <mappages>
    80000f68:	02054863          	bltz	a0,80000f98 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f6c:	4719                	li	a4,6
    80000f6e:	05893683          	ld	a3,88(s2)
    80000f72:	6605                	lui	a2,0x1
    80000f74:	020005b7          	lui	a1,0x2000
    80000f78:	15fd                	addi	a1,a1,-1
    80000f7a:	05b6                	slli	a1,a1,0xd
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	fffff097          	auipc	ra,0xfffff
    80000f82:	5f0080e7          	jalr	1520(ra) # 8000056e <mappages>
    80000f86:	02054163          	bltz	a0,80000fa8 <proc_pagetable+0x76>
}
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	60e2                	ld	ra,24(sp)
    80000f8e:	6442                	ld	s0,16(sp)
    80000f90:	64a2                	ld	s1,8(sp)
    80000f92:	6902                	ld	s2,0(sp)
    80000f94:	6105                	addi	sp,sp,32
    80000f96:	8082                	ret
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a58080e7          	jalr	-1448(ra) # 800009f4 <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	b7d5                	j	80000f8a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa8:	4681                	li	a3,0
    80000faa:	4605                	li	a2,1
    80000fac:	040005b7          	lui	a1,0x4000
    80000fb0:	15fd                	addi	a1,a1,-1
    80000fb2:	05b2                	slli	a1,a1,0xc
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	fffff097          	auipc	ra,0xfffff
    80000fba:	77e080e7          	jalr	1918(ra) # 80000734 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fbe:	4581                	li	a1,0
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	00000097          	auipc	ra,0x0
    80000fc6:	a32080e7          	jalr	-1486(ra) # 800009f4 <uvmfree>
    return 0;
    80000fca:	4481                	li	s1,0
    80000fcc:	bf7d                	j	80000f8a <proc_pagetable+0x58>

0000000080000fce <proc_freepagetable>:
{
    80000fce:	1101                	addi	sp,sp,-32
    80000fd0:	ec06                	sd	ra,24(sp)
    80000fd2:	e822                	sd	s0,16(sp)
    80000fd4:	e426                	sd	s1,8(sp)
    80000fd6:	e04a                	sd	s2,0(sp)
    80000fd8:	1000                	addi	s0,sp,32
    80000fda:	84aa                	mv	s1,a0
    80000fdc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fde:	4681                	li	a3,0
    80000fe0:	4605                	li	a2,1
    80000fe2:	040005b7          	lui	a1,0x4000
    80000fe6:	15fd                	addi	a1,a1,-1
    80000fe8:	05b2                	slli	a1,a1,0xc
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	74a080e7          	jalr	1866(ra) # 80000734 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ff2:	4681                	li	a3,0
    80000ff4:	4605                	li	a2,1
    80000ff6:	020005b7          	lui	a1,0x2000
    80000ffa:	15fd                	addi	a1,a1,-1
    80000ffc:	05b6                	slli	a1,a1,0xd
    80000ffe:	8526                	mv	a0,s1
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	734080e7          	jalr	1844(ra) # 80000734 <uvmunmap>
  uvmfree(pagetable, sz);
    80001008:	85ca                	mv	a1,s2
    8000100a:	8526                	mv	a0,s1
    8000100c:	00000097          	auipc	ra,0x0
    80001010:	9e8080e7          	jalr	-1560(ra) # 800009f4 <uvmfree>
}
    80001014:	60e2                	ld	ra,24(sp)
    80001016:	6442                	ld	s0,16(sp)
    80001018:	64a2                	ld	s1,8(sp)
    8000101a:	6902                	ld	s2,0(sp)
    8000101c:	6105                	addi	sp,sp,32
    8000101e:	8082                	ret

0000000080001020 <freeproc>:
{
    80001020:	1101                	addi	sp,sp,-32
    80001022:	ec06                	sd	ra,24(sp)
    80001024:	e822                	sd	s0,16(sp)
    80001026:	e426                	sd	s1,8(sp)
    80001028:	1000                	addi	s0,sp,32
    8000102a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000102c:	6d28                	ld	a0,88(a0)
    8000102e:	c509                	beqz	a0,80001038 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001030:	fffff097          	auipc	ra,0xfffff
    80001034:	fec080e7          	jalr	-20(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001038:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000103c:	68a8                	ld	a0,80(s1)
    8000103e:	c511                	beqz	a0,8000104a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001040:	64ac                	ld	a1,72(s1)
    80001042:	00000097          	auipc	ra,0x0
    80001046:	f8c080e7          	jalr	-116(ra) # 80000fce <proc_freepagetable>
  p->pagetable = 0;
    8000104a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000104e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001052:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001056:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000105a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000105e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001062:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001066:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000106a:	0004ac23          	sw	zero,24(s1)
}
    8000106e:	60e2                	ld	ra,24(sp)
    80001070:	6442                	ld	s0,16(sp)
    80001072:	64a2                	ld	s1,8(sp)
    80001074:	6105                	addi	sp,sp,32
    80001076:	8082                	ret

0000000080001078 <allocproc>:
{
    80001078:	1101                	addi	sp,sp,-32
    8000107a:	ec06                	sd	ra,24(sp)
    8000107c:	e822                	sd	s0,16(sp)
    8000107e:	e426                	sd	s1,8(sp)
    80001080:	e04a                	sd	s2,0(sp)
    80001082:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001084:	00008497          	auipc	s1,0x8
    80001088:	3fc48493          	addi	s1,s1,1020 # 80009480 <proc>
    8000108c:	0000e917          	auipc	s2,0xe
    80001090:	5f490913          	addi	s2,s2,1524 # 8000f680 <tickslock>
    acquire(&p->lock);
    80001094:	8526                	mv	a0,s1
    80001096:	00005097          	auipc	ra,0x5
    8000109a:	17c080e7          	jalr	380(ra) # 80006212 <acquire>
    if(p->state == UNUSED) {
    8000109e:	4c9c                	lw	a5,24(s1)
    800010a0:	cf81                	beqz	a5,800010b8 <allocproc+0x40>
      release(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	222080e7          	jalr	546(ra) # 800062c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ac:	18848493          	addi	s1,s1,392
    800010b0:	ff2492e3          	bne	s1,s2,80001094 <allocproc+0x1c>
  return 0;
    800010b4:	4481                	li	s1,0
    800010b6:	a889                	j	80001108 <allocproc+0x90>
  p->pid = allocpid();
    800010b8:	00000097          	auipc	ra,0x0
    800010bc:	e34080e7          	jalr	-460(ra) # 80000eec <allocpid>
    800010c0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010c2:	4785                	li	a5,1
    800010c4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c6:	fffff097          	auipc	ra,0xfffff
    800010ca:	052080e7          	jalr	82(ra) # 80000118 <kalloc>
    800010ce:	892a                	mv	s2,a0
    800010d0:	eca8                	sd	a0,88(s1)
    800010d2:	c131                	beqz	a0,80001116 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010d4:	8526                	mv	a0,s1
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	e5c080e7          	jalr	-420(ra) # 80000f32 <proc_pagetable>
    800010de:	892a                	mv	s2,a0
    800010e0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010e2:	c531                	beqz	a0,8000112e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010e4:	07000613          	li	a2,112
    800010e8:	4581                	li	a1,0
    800010ea:	06048513          	addi	a0,s1,96
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	0b0080e7          	jalr	176(ra) # 8000019e <memset>
  p->context.ra = (uint64)forkret;
    800010f6:	00000797          	auipc	a5,0x0
    800010fa:	db078793          	addi	a5,a5,-592 # 80000ea6 <forkret>
    800010fe:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001100:	60bc                	ld	a5,64(s1)
    80001102:	6705                	lui	a4,0x1
    80001104:	97ba                	add	a5,a5,a4
    80001106:	f4bc                	sd	a5,104(s1)
}
    80001108:	8526                	mv	a0,s1
    8000110a:	60e2                	ld	ra,24(sp)
    8000110c:	6442                	ld	s0,16(sp)
    8000110e:	64a2                	ld	s1,8(sp)
    80001110:	6902                	ld	s2,0(sp)
    80001112:	6105                	addi	sp,sp,32
    80001114:	8082                	ret
    freeproc(p);
    80001116:	8526                	mv	a0,s1
    80001118:	00000097          	auipc	ra,0x0
    8000111c:	f08080e7          	jalr	-248(ra) # 80001020 <freeproc>
    release(&p->lock);
    80001120:	8526                	mv	a0,s1
    80001122:	00005097          	auipc	ra,0x5
    80001126:	1a4080e7          	jalr	420(ra) # 800062c6 <release>
    return 0;
    8000112a:	84ca                	mv	s1,s2
    8000112c:	bff1                	j	80001108 <allocproc+0x90>
    freeproc(p);
    8000112e:	8526                	mv	a0,s1
    80001130:	00000097          	auipc	ra,0x0
    80001134:	ef0080e7          	jalr	-272(ra) # 80001020 <freeproc>
    release(&p->lock);
    80001138:	8526                	mv	a0,s1
    8000113a:	00005097          	auipc	ra,0x5
    8000113e:	18c080e7          	jalr	396(ra) # 800062c6 <release>
    return 0;
    80001142:	84ca                	mv	s1,s2
    80001144:	b7d1                	j	80001108 <allocproc+0x90>

0000000080001146 <userinit>:
{
    80001146:	1101                	addi	sp,sp,-32
    80001148:	ec06                	sd	ra,24(sp)
    8000114a:	e822                	sd	s0,16(sp)
    8000114c:	e426                	sd	s1,8(sp)
    8000114e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001150:	00000097          	auipc	ra,0x0
    80001154:	f28080e7          	jalr	-216(ra) # 80001078 <allocproc>
    80001158:	84aa                	mv	s1,a0
  initproc = p;
    8000115a:	00008797          	auipc	a5,0x8
    8000115e:	eaa7bb23          	sd	a0,-330(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001162:	03400613          	li	a2,52
    80001166:	00008597          	auipc	a1,0x8
    8000116a:	88a58593          	addi	a1,a1,-1910 # 800089f0 <initcode>
    8000116e:	6928                	ld	a0,80(a0)
    80001170:	fffff097          	auipc	ra,0xfffff
    80001174:	6b6080e7          	jalr	1718(ra) # 80000826 <uvminit>
  p->sz = PGSIZE;
    80001178:	6785                	lui	a5,0x1
    8000117a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000117c:	6cb8                	ld	a4,88(s1)
    8000117e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001182:	6cb8                	ld	a4,88(s1)
    80001184:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001186:	4641                	li	a2,16
    80001188:	00007597          	auipc	a1,0x7
    8000118c:	ff858593          	addi	a1,a1,-8 # 80008180 <etext+0x180>
    80001190:	15848513          	addi	a0,s1,344
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	15c080e7          	jalr	348(ra) # 800002f0 <safestrcpy>
  p->cwd = namei("/");
    8000119c:	00007517          	auipc	a0,0x7
    800011a0:	ff450513          	addi	a0,a0,-12 # 80008190 <etext+0x190>
    800011a4:	00002097          	auipc	ra,0x2
    800011a8:	230080e7          	jalr	560(ra) # 800033d4 <namei>
    800011ac:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011b0:	478d                	li	a5,3
    800011b2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011b4:	8526                	mv	a0,s1
    800011b6:	00005097          	auipc	ra,0x5
    800011ba:	110080e7          	jalr	272(ra) # 800062c6 <release>
}
    800011be:	60e2                	ld	ra,24(sp)
    800011c0:	6442                	ld	s0,16(sp)
    800011c2:	64a2                	ld	s1,8(sp)
    800011c4:	6105                	addi	sp,sp,32
    800011c6:	8082                	ret

00000000800011c8 <growproc>:
{
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	e04a                	sd	s2,0(sp)
    800011d2:	1000                	addi	s0,sp,32
    800011d4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011d6:	00000097          	auipc	ra,0x0
    800011da:	c98080e7          	jalr	-872(ra) # 80000e6e <myproc>
    800011de:	892a                	mv	s2,a0
  sz = p->sz;
    800011e0:	652c                	ld	a1,72(a0)
    800011e2:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011e6:	00904f63          	bgtz	s1,80001204 <growproc+0x3c>
  } else if(n < 0){
    800011ea:	0204cc63          	bltz	s1,80001222 <growproc+0x5a>
  p->sz = sz;
    800011ee:	1602                	slli	a2,a2,0x20
    800011f0:	9201                	srli	a2,a2,0x20
    800011f2:	04c93423          	sd	a2,72(s2)
  return 0;
    800011f6:	4501                	li	a0,0
}
    800011f8:	60e2                	ld	ra,24(sp)
    800011fa:	6442                	ld	s0,16(sp)
    800011fc:	64a2                	ld	s1,8(sp)
    800011fe:	6902                	ld	s2,0(sp)
    80001200:	6105                	addi	sp,sp,32
    80001202:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001204:	9e25                	addw	a2,a2,s1
    80001206:	1602                	slli	a2,a2,0x20
    80001208:	9201                	srli	a2,a2,0x20
    8000120a:	1582                	slli	a1,a1,0x20
    8000120c:	9181                	srli	a1,a1,0x20
    8000120e:	6928                	ld	a0,80(a0)
    80001210:	fffff097          	auipc	ra,0xfffff
    80001214:	6d0080e7          	jalr	1744(ra) # 800008e0 <uvmalloc>
    80001218:	0005061b          	sext.w	a2,a0
    8000121c:	fa69                	bnez	a2,800011ee <growproc+0x26>
      return -1;
    8000121e:	557d                	li	a0,-1
    80001220:	bfe1                	j	800011f8 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001222:	9e25                	addw	a2,a2,s1
    80001224:	1602                	slli	a2,a2,0x20
    80001226:	9201                	srli	a2,a2,0x20
    80001228:	1582                	slli	a1,a1,0x20
    8000122a:	9181                	srli	a1,a1,0x20
    8000122c:	6928                	ld	a0,80(a0)
    8000122e:	fffff097          	auipc	ra,0xfffff
    80001232:	66a080e7          	jalr	1642(ra) # 80000898 <uvmdealloc>
    80001236:	0005061b          	sext.w	a2,a0
    8000123a:	bf55                	j	800011ee <growproc+0x26>

000000008000123c <fork>:
{
    8000123c:	7179                	addi	sp,sp,-48
    8000123e:	f406                	sd	ra,40(sp)
    80001240:	f022                	sd	s0,32(sp)
    80001242:	ec26                	sd	s1,24(sp)
    80001244:	e84a                	sd	s2,16(sp)
    80001246:	e44e                	sd	s3,8(sp)
    80001248:	e052                	sd	s4,0(sp)
    8000124a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	c22080e7          	jalr	-990(ra) # 80000e6e <myproc>
    80001254:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	e22080e7          	jalr	-478(ra) # 80001078 <allocproc>
    8000125e:	12050563          	beqz	a0,80001388 <fork+0x14c>
    80001262:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001264:	04893603          	ld	a2,72(s2)
    80001268:	692c                	ld	a1,80(a0)
    8000126a:	05093503          	ld	a0,80(s2)
    8000126e:	fffff097          	auipc	ra,0xfffff
    80001272:	7be080e7          	jalr	1982(ra) # 80000a2c <uvmcopy>
    80001276:	06054063          	bltz	a0,800012d6 <fork+0x9a>
  np->sz = p->sz;
    8000127a:	04893783          	ld	a5,72(s2)
    8000127e:	04f9b423          	sd	a5,72(s3)
  safestrcpy(np->mask, p->mask, sizeof(p->mask));
    80001282:	02000613          	li	a2,32
    80001286:	16890593          	addi	a1,s2,360
    8000128a:	16898513          	addi	a0,s3,360
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	062080e7          	jalr	98(ra) # 800002f0 <safestrcpy>
  *(np->trapframe) = *(p->trapframe);
    80001296:	05893683          	ld	a3,88(s2)
    8000129a:	87b6                	mv	a5,a3
    8000129c:	0589b703          	ld	a4,88(s3)
    800012a0:	12068693          	addi	a3,a3,288
    800012a4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a8:	6788                	ld	a0,8(a5)
    800012aa:	6b8c                	ld	a1,16(a5)
    800012ac:	6f90                	ld	a2,24(a5)
    800012ae:	01073023          	sd	a6,0(a4)
    800012b2:	e708                	sd	a0,8(a4)
    800012b4:	eb0c                	sd	a1,16(a4)
    800012b6:	ef10                	sd	a2,24(a4)
    800012b8:	02078793          	addi	a5,a5,32
    800012bc:	02070713          	addi	a4,a4,32
    800012c0:	fed792e3          	bne	a5,a3,800012a4 <fork+0x68>
  np->trapframe->a0 = 0;
    800012c4:	0589b783          	ld	a5,88(s3)
    800012c8:	0607b823          	sd	zero,112(a5)
    800012cc:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012d0:	15000a13          	li	s4,336
    800012d4:	a03d                	j	80001302 <fork+0xc6>
    freeproc(np);
    800012d6:	854e                	mv	a0,s3
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	d48080e7          	jalr	-696(ra) # 80001020 <freeproc>
    release(&np->lock);
    800012e0:	854e                	mv	a0,s3
    800012e2:	00005097          	auipc	ra,0x5
    800012e6:	fe4080e7          	jalr	-28(ra) # 800062c6 <release>
    return -1;
    800012ea:	5a7d                	li	s4,-1
    800012ec:	a069                	j	80001376 <fork+0x13a>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ee:	00002097          	auipc	ra,0x2
    800012f2:	77c080e7          	jalr	1916(ra) # 80003a6a <filedup>
    800012f6:	009987b3          	add	a5,s3,s1
    800012fa:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012fc:	04a1                	addi	s1,s1,8
    800012fe:	01448763          	beq	s1,s4,8000130c <fork+0xd0>
    if(p->ofile[i])
    80001302:	009907b3          	add	a5,s2,s1
    80001306:	6388                	ld	a0,0(a5)
    80001308:	f17d                	bnez	a0,800012ee <fork+0xb2>
    8000130a:	bfcd                	j	800012fc <fork+0xc0>
  np->cwd = idup(p->cwd);
    8000130c:	15093503          	ld	a0,336(s2)
    80001310:	00002097          	auipc	ra,0x2
    80001314:	8d0080e7          	jalr	-1840(ra) # 80002be0 <idup>
    80001318:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000131c:	4641                	li	a2,16
    8000131e:	15890593          	addi	a1,s2,344
    80001322:	15898513          	addi	a0,s3,344
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	fca080e7          	jalr	-54(ra) # 800002f0 <safestrcpy>
  pid = np->pid;
    8000132e:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	f92080e7          	jalr	-110(ra) # 800062c6 <release>
  acquire(&wait_lock);
    8000133c:	00008497          	auipc	s1,0x8
    80001340:	d2c48493          	addi	s1,s1,-724 # 80009068 <wait_lock>
    80001344:	8526                	mv	a0,s1
    80001346:	00005097          	auipc	ra,0x5
    8000134a:	ecc080e7          	jalr	-308(ra) # 80006212 <acquire>
  np->parent = p;
    8000134e:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001352:	8526                	mv	a0,s1
    80001354:	00005097          	auipc	ra,0x5
    80001358:	f72080e7          	jalr	-142(ra) # 800062c6 <release>
  acquire(&np->lock);
    8000135c:	854e                	mv	a0,s3
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	eb4080e7          	jalr	-332(ra) # 80006212 <acquire>
  np->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000136c:	854e                	mv	a0,s3
    8000136e:	00005097          	auipc	ra,0x5
    80001372:	f58080e7          	jalr	-168(ra) # 800062c6 <release>
}
    80001376:	8552                	mv	a0,s4
    80001378:	70a2                	ld	ra,40(sp)
    8000137a:	7402                	ld	s0,32(sp)
    8000137c:	64e2                	ld	s1,24(sp)
    8000137e:	6942                	ld	s2,16(sp)
    80001380:	69a2                	ld	s3,8(sp)
    80001382:	6a02                	ld	s4,0(sp)
    80001384:	6145                	addi	sp,sp,48
    80001386:	8082                	ret
    return -1;
    80001388:	5a7d                	li	s4,-1
    8000138a:	b7f5                	j	80001376 <fork+0x13a>

000000008000138c <scheduler>:
{
    8000138c:	7139                	addi	sp,sp,-64
    8000138e:	fc06                	sd	ra,56(sp)
    80001390:	f822                	sd	s0,48(sp)
    80001392:	f426                	sd	s1,40(sp)
    80001394:	f04a                	sd	s2,32(sp)
    80001396:	ec4e                	sd	s3,24(sp)
    80001398:	e852                	sd	s4,16(sp)
    8000139a:	e456                	sd	s5,8(sp)
    8000139c:	e05a                	sd	s6,0(sp)
    8000139e:	0080                	addi	s0,sp,64
    800013a0:	8792                	mv	a5,tp
  int id = r_tp();
    800013a2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a4:	00779a93          	slli	s5,a5,0x7
    800013a8:	00008717          	auipc	a4,0x8
    800013ac:	ca870713          	addi	a4,a4,-856 # 80009050 <pid_lock>
    800013b0:	9756                	add	a4,a4,s5
    800013b2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b6:	00008717          	auipc	a4,0x8
    800013ba:	cd270713          	addi	a4,a4,-814 # 80009088 <cpus+0x8>
    800013be:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013c0:	498d                	li	s3,3
        p->state = RUNNING;
    800013c2:	4b11                	li	s6,4
        c->proc = p;
    800013c4:	079e                	slli	a5,a5,0x7
    800013c6:	00008a17          	auipc	s4,0x8
    800013ca:	c8aa0a13          	addi	s4,s4,-886 # 80009050 <pid_lock>
    800013ce:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d0:	0000e917          	auipc	s2,0xe
    800013d4:	2b090913          	addi	s2,s2,688 # 8000f680 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013dc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013e0:	10079073          	csrw	sstatus,a5
    800013e4:	00008497          	auipc	s1,0x8
    800013e8:	09c48493          	addi	s1,s1,156 # 80009480 <proc>
    800013ec:	a03d                	j	8000141a <scheduler+0x8e>
        p->state = RUNNING;
    800013ee:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013f2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013f6:	06048593          	addi	a1,s1,96
    800013fa:	8556                	mv	a0,s5
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	694080e7          	jalr	1684(ra) # 80001a90 <swtch>
        c->proc = 0;
    80001404:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001408:	8526                	mv	a0,s1
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	ebc080e7          	jalr	-324(ra) # 800062c6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001412:	18848493          	addi	s1,s1,392
    80001416:	fd2481e3          	beq	s1,s2,800013d8 <scheduler+0x4c>
      acquire(&p->lock);
    8000141a:	8526                	mv	a0,s1
    8000141c:	00005097          	auipc	ra,0x5
    80001420:	df6080e7          	jalr	-522(ra) # 80006212 <acquire>
      if(p->state == RUNNABLE) {
    80001424:	4c9c                	lw	a5,24(s1)
    80001426:	ff3791e3          	bne	a5,s3,80001408 <scheduler+0x7c>
    8000142a:	b7d1                	j	800013ee <scheduler+0x62>

000000008000142c <sched>:
{
    8000142c:	7179                	addi	sp,sp,-48
    8000142e:	f406                	sd	ra,40(sp)
    80001430:	f022                	sd	s0,32(sp)
    80001432:	ec26                	sd	s1,24(sp)
    80001434:	e84a                	sd	s2,16(sp)
    80001436:	e44e                	sd	s3,8(sp)
    80001438:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	a34080e7          	jalr	-1484(ra) # 80000e6e <myproc>
    80001442:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001444:	00005097          	auipc	ra,0x5
    80001448:	d54080e7          	jalr	-684(ra) # 80006198 <holding>
    8000144c:	c93d                	beqz	a0,800014c2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001450:	2781                	sext.w	a5,a5
    80001452:	079e                	slli	a5,a5,0x7
    80001454:	00008717          	auipc	a4,0x8
    80001458:	bfc70713          	addi	a4,a4,-1028 # 80009050 <pid_lock>
    8000145c:	97ba                	add	a5,a5,a4
    8000145e:	0a87a703          	lw	a4,168(a5)
    80001462:	4785                	li	a5,1
    80001464:	06f71763          	bne	a4,a5,800014d2 <sched+0xa6>
  if(p->state == RUNNING)
    80001468:	4c98                	lw	a4,24(s1)
    8000146a:	4791                	li	a5,4
    8000146c:	06f70b63          	beq	a4,a5,800014e2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001470:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001474:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001476:	efb5                	bnez	a5,800014f2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001478:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000147a:	00008917          	auipc	s2,0x8
    8000147e:	bd690913          	addi	s2,s2,-1066 # 80009050 <pid_lock>
    80001482:	2781                	sext.w	a5,a5
    80001484:	079e                	slli	a5,a5,0x7
    80001486:	97ca                	add	a5,a5,s2
    80001488:	0ac7a983          	lw	s3,172(a5)
    8000148c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000148e:	2781                	sext.w	a5,a5
    80001490:	079e                	slli	a5,a5,0x7
    80001492:	00008597          	auipc	a1,0x8
    80001496:	bf658593          	addi	a1,a1,-1034 # 80009088 <cpus+0x8>
    8000149a:	95be                	add	a1,a1,a5
    8000149c:	06048513          	addi	a0,s1,96
    800014a0:	00000097          	auipc	ra,0x0
    800014a4:	5f0080e7          	jalr	1520(ra) # 80001a90 <swtch>
    800014a8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014aa:	2781                	sext.w	a5,a5
    800014ac:	079e                	slli	a5,a5,0x7
    800014ae:	97ca                	add	a5,a5,s2
    800014b0:	0b37a623          	sw	s3,172(a5)
}
    800014b4:	70a2                	ld	ra,40(sp)
    800014b6:	7402                	ld	s0,32(sp)
    800014b8:	64e2                	ld	s1,24(sp)
    800014ba:	6942                	ld	s2,16(sp)
    800014bc:	69a2                	ld	s3,8(sp)
    800014be:	6145                	addi	sp,sp,48
    800014c0:	8082                	ret
    panic("sched p->lock");
    800014c2:	00007517          	auipc	a0,0x7
    800014c6:	cd650513          	addi	a0,a0,-810 # 80008198 <etext+0x198>
    800014ca:	00004097          	auipc	ra,0x4
    800014ce:	7fe080e7          	jalr	2046(ra) # 80005cc8 <panic>
    panic("sched locks");
    800014d2:	00007517          	auipc	a0,0x7
    800014d6:	cd650513          	addi	a0,a0,-810 # 800081a8 <etext+0x1a8>
    800014da:	00004097          	auipc	ra,0x4
    800014de:	7ee080e7          	jalr	2030(ra) # 80005cc8 <panic>
    panic("sched running");
    800014e2:	00007517          	auipc	a0,0x7
    800014e6:	cd650513          	addi	a0,a0,-810 # 800081b8 <etext+0x1b8>
    800014ea:	00004097          	auipc	ra,0x4
    800014ee:	7de080e7          	jalr	2014(ra) # 80005cc8 <panic>
    panic("sched interruptible");
    800014f2:	00007517          	auipc	a0,0x7
    800014f6:	cd650513          	addi	a0,a0,-810 # 800081c8 <etext+0x1c8>
    800014fa:	00004097          	auipc	ra,0x4
    800014fe:	7ce080e7          	jalr	1998(ra) # 80005cc8 <panic>

0000000080001502 <yield>:
{
    80001502:	1101                	addi	sp,sp,-32
    80001504:	ec06                	sd	ra,24(sp)
    80001506:	e822                	sd	s0,16(sp)
    80001508:	e426                	sd	s1,8(sp)
    8000150a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	962080e7          	jalr	-1694(ra) # 80000e6e <myproc>
    80001514:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	cfc080e7          	jalr	-772(ra) # 80006212 <acquire>
  p->state = RUNNABLE;
    8000151e:	478d                	li	a5,3
    80001520:	cc9c                	sw	a5,24(s1)
  sched();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	f0a080e7          	jalr	-246(ra) # 8000142c <sched>
  release(&p->lock);
    8000152a:	8526                	mv	a0,s1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	d9a080e7          	jalr	-614(ra) # 800062c6 <release>
}
    80001534:	60e2                	ld	ra,24(sp)
    80001536:	6442                	ld	s0,16(sp)
    80001538:	64a2                	ld	s1,8(sp)
    8000153a:	6105                	addi	sp,sp,32
    8000153c:	8082                	ret

000000008000153e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000153e:	7179                	addi	sp,sp,-48
    80001540:	f406                	sd	ra,40(sp)
    80001542:	f022                	sd	s0,32(sp)
    80001544:	ec26                	sd	s1,24(sp)
    80001546:	e84a                	sd	s2,16(sp)
    80001548:	e44e                	sd	s3,8(sp)
    8000154a:	1800                	addi	s0,sp,48
    8000154c:	89aa                	mv	s3,a0
    8000154e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001550:	00000097          	auipc	ra,0x0
    80001554:	91e080e7          	jalr	-1762(ra) # 80000e6e <myproc>
    80001558:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	cb8080e7          	jalr	-840(ra) # 80006212 <acquire>
  release(lk);
    80001562:	854a                	mv	a0,s2
    80001564:	00005097          	auipc	ra,0x5
    80001568:	d62080e7          	jalr	-670(ra) # 800062c6 <release>

  // Go to sleep.
  p->chan = chan;
    8000156c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001570:	4789                	li	a5,2
    80001572:	cc9c                	sw	a5,24(s1)

  sched();
    80001574:	00000097          	auipc	ra,0x0
    80001578:	eb8080e7          	jalr	-328(ra) # 8000142c <sched>

  // Tidy up.
  p->chan = 0;
    8000157c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001580:	8526                	mv	a0,s1
    80001582:	00005097          	auipc	ra,0x5
    80001586:	d44080e7          	jalr	-700(ra) # 800062c6 <release>
  acquire(lk);
    8000158a:	854a                	mv	a0,s2
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	c86080e7          	jalr	-890(ra) # 80006212 <acquire>
}
    80001594:	70a2                	ld	ra,40(sp)
    80001596:	7402                	ld	s0,32(sp)
    80001598:	64e2                	ld	s1,24(sp)
    8000159a:	6942                	ld	s2,16(sp)
    8000159c:	69a2                	ld	s3,8(sp)
    8000159e:	6145                	addi	sp,sp,48
    800015a0:	8082                	ret

00000000800015a2 <wait>:
{
    800015a2:	715d                	addi	sp,sp,-80
    800015a4:	e486                	sd	ra,72(sp)
    800015a6:	e0a2                	sd	s0,64(sp)
    800015a8:	fc26                	sd	s1,56(sp)
    800015aa:	f84a                	sd	s2,48(sp)
    800015ac:	f44e                	sd	s3,40(sp)
    800015ae:	f052                	sd	s4,32(sp)
    800015b0:	ec56                	sd	s5,24(sp)
    800015b2:	e85a                	sd	s6,16(sp)
    800015b4:	e45e                	sd	s7,8(sp)
    800015b6:	e062                	sd	s8,0(sp)
    800015b8:	0880                	addi	s0,sp,80
    800015ba:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	8b2080e7          	jalr	-1870(ra) # 80000e6e <myproc>
    800015c4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015c6:	00008517          	auipc	a0,0x8
    800015ca:	aa250513          	addi	a0,a0,-1374 # 80009068 <wait_lock>
    800015ce:	00005097          	auipc	ra,0x5
    800015d2:	c44080e7          	jalr	-956(ra) # 80006212 <acquire>
    havekids = 0;
    800015d6:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015d8:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015da:	0000e997          	auipc	s3,0xe
    800015de:	0a698993          	addi	s3,s3,166 # 8000f680 <tickslock>
        havekids = 1;
    800015e2:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015e4:	00008c17          	auipc	s8,0x8
    800015e8:	a84c0c13          	addi	s8,s8,-1404 # 80009068 <wait_lock>
    havekids = 0;
    800015ec:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015ee:	00008497          	auipc	s1,0x8
    800015f2:	e9248493          	addi	s1,s1,-366 # 80009480 <proc>
    800015f6:	a0bd                	j	80001664 <wait+0xc2>
          pid = np->pid;
    800015f8:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015fc:	000b0e63          	beqz	s6,80001618 <wait+0x76>
    80001600:	4691                	li	a3,4
    80001602:	02c48613          	addi	a2,s1,44
    80001606:	85da                	mv	a1,s6
    80001608:	05093503          	ld	a0,80(s2)
    8000160c:	fffff097          	auipc	ra,0xfffff
    80001610:	524080e7          	jalr	1316(ra) # 80000b30 <copyout>
    80001614:	02054563          	bltz	a0,8000163e <wait+0x9c>
          freeproc(np);
    80001618:	8526                	mv	a0,s1
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	a06080e7          	jalr	-1530(ra) # 80001020 <freeproc>
          release(&np->lock);
    80001622:	8526                	mv	a0,s1
    80001624:	00005097          	auipc	ra,0x5
    80001628:	ca2080e7          	jalr	-862(ra) # 800062c6 <release>
          release(&wait_lock);
    8000162c:	00008517          	auipc	a0,0x8
    80001630:	a3c50513          	addi	a0,a0,-1476 # 80009068 <wait_lock>
    80001634:	00005097          	auipc	ra,0x5
    80001638:	c92080e7          	jalr	-878(ra) # 800062c6 <release>
          return pid;
    8000163c:	a09d                	j	800016a2 <wait+0x100>
            release(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	c86080e7          	jalr	-890(ra) # 800062c6 <release>
            release(&wait_lock);
    80001648:	00008517          	auipc	a0,0x8
    8000164c:	a2050513          	addi	a0,a0,-1504 # 80009068 <wait_lock>
    80001650:	00005097          	auipc	ra,0x5
    80001654:	c76080e7          	jalr	-906(ra) # 800062c6 <release>
            return -1;
    80001658:	59fd                	li	s3,-1
    8000165a:	a0a1                	j	800016a2 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000165c:	18848493          	addi	s1,s1,392
    80001660:	03348463          	beq	s1,s3,80001688 <wait+0xe6>
      if(np->parent == p){
    80001664:	7c9c                	ld	a5,56(s1)
    80001666:	ff279be3          	bne	a5,s2,8000165c <wait+0xba>
        acquire(&np->lock);
    8000166a:	8526                	mv	a0,s1
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	ba6080e7          	jalr	-1114(ra) # 80006212 <acquire>
        if(np->state == ZOMBIE){
    80001674:	4c9c                	lw	a5,24(s1)
    80001676:	f94781e3          	beq	a5,s4,800015f8 <wait+0x56>
        release(&np->lock);
    8000167a:	8526                	mv	a0,s1
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	c4a080e7          	jalr	-950(ra) # 800062c6 <release>
        havekids = 1;
    80001684:	8756                	mv	a4,s5
    80001686:	bfd9                	j	8000165c <wait+0xba>
    if(!havekids || p->killed){
    80001688:	c701                	beqz	a4,80001690 <wait+0xee>
    8000168a:	02892783          	lw	a5,40(s2)
    8000168e:	c79d                	beqz	a5,800016bc <wait+0x11a>
      release(&wait_lock);
    80001690:	00008517          	auipc	a0,0x8
    80001694:	9d850513          	addi	a0,a0,-1576 # 80009068 <wait_lock>
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	c2e080e7          	jalr	-978(ra) # 800062c6 <release>
      return -1;
    800016a0:	59fd                	li	s3,-1
}
    800016a2:	854e                	mv	a0,s3
    800016a4:	60a6                	ld	ra,72(sp)
    800016a6:	6406                	ld	s0,64(sp)
    800016a8:	74e2                	ld	s1,56(sp)
    800016aa:	7942                	ld	s2,48(sp)
    800016ac:	79a2                	ld	s3,40(sp)
    800016ae:	7a02                	ld	s4,32(sp)
    800016b0:	6ae2                	ld	s5,24(sp)
    800016b2:	6b42                	ld	s6,16(sp)
    800016b4:	6ba2                	ld	s7,8(sp)
    800016b6:	6c02                	ld	s8,0(sp)
    800016b8:	6161                	addi	sp,sp,80
    800016ba:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016bc:	85e2                	mv	a1,s8
    800016be:	854a                	mv	a0,s2
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	e7e080e7          	jalr	-386(ra) # 8000153e <sleep>
    havekids = 0;
    800016c8:	b715                	j	800015ec <wait+0x4a>

00000000800016ca <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ca:	7139                	addi	sp,sp,-64
    800016cc:	fc06                	sd	ra,56(sp)
    800016ce:	f822                	sd	s0,48(sp)
    800016d0:	f426                	sd	s1,40(sp)
    800016d2:	f04a                	sd	s2,32(sp)
    800016d4:	ec4e                	sd	s3,24(sp)
    800016d6:	e852                	sd	s4,16(sp)
    800016d8:	e456                	sd	s5,8(sp)
    800016da:	0080                	addi	s0,sp,64
    800016dc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016de:	00008497          	auipc	s1,0x8
    800016e2:	da248493          	addi	s1,s1,-606 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016e6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016e8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ea:	0000e917          	auipc	s2,0xe
    800016ee:	f9690913          	addi	s2,s2,-106 # 8000f680 <tickslock>
    800016f2:	a821                	j	8000170a <wakeup+0x40>
        p->state = RUNNABLE;
    800016f4:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016f8:	8526                	mv	a0,s1
    800016fa:	00005097          	auipc	ra,0x5
    800016fe:	bcc080e7          	jalr	-1076(ra) # 800062c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	18848493          	addi	s1,s1,392
    80001706:	03248463          	beq	s1,s2,8000172e <wakeup+0x64>
    if(p != myproc()){
    8000170a:	fffff097          	auipc	ra,0xfffff
    8000170e:	764080e7          	jalr	1892(ra) # 80000e6e <myproc>
    80001712:	fea488e3          	beq	s1,a0,80001702 <wakeup+0x38>
      acquire(&p->lock);
    80001716:	8526                	mv	a0,s1
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	afa080e7          	jalr	-1286(ra) # 80006212 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001720:	4c9c                	lw	a5,24(s1)
    80001722:	fd379be3          	bne	a5,s3,800016f8 <wakeup+0x2e>
    80001726:	709c                	ld	a5,32(s1)
    80001728:	fd4798e3          	bne	a5,s4,800016f8 <wakeup+0x2e>
    8000172c:	b7e1                	j	800016f4 <wakeup+0x2a>
    }
  }
}
    8000172e:	70e2                	ld	ra,56(sp)
    80001730:	7442                	ld	s0,48(sp)
    80001732:	74a2                	ld	s1,40(sp)
    80001734:	7902                	ld	s2,32(sp)
    80001736:	69e2                	ld	s3,24(sp)
    80001738:	6a42                	ld	s4,16(sp)
    8000173a:	6aa2                	ld	s5,8(sp)
    8000173c:	6121                	addi	sp,sp,64
    8000173e:	8082                	ret

0000000080001740 <reparent>:
{
    80001740:	7179                	addi	sp,sp,-48
    80001742:	f406                	sd	ra,40(sp)
    80001744:	f022                	sd	s0,32(sp)
    80001746:	ec26                	sd	s1,24(sp)
    80001748:	e84a                	sd	s2,16(sp)
    8000174a:	e44e                	sd	s3,8(sp)
    8000174c:	e052                	sd	s4,0(sp)
    8000174e:	1800                	addi	s0,sp,48
    80001750:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001752:	00008497          	auipc	s1,0x8
    80001756:	d2e48493          	addi	s1,s1,-722 # 80009480 <proc>
      pp->parent = initproc;
    8000175a:	00008a17          	auipc	s4,0x8
    8000175e:	8b6a0a13          	addi	s4,s4,-1866 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001762:	0000e997          	auipc	s3,0xe
    80001766:	f1e98993          	addi	s3,s3,-226 # 8000f680 <tickslock>
    8000176a:	a029                	j	80001774 <reparent+0x34>
    8000176c:	18848493          	addi	s1,s1,392
    80001770:	01348d63          	beq	s1,s3,8000178a <reparent+0x4a>
    if(pp->parent == p){
    80001774:	7c9c                	ld	a5,56(s1)
    80001776:	ff279be3          	bne	a5,s2,8000176c <reparent+0x2c>
      pp->parent = initproc;
    8000177a:	000a3503          	ld	a0,0(s4)
    8000177e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001780:	00000097          	auipc	ra,0x0
    80001784:	f4a080e7          	jalr	-182(ra) # 800016ca <wakeup>
    80001788:	b7d5                	j	8000176c <reparent+0x2c>
}
    8000178a:	70a2                	ld	ra,40(sp)
    8000178c:	7402                	ld	s0,32(sp)
    8000178e:	64e2                	ld	s1,24(sp)
    80001790:	6942                	ld	s2,16(sp)
    80001792:	69a2                	ld	s3,8(sp)
    80001794:	6a02                	ld	s4,0(sp)
    80001796:	6145                	addi	sp,sp,48
    80001798:	8082                	ret

000000008000179a <exit>:
{
    8000179a:	7179                	addi	sp,sp,-48
    8000179c:	f406                	sd	ra,40(sp)
    8000179e:	f022                	sd	s0,32(sp)
    800017a0:	ec26                	sd	s1,24(sp)
    800017a2:	e84a                	sd	s2,16(sp)
    800017a4:	e44e                	sd	s3,8(sp)
    800017a6:	e052                	sd	s4,0(sp)
    800017a8:	1800                	addi	s0,sp,48
    800017aa:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	6c2080e7          	jalr	1730(ra) # 80000e6e <myproc>
    800017b4:	89aa                	mv	s3,a0
  if(p == initproc)
    800017b6:	00008797          	auipc	a5,0x8
    800017ba:	85a7b783          	ld	a5,-1958(a5) # 80009010 <initproc>
    800017be:	0d050493          	addi	s1,a0,208
    800017c2:	15050913          	addi	s2,a0,336
    800017c6:	02a79363          	bne	a5,a0,800017ec <exit+0x52>
    panic("init exiting");
    800017ca:	00007517          	auipc	a0,0x7
    800017ce:	a1650513          	addi	a0,a0,-1514 # 800081e0 <etext+0x1e0>
    800017d2:	00004097          	auipc	ra,0x4
    800017d6:	4f6080e7          	jalr	1270(ra) # 80005cc8 <panic>
      fileclose(f);
    800017da:	00002097          	auipc	ra,0x2
    800017de:	2e2080e7          	jalr	738(ra) # 80003abc <fileclose>
      p->ofile[fd] = 0;
    800017e2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017e6:	04a1                	addi	s1,s1,8
    800017e8:	01248563          	beq	s1,s2,800017f2 <exit+0x58>
    if(p->ofile[fd]){
    800017ec:	6088                	ld	a0,0(s1)
    800017ee:	f575                	bnez	a0,800017da <exit+0x40>
    800017f0:	bfdd                	j	800017e6 <exit+0x4c>
  begin_op();
    800017f2:	00002097          	auipc	ra,0x2
    800017f6:	dfe080e7          	jalr	-514(ra) # 800035f0 <begin_op>
  iput(p->cwd);
    800017fa:	1509b503          	ld	a0,336(s3)
    800017fe:	00001097          	auipc	ra,0x1
    80001802:	5da080e7          	jalr	1498(ra) # 80002dd8 <iput>
  end_op();
    80001806:	00002097          	auipc	ra,0x2
    8000180a:	e6a080e7          	jalr	-406(ra) # 80003670 <end_op>
  p->cwd = 0;
    8000180e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001812:	00008497          	auipc	s1,0x8
    80001816:	85648493          	addi	s1,s1,-1962 # 80009068 <wait_lock>
    8000181a:	8526                	mv	a0,s1
    8000181c:	00005097          	auipc	ra,0x5
    80001820:	9f6080e7          	jalr	-1546(ra) # 80006212 <acquire>
  reparent(p);
    80001824:	854e                	mv	a0,s3
    80001826:	00000097          	auipc	ra,0x0
    8000182a:	f1a080e7          	jalr	-230(ra) # 80001740 <reparent>
  wakeup(p->parent);
    8000182e:	0389b503          	ld	a0,56(s3)
    80001832:	00000097          	auipc	ra,0x0
    80001836:	e98080e7          	jalr	-360(ra) # 800016ca <wakeup>
  acquire(&p->lock);
    8000183a:	854e                	mv	a0,s3
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	9d6080e7          	jalr	-1578(ra) # 80006212 <acquire>
  p->xstate = status;
    80001844:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001848:	4795                	li	a5,5
    8000184a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000184e:	8526                	mv	a0,s1
    80001850:	00005097          	auipc	ra,0x5
    80001854:	a76080e7          	jalr	-1418(ra) # 800062c6 <release>
  sched();
    80001858:	00000097          	auipc	ra,0x0
    8000185c:	bd4080e7          	jalr	-1068(ra) # 8000142c <sched>
  panic("zombie exit");
    80001860:	00007517          	auipc	a0,0x7
    80001864:	99050513          	addi	a0,a0,-1648 # 800081f0 <etext+0x1f0>
    80001868:	00004097          	auipc	ra,0x4
    8000186c:	460080e7          	jalr	1120(ra) # 80005cc8 <panic>

0000000080001870 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001870:	7179                	addi	sp,sp,-48
    80001872:	f406                	sd	ra,40(sp)
    80001874:	f022                	sd	s0,32(sp)
    80001876:	ec26                	sd	s1,24(sp)
    80001878:	e84a                	sd	s2,16(sp)
    8000187a:	e44e                	sd	s3,8(sp)
    8000187c:	1800                	addi	s0,sp,48
    8000187e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001880:	00008497          	auipc	s1,0x8
    80001884:	c0048493          	addi	s1,s1,-1024 # 80009480 <proc>
    80001888:	0000e997          	auipc	s3,0xe
    8000188c:	df898993          	addi	s3,s3,-520 # 8000f680 <tickslock>
    acquire(&p->lock);
    80001890:	8526                	mv	a0,s1
    80001892:	00005097          	auipc	ra,0x5
    80001896:	980080e7          	jalr	-1664(ra) # 80006212 <acquire>
    if(p->pid == pid){
    8000189a:	589c                	lw	a5,48(s1)
    8000189c:	01278d63          	beq	a5,s2,800018b6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018a0:	8526                	mv	a0,s1
    800018a2:	00005097          	auipc	ra,0x5
    800018a6:	a24080e7          	jalr	-1500(ra) # 800062c6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018aa:	18848493          	addi	s1,s1,392
    800018ae:	ff3491e3          	bne	s1,s3,80001890 <kill+0x20>
  }
  return -1;
    800018b2:	557d                	li	a0,-1
    800018b4:	a829                	j	800018ce <kill+0x5e>
      p->killed = 1;
    800018b6:	4785                	li	a5,1
    800018b8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018ba:	4c98                	lw	a4,24(s1)
    800018bc:	4789                	li	a5,2
    800018be:	00f70f63          	beq	a4,a5,800018dc <kill+0x6c>
      release(&p->lock);
    800018c2:	8526                	mv	a0,s1
    800018c4:	00005097          	auipc	ra,0x5
    800018c8:	a02080e7          	jalr	-1534(ra) # 800062c6 <release>
      return 0;
    800018cc:	4501                	li	a0,0
}
    800018ce:	70a2                	ld	ra,40(sp)
    800018d0:	7402                	ld	s0,32(sp)
    800018d2:	64e2                	ld	s1,24(sp)
    800018d4:	6942                	ld	s2,16(sp)
    800018d6:	69a2                	ld	s3,8(sp)
    800018d8:	6145                	addi	sp,sp,48
    800018da:	8082                	ret
        p->state = RUNNABLE;
    800018dc:	478d                	li	a5,3
    800018de:	cc9c                	sw	a5,24(s1)
    800018e0:	b7cd                	j	800018c2 <kill+0x52>

00000000800018e2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018e2:	7179                	addi	sp,sp,-48
    800018e4:	f406                	sd	ra,40(sp)
    800018e6:	f022                	sd	s0,32(sp)
    800018e8:	ec26                	sd	s1,24(sp)
    800018ea:	e84a                	sd	s2,16(sp)
    800018ec:	e44e                	sd	s3,8(sp)
    800018ee:	e052                	sd	s4,0(sp)
    800018f0:	1800                	addi	s0,sp,48
    800018f2:	84aa                	mv	s1,a0
    800018f4:	892e                	mv	s2,a1
    800018f6:	89b2                	mv	s3,a2
    800018f8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	574080e7          	jalr	1396(ra) # 80000e6e <myproc>
  if(user_dst){
    80001902:	c08d                	beqz	s1,80001924 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001904:	86d2                	mv	a3,s4
    80001906:	864e                	mv	a2,s3
    80001908:	85ca                	mv	a1,s2
    8000190a:	6928                	ld	a0,80(a0)
    8000190c:	fffff097          	auipc	ra,0xfffff
    80001910:	224080e7          	jalr	548(ra) # 80000b30 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001914:	70a2                	ld	ra,40(sp)
    80001916:	7402                	ld	s0,32(sp)
    80001918:	64e2                	ld	s1,24(sp)
    8000191a:	6942                	ld	s2,16(sp)
    8000191c:	69a2                	ld	s3,8(sp)
    8000191e:	6a02                	ld	s4,0(sp)
    80001920:	6145                	addi	sp,sp,48
    80001922:	8082                	ret
    memmove((char *)dst, src, len);
    80001924:	000a061b          	sext.w	a2,s4
    80001928:	85ce                	mv	a1,s3
    8000192a:	854a                	mv	a0,s2
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	8d2080e7          	jalr	-1838(ra) # 800001fe <memmove>
    return 0;
    80001934:	8526                	mv	a0,s1
    80001936:	bff9                	j	80001914 <either_copyout+0x32>

0000000080001938 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001938:	7179                	addi	sp,sp,-48
    8000193a:	f406                	sd	ra,40(sp)
    8000193c:	f022                	sd	s0,32(sp)
    8000193e:	ec26                	sd	s1,24(sp)
    80001940:	e84a                	sd	s2,16(sp)
    80001942:	e44e                	sd	s3,8(sp)
    80001944:	e052                	sd	s4,0(sp)
    80001946:	1800                	addi	s0,sp,48
    80001948:	892a                	mv	s2,a0
    8000194a:	84ae                	mv	s1,a1
    8000194c:	89b2                	mv	s3,a2
    8000194e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001950:	fffff097          	auipc	ra,0xfffff
    80001954:	51e080e7          	jalr	1310(ra) # 80000e6e <myproc>
  if(user_src){
    80001958:	c08d                	beqz	s1,8000197a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000195a:	86d2                	mv	a3,s4
    8000195c:	864e                	mv	a2,s3
    8000195e:	85ca                	mv	a1,s2
    80001960:	6928                	ld	a0,80(a0)
    80001962:	fffff097          	auipc	ra,0xfffff
    80001966:	25a080e7          	jalr	602(ra) # 80000bbc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000196a:	70a2                	ld	ra,40(sp)
    8000196c:	7402                	ld	s0,32(sp)
    8000196e:	64e2                	ld	s1,24(sp)
    80001970:	6942                	ld	s2,16(sp)
    80001972:	69a2                	ld	s3,8(sp)
    80001974:	6a02                	ld	s4,0(sp)
    80001976:	6145                	addi	sp,sp,48
    80001978:	8082                	ret
    memmove(dst, (char*)src, len);
    8000197a:	000a061b          	sext.w	a2,s4
    8000197e:	85ce                	mv	a1,s3
    80001980:	854a                	mv	a0,s2
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	87c080e7          	jalr	-1924(ra) # 800001fe <memmove>
    return 0;
    8000198a:	8526                	mv	a0,s1
    8000198c:	bff9                	j	8000196a <either_copyin+0x32>

000000008000198e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000198e:	715d                	addi	sp,sp,-80
    80001990:	e486                	sd	ra,72(sp)
    80001992:	e0a2                	sd	s0,64(sp)
    80001994:	fc26                	sd	s1,56(sp)
    80001996:	f84a                	sd	s2,48(sp)
    80001998:	f44e                	sd	s3,40(sp)
    8000199a:	f052                	sd	s4,32(sp)
    8000199c:	ec56                	sd	s5,24(sp)
    8000199e:	e85a                	sd	s6,16(sp)
    800019a0:	e45e                	sd	s7,8(sp)
    800019a2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019a4:	00006517          	auipc	a0,0x6
    800019a8:	6a450513          	addi	a0,a0,1700 # 80008048 <etext+0x48>
    800019ac:	00004097          	auipc	ra,0x4
    800019b0:	366080e7          	jalr	870(ra) # 80005d12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b4:	00008497          	auipc	s1,0x8
    800019b8:	c2448493          	addi	s1,s1,-988 # 800095d8 <proc+0x158>
    800019bc:	0000e917          	auipc	s2,0xe
    800019c0:	e1c90913          	addi	s2,s2,-484 # 8000f7d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019c4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019c6:	00007997          	auipc	s3,0x7
    800019ca:	83a98993          	addi	s3,s3,-1990 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ce:	00007a97          	auipc	s5,0x7
    800019d2:	83aa8a93          	addi	s5,s5,-1990 # 80008208 <etext+0x208>
    printf("\n");
    800019d6:	00006a17          	auipc	s4,0x6
    800019da:	672a0a13          	addi	s4,s4,1650 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019de:	00007b97          	auipc	s7,0x7
    800019e2:	862b8b93          	addi	s7,s7,-1950 # 80008240 <states.1715>
    800019e6:	a00d                	j	80001a08 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019e8:	ed86a583          	lw	a1,-296(a3)
    800019ec:	8556                	mv	a0,s5
    800019ee:	00004097          	auipc	ra,0x4
    800019f2:	324080e7          	jalr	804(ra) # 80005d12 <printf>
    printf("\n");
    800019f6:	8552                	mv	a0,s4
    800019f8:	00004097          	auipc	ra,0x4
    800019fc:	31a080e7          	jalr	794(ra) # 80005d12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a00:	18848493          	addi	s1,s1,392
    80001a04:	03248163          	beq	s1,s2,80001a26 <procdump+0x98>
    if(p->state == UNUSED)
    80001a08:	86a6                	mv	a3,s1
    80001a0a:	ec04a783          	lw	a5,-320(s1)
    80001a0e:	dbed                	beqz	a5,80001a00 <procdump+0x72>
      state = "???";
    80001a10:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a12:	fcfb6be3          	bltu	s6,a5,800019e8 <procdump+0x5a>
    80001a16:	1782                	slli	a5,a5,0x20
    80001a18:	9381                	srli	a5,a5,0x20
    80001a1a:	078e                	slli	a5,a5,0x3
    80001a1c:	97de                	add	a5,a5,s7
    80001a1e:	6390                	ld	a2,0(a5)
    80001a20:	f661                	bnez	a2,800019e8 <procdump+0x5a>
      state = "???";
    80001a22:	864e                	mv	a2,s3
    80001a24:	b7d1                	j	800019e8 <procdump+0x5a>
  }
}
    80001a26:	60a6                	ld	ra,72(sp)
    80001a28:	6406                	ld	s0,64(sp)
    80001a2a:	74e2                	ld	s1,56(sp)
    80001a2c:	7942                	ld	s2,48(sp)
    80001a2e:	79a2                	ld	s3,40(sp)
    80001a30:	7a02                	ld	s4,32(sp)
    80001a32:	6ae2                	ld	s5,24(sp)
    80001a34:	6b42                	ld	s6,16(sp)
    80001a36:	6ba2                	ld	s7,8(sp)
    80001a38:	6161                	addi	sp,sp,80
    80001a3a:	8082                	ret

0000000080001a3c <get_nproc>:

uint64
get_nproc(void)
{
    80001a3c:	7179                	addi	sp,sp,-48
    80001a3e:	f406                	sd	ra,40(sp)
    80001a40:	f022                	sd	s0,32(sp)
    80001a42:	ec26                	sd	s1,24(sp)
    80001a44:	e84a                	sd	s2,16(sp)
    80001a46:	e44e                	sd	s3,8(sp)
    80001a48:	1800                	addi	s0,sp,48
  struct proc *p;
  uint64 num =0;
    80001a4a:	4901                	li	s2,0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a4c:	00008497          	auipc	s1,0x8
    80001a50:	a3448493          	addi	s1,s1,-1484 # 80009480 <proc>
    80001a54:	0000e997          	auipc	s3,0xe
    80001a58:	c2c98993          	addi	s3,s3,-980 # 8000f680 <tickslock>
    acquire(&p->lock);
    80001a5c:	8526                	mv	a0,s1
    80001a5e:	00004097          	auipc	ra,0x4
    80001a62:	7b4080e7          	jalr	1972(ra) # 80006212 <acquire>

    if(p->state != UNUSED)
    80001a66:	4c9c                	lw	a5,24(s1)
      num++;
    80001a68:	00f037b3          	snez	a5,a5
    80001a6c:	993e                	add	s2,s2,a5

    release(&p->lock);
    80001a6e:	8526                	mv	a0,s1
    80001a70:	00005097          	auipc	ra,0x5
    80001a74:	856080e7          	jalr	-1962(ra) # 800062c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a78:	18848493          	addi	s1,s1,392
    80001a7c:	ff3490e3          	bne	s1,s3,80001a5c <get_nproc+0x20>
  }
  return num;
}
    80001a80:	854a                	mv	a0,s2
    80001a82:	70a2                	ld	ra,40(sp)
    80001a84:	7402                	ld	s0,32(sp)
    80001a86:	64e2                	ld	s1,24(sp)
    80001a88:	6942                	ld	s2,16(sp)
    80001a8a:	69a2                	ld	s3,8(sp)
    80001a8c:	6145                	addi	sp,sp,48
    80001a8e:	8082                	ret

0000000080001a90 <swtch>:
    80001a90:	00153023          	sd	ra,0(a0)
    80001a94:	00253423          	sd	sp,8(a0)
    80001a98:	e900                	sd	s0,16(a0)
    80001a9a:	ed04                	sd	s1,24(a0)
    80001a9c:	03253023          	sd	s2,32(a0)
    80001aa0:	03353423          	sd	s3,40(a0)
    80001aa4:	03453823          	sd	s4,48(a0)
    80001aa8:	03553c23          	sd	s5,56(a0)
    80001aac:	05653023          	sd	s6,64(a0)
    80001ab0:	05753423          	sd	s7,72(a0)
    80001ab4:	05853823          	sd	s8,80(a0)
    80001ab8:	05953c23          	sd	s9,88(a0)
    80001abc:	07a53023          	sd	s10,96(a0)
    80001ac0:	07b53423          	sd	s11,104(a0)
    80001ac4:	0005b083          	ld	ra,0(a1)
    80001ac8:	0085b103          	ld	sp,8(a1)
    80001acc:	6980                	ld	s0,16(a1)
    80001ace:	6d84                	ld	s1,24(a1)
    80001ad0:	0205b903          	ld	s2,32(a1)
    80001ad4:	0285b983          	ld	s3,40(a1)
    80001ad8:	0305ba03          	ld	s4,48(a1)
    80001adc:	0385ba83          	ld	s5,56(a1)
    80001ae0:	0405bb03          	ld	s6,64(a1)
    80001ae4:	0485bb83          	ld	s7,72(a1)
    80001ae8:	0505bc03          	ld	s8,80(a1)
    80001aec:	0585bc83          	ld	s9,88(a1)
    80001af0:	0605bd03          	ld	s10,96(a1)
    80001af4:	0685bd83          	ld	s11,104(a1)
    80001af8:	8082                	ret

0000000080001afa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001afa:	1141                	addi	sp,sp,-16
    80001afc:	e406                	sd	ra,8(sp)
    80001afe:	e022                	sd	s0,0(sp)
    80001b00:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b02:	00006597          	auipc	a1,0x6
    80001b06:	76e58593          	addi	a1,a1,1902 # 80008270 <states.1715+0x30>
    80001b0a:	0000e517          	auipc	a0,0xe
    80001b0e:	b7650513          	addi	a0,a0,-1162 # 8000f680 <tickslock>
    80001b12:	00004097          	auipc	ra,0x4
    80001b16:	670080e7          	jalr	1648(ra) # 80006182 <initlock>
}
    80001b1a:	60a2                	ld	ra,8(sp)
    80001b1c:	6402                	ld	s0,0(sp)
    80001b1e:	0141                	addi	sp,sp,16
    80001b20:	8082                	ret

0000000080001b22 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b22:	1141                	addi	sp,sp,-16
    80001b24:	e422                	sd	s0,8(sp)
    80001b26:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b28:	00003797          	auipc	a5,0x3
    80001b2c:	5a878793          	addi	a5,a5,1448 # 800050d0 <kernelvec>
    80001b30:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b34:	6422                	ld	s0,8(sp)
    80001b36:	0141                	addi	sp,sp,16
    80001b38:	8082                	ret

0000000080001b3a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b3a:	1141                	addi	sp,sp,-16
    80001b3c:	e406                	sd	ra,8(sp)
    80001b3e:	e022                	sd	s0,0(sp)
    80001b40:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b42:	fffff097          	auipc	ra,0xfffff
    80001b46:	32c080e7          	jalr	812(ra) # 80000e6e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b4e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b50:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b54:	00005617          	auipc	a2,0x5
    80001b58:	4ac60613          	addi	a2,a2,1196 # 80007000 <_trampoline>
    80001b5c:	00005697          	auipc	a3,0x5
    80001b60:	4a468693          	addi	a3,a3,1188 # 80007000 <_trampoline>
    80001b64:	8e91                	sub	a3,a3,a2
    80001b66:	040007b7          	lui	a5,0x4000
    80001b6a:	17fd                	addi	a5,a5,-1
    80001b6c:	07b2                	slli	a5,a5,0xc
    80001b6e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b70:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b74:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b76:	180026f3          	csrr	a3,satp
    80001b7a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b7c:	6d38                	ld	a4,88(a0)
    80001b7e:	6134                	ld	a3,64(a0)
    80001b80:	6585                	lui	a1,0x1
    80001b82:	96ae                	add	a3,a3,a1
    80001b84:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b86:	6d38                	ld	a4,88(a0)
    80001b88:	00000697          	auipc	a3,0x0
    80001b8c:	13868693          	addi	a3,a3,312 # 80001cc0 <usertrap>
    80001b90:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b92:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b94:	8692                	mv	a3,tp
    80001b96:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b98:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b9c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ba0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ba8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001baa:	6f18                	ld	a4,24(a4)
    80001bac:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bb0:	692c                	ld	a1,80(a0)
    80001bb2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bb4:	00005717          	auipc	a4,0x5
    80001bb8:	4dc70713          	addi	a4,a4,1244 # 80007090 <userret>
    80001bbc:	8f11                	sub	a4,a4,a2
    80001bbe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bc0:	577d                	li	a4,-1
    80001bc2:	177e                	slli	a4,a4,0x3f
    80001bc4:	8dd9                	or	a1,a1,a4
    80001bc6:	02000537          	lui	a0,0x2000
    80001bca:	157d                	addi	a0,a0,-1
    80001bcc:	0536                	slli	a0,a0,0xd
    80001bce:	9782                	jalr	a5
}
    80001bd0:	60a2                	ld	ra,8(sp)
    80001bd2:	6402                	ld	s0,0(sp)
    80001bd4:	0141                	addi	sp,sp,16
    80001bd6:	8082                	ret

0000000080001bd8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bd8:	1101                	addi	sp,sp,-32
    80001bda:	ec06                	sd	ra,24(sp)
    80001bdc:	e822                	sd	s0,16(sp)
    80001bde:	e426                	sd	s1,8(sp)
    80001be0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001be2:	0000e497          	auipc	s1,0xe
    80001be6:	a9e48493          	addi	s1,s1,-1378 # 8000f680 <tickslock>
    80001bea:	8526                	mv	a0,s1
    80001bec:	00004097          	auipc	ra,0x4
    80001bf0:	626080e7          	jalr	1574(ra) # 80006212 <acquire>
  ticks++;
    80001bf4:	00007517          	auipc	a0,0x7
    80001bf8:	42450513          	addi	a0,a0,1060 # 80009018 <ticks>
    80001bfc:	411c                	lw	a5,0(a0)
    80001bfe:	2785                	addiw	a5,a5,1
    80001c00:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c02:	00000097          	auipc	ra,0x0
    80001c06:	ac8080e7          	jalr	-1336(ra) # 800016ca <wakeup>
  release(&tickslock);
    80001c0a:	8526                	mv	a0,s1
    80001c0c:	00004097          	auipc	ra,0x4
    80001c10:	6ba080e7          	jalr	1722(ra) # 800062c6 <release>
}
    80001c14:	60e2                	ld	ra,24(sp)
    80001c16:	6442                	ld	s0,16(sp)
    80001c18:	64a2                	ld	s1,8(sp)
    80001c1a:	6105                	addi	sp,sp,32
    80001c1c:	8082                	ret

0000000080001c1e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c1e:	1101                	addi	sp,sp,-32
    80001c20:	ec06                	sd	ra,24(sp)
    80001c22:	e822                	sd	s0,16(sp)
    80001c24:	e426                	sd	s1,8(sp)
    80001c26:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c28:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c2c:	00074d63          	bltz	a4,80001c46 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c30:	57fd                	li	a5,-1
    80001c32:	17fe                	slli	a5,a5,0x3f
    80001c34:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c36:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c38:	06f70363          	beq	a4,a5,80001c9e <devintr+0x80>
  }
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6105                	addi	sp,sp,32
    80001c44:	8082                	ret
     (scause & 0xff) == 9){
    80001c46:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c4a:	46a5                	li	a3,9
    80001c4c:	fed792e3          	bne	a5,a3,80001c30 <devintr+0x12>
    int irq = plic_claim();
    80001c50:	00003097          	auipc	ra,0x3
    80001c54:	588080e7          	jalr	1416(ra) # 800051d8 <plic_claim>
    80001c58:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c5a:	47a9                	li	a5,10
    80001c5c:	02f50763          	beq	a0,a5,80001c8a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c60:	4785                	li	a5,1
    80001c62:	02f50963          	beq	a0,a5,80001c94 <devintr+0x76>
    return 1;
    80001c66:	4505                	li	a0,1
    } else if(irq){
    80001c68:	d8f1                	beqz	s1,80001c3c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c6a:	85a6                	mv	a1,s1
    80001c6c:	00006517          	auipc	a0,0x6
    80001c70:	60c50513          	addi	a0,a0,1548 # 80008278 <states.1715+0x38>
    80001c74:	00004097          	auipc	ra,0x4
    80001c78:	09e080e7          	jalr	158(ra) # 80005d12 <printf>
      plic_complete(irq);
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	00003097          	auipc	ra,0x3
    80001c82:	57e080e7          	jalr	1406(ra) # 800051fc <plic_complete>
    return 1;
    80001c86:	4505                	li	a0,1
    80001c88:	bf55                	j	80001c3c <devintr+0x1e>
      uartintr();
    80001c8a:	00004097          	auipc	ra,0x4
    80001c8e:	4a8080e7          	jalr	1192(ra) # 80006132 <uartintr>
    80001c92:	b7ed                	j	80001c7c <devintr+0x5e>
      virtio_disk_intr();
    80001c94:	00004097          	auipc	ra,0x4
    80001c98:	a48080e7          	jalr	-1464(ra) # 800056dc <virtio_disk_intr>
    80001c9c:	b7c5                	j	80001c7c <devintr+0x5e>
    if(cpuid() == 0){
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	1a4080e7          	jalr	420(ra) # 80000e42 <cpuid>
    80001ca6:	c901                	beqz	a0,80001cb6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ca8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cae:	14479073          	csrw	sip,a5
    return 2;
    80001cb2:	4509                	li	a0,2
    80001cb4:	b761                	j	80001c3c <devintr+0x1e>
      clockintr();
    80001cb6:	00000097          	auipc	ra,0x0
    80001cba:	f22080e7          	jalr	-222(ra) # 80001bd8 <clockintr>
    80001cbe:	b7ed                	j	80001ca8 <devintr+0x8a>

0000000080001cc0 <usertrap>:
{
    80001cc0:	1101                	addi	sp,sp,-32
    80001cc2:	ec06                	sd	ra,24(sp)
    80001cc4:	e822                	sd	s0,16(sp)
    80001cc6:	e426                	sd	s1,8(sp)
    80001cc8:	e04a                	sd	s2,0(sp)
    80001cca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ccc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cd0:	1007f793          	andi	a5,a5,256
    80001cd4:	e3ad                	bnez	a5,80001d36 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cd6:	00003797          	auipc	a5,0x3
    80001cda:	3fa78793          	addi	a5,a5,1018 # 800050d0 <kernelvec>
    80001cde:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ce2:	fffff097          	auipc	ra,0xfffff
    80001ce6:	18c080e7          	jalr	396(ra) # 80000e6e <myproc>
    80001cea:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cec:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cee:	14102773          	csrr	a4,sepc
    80001cf2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cf4:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cf8:	47a1                	li	a5,8
    80001cfa:	04f71c63          	bne	a4,a5,80001d52 <usertrap+0x92>
    if(p->killed)
    80001cfe:	551c                	lw	a5,40(a0)
    80001d00:	e3b9                	bnez	a5,80001d46 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d02:	6cb8                	ld	a4,88(s1)
    80001d04:	6f1c                	ld	a5,24(a4)
    80001d06:	0791                	addi	a5,a5,4
    80001d08:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d0e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d12:	10079073          	csrw	sstatus,a5
    syscall();
    80001d16:	00000097          	auipc	ra,0x0
    80001d1a:	2e0080e7          	jalr	736(ra) # 80001ff6 <syscall>
  if(p->killed)
    80001d1e:	549c                	lw	a5,40(s1)
    80001d20:	ebc1                	bnez	a5,80001db0 <usertrap+0xf0>
  usertrapret();
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	e18080e7          	jalr	-488(ra) # 80001b3a <usertrapret>
}
    80001d2a:	60e2                	ld	ra,24(sp)
    80001d2c:	6442                	ld	s0,16(sp)
    80001d2e:	64a2                	ld	s1,8(sp)
    80001d30:	6902                	ld	s2,0(sp)
    80001d32:	6105                	addi	sp,sp,32
    80001d34:	8082                	ret
    panic("usertrap: not from user mode");
    80001d36:	00006517          	auipc	a0,0x6
    80001d3a:	56250513          	addi	a0,a0,1378 # 80008298 <states.1715+0x58>
    80001d3e:	00004097          	auipc	ra,0x4
    80001d42:	f8a080e7          	jalr	-118(ra) # 80005cc8 <panic>
      exit(-1);
    80001d46:	557d                	li	a0,-1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	a52080e7          	jalr	-1454(ra) # 8000179a <exit>
    80001d50:	bf4d                	j	80001d02 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	ecc080e7          	jalr	-308(ra) # 80001c1e <devintr>
    80001d5a:	892a                	mv	s2,a0
    80001d5c:	c501                	beqz	a0,80001d64 <usertrap+0xa4>
  if(p->killed)
    80001d5e:	549c                	lw	a5,40(s1)
    80001d60:	c3a1                	beqz	a5,80001da0 <usertrap+0xe0>
    80001d62:	a815                	j	80001d96 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d64:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d68:	5890                	lw	a2,48(s1)
    80001d6a:	00006517          	auipc	a0,0x6
    80001d6e:	54e50513          	addi	a0,a0,1358 # 800082b8 <states.1715+0x78>
    80001d72:	00004097          	auipc	ra,0x4
    80001d76:	fa0080e7          	jalr	-96(ra) # 80005d12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d7e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	56650513          	addi	a0,a0,1382 # 800082e8 <states.1715+0xa8>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	f88080e7          	jalr	-120(ra) # 80005d12 <printf>
    p->killed = 1;
    80001d92:	4785                	li	a5,1
    80001d94:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d96:	557d                	li	a0,-1
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	a02080e7          	jalr	-1534(ra) # 8000179a <exit>
  if(which_dev == 2)
    80001da0:	4789                	li	a5,2
    80001da2:	f8f910e3          	bne	s2,a5,80001d22 <usertrap+0x62>
    yield();
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	75c080e7          	jalr	1884(ra) # 80001502 <yield>
    80001dae:	bf95                	j	80001d22 <usertrap+0x62>
  int which_dev = 0;
    80001db0:	4901                	li	s2,0
    80001db2:	b7d5                	j	80001d96 <usertrap+0xd6>

0000000080001db4 <kerneltrap>:
{
    80001db4:	7179                	addi	sp,sp,-48
    80001db6:	f406                	sd	ra,40(sp)
    80001db8:	f022                	sd	s0,32(sp)
    80001dba:	ec26                	sd	s1,24(sp)
    80001dbc:	e84a                	sd	s2,16(sp)
    80001dbe:	e44e                	sd	s3,8(sp)
    80001dc0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dca:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dce:	1004f793          	andi	a5,s1,256
    80001dd2:	cb85                	beqz	a5,80001e02 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dda:	ef85                	bnez	a5,80001e12 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	e42080e7          	jalr	-446(ra) # 80001c1e <devintr>
    80001de4:	cd1d                	beqz	a0,80001e22 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001de6:	4789                	li	a5,2
    80001de8:	06f50a63          	beq	a0,a5,80001e5c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dec:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001df0:	10049073          	csrw	sstatus,s1
}
    80001df4:	70a2                	ld	ra,40(sp)
    80001df6:	7402                	ld	s0,32(sp)
    80001df8:	64e2                	ld	s1,24(sp)
    80001dfa:	6942                	ld	s2,16(sp)
    80001dfc:	69a2                	ld	s3,8(sp)
    80001dfe:	6145                	addi	sp,sp,48
    80001e00:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e02:	00006517          	auipc	a0,0x6
    80001e06:	50650513          	addi	a0,a0,1286 # 80008308 <states.1715+0xc8>
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	ebe080e7          	jalr	-322(ra) # 80005cc8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	51e50513          	addi	a0,a0,1310 # 80008330 <states.1715+0xf0>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	eae080e7          	jalr	-338(ra) # 80005cc8 <panic>
    printf("scause %p\n", scause);
    80001e22:	85ce                	mv	a1,s3
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	52c50513          	addi	a0,a0,1324 # 80008350 <states.1715+0x110>
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	ee6080e7          	jalr	-282(ra) # 80005d12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e38:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	52450513          	addi	a0,a0,1316 # 80008360 <states.1715+0x120>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	ece080e7          	jalr	-306(ra) # 80005d12 <printf>
    panic("kerneltrap");
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	52c50513          	addi	a0,a0,1324 # 80008378 <states.1715+0x138>
    80001e54:	00004097          	auipc	ra,0x4
    80001e58:	e74080e7          	jalr	-396(ra) # 80005cc8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	012080e7          	jalr	18(ra) # 80000e6e <myproc>
    80001e64:	d541                	beqz	a0,80001dec <kerneltrap+0x38>
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	008080e7          	jalr	8(ra) # 80000e6e <myproc>
    80001e6e:	4d18                	lw	a4,24(a0)
    80001e70:	4791                	li	a5,4
    80001e72:	f6f71de3          	bne	a4,a5,80001dec <kerneltrap+0x38>
    yield();
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	68c080e7          	jalr	1676(ra) # 80001502 <yield>
    80001e7e:	b7bd                	j	80001dec <kerneltrap+0x38>

0000000080001e80 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e80:	1101                	addi	sp,sp,-32
    80001e82:	ec06                	sd	ra,24(sp)
    80001e84:	e822                	sd	s0,16(sp)
    80001e86:	e426                	sd	s1,8(sp)
    80001e88:	1000                	addi	s0,sp,32
    80001e8a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	fe2080e7          	jalr	-30(ra) # 80000e6e <myproc>
  switch (n) {
    80001e94:	4795                	li	a5,5
    80001e96:	0497e163          	bltu	a5,s1,80001ed8 <argraw+0x58>
    80001e9a:	048a                	slli	s1,s1,0x2
    80001e9c:	00006717          	auipc	a4,0x6
    80001ea0:	5dc70713          	addi	a4,a4,1500 # 80008478 <states.1715+0x238>
    80001ea4:	94ba                	add	s1,s1,a4
    80001ea6:	409c                	lw	a5,0(s1)
    80001ea8:	97ba                	add	a5,a5,a4
    80001eaa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eb0:	60e2                	ld	ra,24(sp)
    80001eb2:	6442                	ld	s0,16(sp)
    80001eb4:	64a2                	ld	s1,8(sp)
    80001eb6:	6105                	addi	sp,sp,32
    80001eb8:	8082                	ret
    return p->trapframe->a1;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	7fa8                	ld	a0,120(a5)
    80001ebe:	bfcd                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a2;
    80001ec0:	6d3c                	ld	a5,88(a0)
    80001ec2:	63c8                	ld	a0,128(a5)
    80001ec4:	b7f5                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a3;
    80001ec6:	6d3c                	ld	a5,88(a0)
    80001ec8:	67c8                	ld	a0,136(a5)
    80001eca:	b7dd                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a4;
    80001ecc:	6d3c                	ld	a5,88(a0)
    80001ece:	6bc8                	ld	a0,144(a5)
    80001ed0:	b7c5                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a5;
    80001ed2:	6d3c                	ld	a5,88(a0)
    80001ed4:	6fc8                	ld	a0,152(a5)
    80001ed6:	bfe9                	j	80001eb0 <argraw+0x30>
  panic("argraw");
    80001ed8:	00006517          	auipc	a0,0x6
    80001edc:	4b050513          	addi	a0,a0,1200 # 80008388 <states.1715+0x148>
    80001ee0:	00004097          	auipc	ra,0x4
    80001ee4:	de8080e7          	jalr	-536(ra) # 80005cc8 <panic>

0000000080001ee8 <fetchaddr>:
{
    80001ee8:	1101                	addi	sp,sp,-32
    80001eea:	ec06                	sd	ra,24(sp)
    80001eec:	e822                	sd	s0,16(sp)
    80001eee:	e426                	sd	s1,8(sp)
    80001ef0:	e04a                	sd	s2,0(sp)
    80001ef2:	1000                	addi	s0,sp,32
    80001ef4:	84aa                	mv	s1,a0
    80001ef6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	f76080e7          	jalr	-138(ra) # 80000e6e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f00:	653c                	ld	a5,72(a0)
    80001f02:	02f4f863          	bgeu	s1,a5,80001f32 <fetchaddr+0x4a>
    80001f06:	00848713          	addi	a4,s1,8
    80001f0a:	02e7e663          	bltu	a5,a4,80001f36 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f0e:	46a1                	li	a3,8
    80001f10:	8626                	mv	a2,s1
    80001f12:	85ca                	mv	a1,s2
    80001f14:	6928                	ld	a0,80(a0)
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	ca6080e7          	jalr	-858(ra) # 80000bbc <copyin>
    80001f1e:	00a03533          	snez	a0,a0
    80001f22:	40a00533          	neg	a0,a0
}
    80001f26:	60e2                	ld	ra,24(sp)
    80001f28:	6442                	ld	s0,16(sp)
    80001f2a:	64a2                	ld	s1,8(sp)
    80001f2c:	6902                	ld	s2,0(sp)
    80001f2e:	6105                	addi	sp,sp,32
    80001f30:	8082                	ret
    return -1;
    80001f32:	557d                	li	a0,-1
    80001f34:	bfcd                	j	80001f26 <fetchaddr+0x3e>
    80001f36:	557d                	li	a0,-1
    80001f38:	b7fd                	j	80001f26 <fetchaddr+0x3e>

0000000080001f3a <fetchstr>:
{
    80001f3a:	7179                	addi	sp,sp,-48
    80001f3c:	f406                	sd	ra,40(sp)
    80001f3e:	f022                	sd	s0,32(sp)
    80001f40:	ec26                	sd	s1,24(sp)
    80001f42:	e84a                	sd	s2,16(sp)
    80001f44:	e44e                	sd	s3,8(sp)
    80001f46:	1800                	addi	s0,sp,48
    80001f48:	892a                	mv	s2,a0
    80001f4a:	84ae                	mv	s1,a1
    80001f4c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	f20080e7          	jalr	-224(ra) # 80000e6e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f56:	86ce                	mv	a3,s3
    80001f58:	864a                	mv	a2,s2
    80001f5a:	85a6                	mv	a1,s1
    80001f5c:	6928                	ld	a0,80(a0)
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	cea080e7          	jalr	-790(ra) # 80000c48 <copyinstr>
  if(err < 0)
    80001f66:	00054763          	bltz	a0,80001f74 <fetchstr+0x3a>
  return strlen(buf);
    80001f6a:	8526                	mv	a0,s1
    80001f6c:	ffffe097          	auipc	ra,0xffffe
    80001f70:	3b6080e7          	jalr	950(ra) # 80000322 <strlen>
}
    80001f74:	70a2                	ld	ra,40(sp)
    80001f76:	7402                	ld	s0,32(sp)
    80001f78:	64e2                	ld	s1,24(sp)
    80001f7a:	6942                	ld	s2,16(sp)
    80001f7c:	69a2                	ld	s3,8(sp)
    80001f7e:	6145                	addi	sp,sp,48
    80001f80:	8082                	ret

0000000080001f82 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f82:	1101                	addi	sp,sp,-32
    80001f84:	ec06                	sd	ra,24(sp)
    80001f86:	e822                	sd	s0,16(sp)
    80001f88:	e426                	sd	s1,8(sp)
    80001f8a:	1000                	addi	s0,sp,32
    80001f8c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	ef2080e7          	jalr	-270(ra) # 80001e80 <argraw>
    80001f96:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f98:	4501                	li	a0,0
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6105                	addi	sp,sp,32
    80001fa2:	8082                	ret

0000000080001fa4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fa4:	1101                	addi	sp,sp,-32
    80001fa6:	ec06                	sd	ra,24(sp)
    80001fa8:	e822                	sd	s0,16(sp)
    80001faa:	e426                	sd	s1,8(sp)
    80001fac:	1000                	addi	s0,sp,32
    80001fae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	ed0080e7          	jalr	-304(ra) # 80001e80 <argraw>
    80001fb8:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fba:	4501                	li	a0,0
    80001fbc:	60e2                	ld	ra,24(sp)
    80001fbe:	6442                	ld	s0,16(sp)
    80001fc0:	64a2                	ld	s1,8(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret

0000000080001fc6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	e04a                	sd	s2,0(sp)
    80001fd0:	1000                	addi	s0,sp,32
    80001fd2:	84ae                	mv	s1,a1
    80001fd4:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	eaa080e7          	jalr	-342(ra) # 80001e80 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fde:	864a                	mv	a2,s2
    80001fe0:	85a6                	mv	a1,s1
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	f58080e7          	jalr	-168(ra) # 80001f3a <fetchstr>
}
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6902                	ld	s2,0(sp)
    80001ff2:	6105                	addi	sp,sp,32
    80001ff4:	8082                	ret

0000000080001ff6 <syscall>:
                          "dup", "getpid", "sbrk", "sleep", "uptime", "open",
                          "write", "mknod", "unlink", "link", "mkdir",
                          "close", "trace", "sysinfo"};
void
syscall(void)
{
    80001ff6:	7179                	addi	sp,sp,-48
    80001ff8:	f406                	sd	ra,40(sp)
    80001ffa:	f022                	sd	s0,32(sp)
    80001ffc:	ec26                	sd	s1,24(sp)
    80001ffe:	e84a                	sd	s2,16(sp)
    80002000:	e44e                	sd	s3,8(sp)
    80002002:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	e6a080e7          	jalr	-406(ra) # 80000e6e <myproc>
    8000200c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000200e:	05853903          	ld	s2,88(a0)
    80002012:	0a893783          	ld	a5,168(s2)
    80002016:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000201a:	37fd                	addiw	a5,a5,-1
    8000201c:	4759                	li	a4,22
    8000201e:	06f76263          	bltu	a4,a5,80002082 <syscall+0x8c>
    80002022:	00399713          	slli	a4,s3,0x3
    80002026:	00006797          	auipc	a5,0x6
    8000202a:	46a78793          	addi	a5,a5,1130 # 80008490 <syscalls>
    8000202e:	97ba                	add	a5,a5,a4
    80002030:	639c                	ld	a5,0(a5)
    80002032:	cba1                	beqz	a5,80002082 <syscall+0x8c>
    p->trapframe->a0 = syscalls[num]();
    80002034:	9782                	jalr	a5
    80002036:	06a93823          	sd	a0,112(s2)
    if( strlen(p->mask) > 0 && p->mask[num] == '1'){
    8000203a:	16848513          	addi	a0,s1,360
    8000203e:	ffffe097          	auipc	ra,0xffffe
    80002042:	2e4080e7          	jalr	740(ra) # 80000322 <strlen>
    80002046:	04a05d63          	blez	a0,800020a0 <syscall+0xaa>
    8000204a:	013487b3          	add	a5,s1,s3
    8000204e:	1687c703          	lbu	a4,360(a5)
    80002052:	03100793          	li	a5,49
    80002056:	04f71563          	bne	a4,a5,800020a0 <syscall+0xaa>
      printf("%d: syscall %s -> %d\n",  
    8000205a:	6cb8                	ld	a4,88(s1)
    8000205c:	098e                	slli	s3,s3,0x3
    8000205e:	00006797          	auipc	a5,0x6
    80002062:	43278793          	addi	a5,a5,1074 # 80008490 <syscalls>
    80002066:	99be                	add	s3,s3,a5
    80002068:	7b34                	ld	a3,112(a4)
    8000206a:	0c09b603          	ld	a2,192(s3)
    8000206e:	588c                	lw	a1,48(s1)
    80002070:	00006517          	auipc	a0,0x6
    80002074:	32050513          	addi	a0,a0,800 # 80008390 <states.1715+0x150>
    80002078:	00004097          	auipc	ra,0x4
    8000207c:	c9a080e7          	jalr	-870(ra) # 80005d12 <printf>
    80002080:	a005                	j	800020a0 <syscall+0xaa>
                p->pid, syscall_name[num], p->trapframe->a0);
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002082:	86ce                	mv	a3,s3
    80002084:	15848613          	addi	a2,s1,344
    80002088:	588c                	lw	a1,48(s1)
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	31e50513          	addi	a0,a0,798 # 800083a8 <states.1715+0x168>
    80002092:	00004097          	auipc	ra,0x4
    80002096:	c80080e7          	jalr	-896(ra) # 80005d12 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000209a:	6cbc                	ld	a5,88(s1)
    8000209c:	577d                	li	a4,-1
    8000209e:	fbb8                	sd	a4,112(a5)
  }
}
    800020a0:	70a2                	ld	ra,40(sp)
    800020a2:	7402                	ld	s0,32(sp)
    800020a4:	64e2                	ld	s1,24(sp)
    800020a6:	6942                	ld	s2,16(sp)
    800020a8:	69a2                	ld	s3,8(sp)
    800020aa:	6145                	addi	sp,sp,48
    800020ac:	8082                	ret

00000000800020ae <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020b6:	fec40593          	addi	a1,s0,-20
    800020ba:	4501                	li	a0,0
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	ec6080e7          	jalr	-314(ra) # 80001f82 <argint>
    return -1;
    800020c4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020c6:	00054963          	bltz	a0,800020d8 <sys_exit+0x2a>
  exit(n);
    800020ca:	fec42503          	lw	a0,-20(s0)
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	6cc080e7          	jalr	1740(ra) # 8000179a <exit>
  return 0;  // not reached
    800020d6:	4781                	li	a5,0
}
    800020d8:	853e                	mv	a0,a5
    800020da:	60e2                	ld	ra,24(sp)
    800020dc:	6442                	ld	s0,16(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e2:	1141                	addi	sp,sp,-16
    800020e4:	e406                	sd	ra,8(sp)
    800020e6:	e022                	sd	s0,0(sp)
    800020e8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	d84080e7          	jalr	-636(ra) # 80000e6e <myproc>
}
    800020f2:	5908                	lw	a0,48(a0)
    800020f4:	60a2                	ld	ra,8(sp)
    800020f6:	6402                	ld	s0,0(sp)
    800020f8:	0141                	addi	sp,sp,16
    800020fa:	8082                	ret

00000000800020fc <sys_fork>:

uint64
sys_fork(void)
{
    800020fc:	1141                	addi	sp,sp,-16
    800020fe:	e406                	sd	ra,8(sp)
    80002100:	e022                	sd	s0,0(sp)
    80002102:	0800                	addi	s0,sp,16
  return fork();
    80002104:	fffff097          	auipc	ra,0xfffff
    80002108:	138080e7          	jalr	312(ra) # 8000123c <fork>
}
    8000210c:	60a2                	ld	ra,8(sp)
    8000210e:	6402                	ld	s0,0(sp)
    80002110:	0141                	addi	sp,sp,16
    80002112:	8082                	ret

0000000080002114 <sys_wait>:

uint64
sys_wait(void)
{
    80002114:	1101                	addi	sp,sp,-32
    80002116:	ec06                	sd	ra,24(sp)
    80002118:	e822                	sd	s0,16(sp)
    8000211a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000211c:	fe840593          	addi	a1,s0,-24
    80002120:	4501                	li	a0,0
    80002122:	00000097          	auipc	ra,0x0
    80002126:	e82080e7          	jalr	-382(ra) # 80001fa4 <argaddr>
    8000212a:	87aa                	mv	a5,a0
    return -1;
    8000212c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000212e:	0007c863          	bltz	a5,8000213e <sys_wait+0x2a>
  return wait(p);
    80002132:	fe843503          	ld	a0,-24(s0)
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	46c080e7          	jalr	1132(ra) # 800015a2 <wait>
}
    8000213e:	60e2                	ld	ra,24(sp)
    80002140:	6442                	ld	s0,16(sp)
    80002142:	6105                	addi	sp,sp,32
    80002144:	8082                	ret

0000000080002146 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002146:	7179                	addi	sp,sp,-48
    80002148:	f406                	sd	ra,40(sp)
    8000214a:	f022                	sd	s0,32(sp)
    8000214c:	ec26                	sd	s1,24(sp)
    8000214e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002150:	fdc40593          	addi	a1,s0,-36
    80002154:	4501                	li	a0,0
    80002156:	00000097          	auipc	ra,0x0
    8000215a:	e2c080e7          	jalr	-468(ra) # 80001f82 <argint>
    8000215e:	87aa                	mv	a5,a0
    return -1;
    80002160:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002162:	0207c063          	bltz	a5,80002182 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	d08080e7          	jalr	-760(ra) # 80000e6e <myproc>
    8000216e:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002170:	fdc42503          	lw	a0,-36(s0)
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	054080e7          	jalr	84(ra) # 800011c8 <growproc>
    8000217c:	00054863          	bltz	a0,8000218c <sys_sbrk+0x46>
    return -1;
  return addr;
    80002180:	8526                	mv	a0,s1
}
    80002182:	70a2                	ld	ra,40(sp)
    80002184:	7402                	ld	s0,32(sp)
    80002186:	64e2                	ld	s1,24(sp)
    80002188:	6145                	addi	sp,sp,48
    8000218a:	8082                	ret
    return -1;
    8000218c:	557d                	li	a0,-1
    8000218e:	bfd5                	j	80002182 <sys_sbrk+0x3c>

0000000080002190 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002190:	7139                	addi	sp,sp,-64
    80002192:	fc06                	sd	ra,56(sp)
    80002194:	f822                	sd	s0,48(sp)
    80002196:	f426                	sd	s1,40(sp)
    80002198:	f04a                	sd	s2,32(sp)
    8000219a:	ec4e                	sd	s3,24(sp)
    8000219c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000219e:	fcc40593          	addi	a1,s0,-52
    800021a2:	4501                	li	a0,0
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	dde080e7          	jalr	-546(ra) # 80001f82 <argint>
    return -1;
    800021ac:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ae:	06054563          	bltz	a0,80002218 <sys_sleep+0x88>
  acquire(&tickslock);
    800021b2:	0000d517          	auipc	a0,0xd
    800021b6:	4ce50513          	addi	a0,a0,1230 # 8000f680 <tickslock>
    800021ba:	00004097          	auipc	ra,0x4
    800021be:	058080e7          	jalr	88(ra) # 80006212 <acquire>
  ticks0 = ticks;
    800021c2:	00007917          	auipc	s2,0x7
    800021c6:	e5692903          	lw	s2,-426(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021ca:	fcc42783          	lw	a5,-52(s0)
    800021ce:	cf85                	beqz	a5,80002206 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021d0:	0000d997          	auipc	s3,0xd
    800021d4:	4b098993          	addi	s3,s3,1200 # 8000f680 <tickslock>
    800021d8:	00007497          	auipc	s1,0x7
    800021dc:	e4048493          	addi	s1,s1,-448 # 80009018 <ticks>
    if(myproc()->killed){
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	c8e080e7          	jalr	-882(ra) # 80000e6e <myproc>
    800021e8:	551c                	lw	a5,40(a0)
    800021ea:	ef9d                	bnez	a5,80002228 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021ec:	85ce                	mv	a1,s3
    800021ee:	8526                	mv	a0,s1
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	34e080e7          	jalr	846(ra) # 8000153e <sleep>
  while(ticks - ticks0 < n){
    800021f8:	409c                	lw	a5,0(s1)
    800021fa:	412787bb          	subw	a5,a5,s2
    800021fe:	fcc42703          	lw	a4,-52(s0)
    80002202:	fce7efe3          	bltu	a5,a4,800021e0 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002206:	0000d517          	auipc	a0,0xd
    8000220a:	47a50513          	addi	a0,a0,1146 # 8000f680 <tickslock>
    8000220e:	00004097          	auipc	ra,0x4
    80002212:	0b8080e7          	jalr	184(ra) # 800062c6 <release>
  return 0;
    80002216:	4781                	li	a5,0
}
    80002218:	853e                	mv	a0,a5
    8000221a:	70e2                	ld	ra,56(sp)
    8000221c:	7442                	ld	s0,48(sp)
    8000221e:	74a2                	ld	s1,40(sp)
    80002220:	7902                	ld	s2,32(sp)
    80002222:	69e2                	ld	s3,24(sp)
    80002224:	6121                	addi	sp,sp,64
    80002226:	8082                	ret
      release(&tickslock);
    80002228:	0000d517          	auipc	a0,0xd
    8000222c:	45850513          	addi	a0,a0,1112 # 8000f680 <tickslock>
    80002230:	00004097          	auipc	ra,0x4
    80002234:	096080e7          	jalr	150(ra) # 800062c6 <release>
      return -1;
    80002238:	57fd                	li	a5,-1
    8000223a:	bff9                	j	80002218 <sys_sleep+0x88>

000000008000223c <sys_kill>:

uint64
sys_kill(void)
{
    8000223c:	1101                	addi	sp,sp,-32
    8000223e:	ec06                	sd	ra,24(sp)
    80002240:	e822                	sd	s0,16(sp)
    80002242:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002244:	fec40593          	addi	a1,s0,-20
    80002248:	4501                	li	a0,0
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	d38080e7          	jalr	-712(ra) # 80001f82 <argint>
    80002252:	87aa                	mv	a5,a0
    return -1;
    80002254:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002256:	0007c863          	bltz	a5,80002266 <sys_kill+0x2a>
  return kill(pid);
    8000225a:	fec42503          	lw	a0,-20(s0)
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	612080e7          	jalr	1554(ra) # 80001870 <kill>
}
    80002266:	60e2                	ld	ra,24(sp)
    80002268:	6442                	ld	s0,16(sp)
    8000226a:	6105                	addi	sp,sp,32
    8000226c:	8082                	ret

000000008000226e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000226e:	1101                	addi	sp,sp,-32
    80002270:	ec06                	sd	ra,24(sp)
    80002272:	e822                	sd	s0,16(sp)
    80002274:	e426                	sd	s1,8(sp)
    80002276:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002278:	0000d517          	auipc	a0,0xd
    8000227c:	40850513          	addi	a0,a0,1032 # 8000f680 <tickslock>
    80002280:	00004097          	auipc	ra,0x4
    80002284:	f92080e7          	jalr	-110(ra) # 80006212 <acquire>
  xticks = ticks;
    80002288:	00007497          	auipc	s1,0x7
    8000228c:	d904a483          	lw	s1,-624(s1) # 80009018 <ticks>
  release(&tickslock);
    80002290:	0000d517          	auipc	a0,0xd
    80002294:	3f050513          	addi	a0,a0,1008 # 8000f680 <tickslock>
    80002298:	00004097          	auipc	ra,0x4
    8000229c:	02e080e7          	jalr	46(ra) # 800062c6 <release>
  return xticks;
}
    800022a0:	02049513          	slli	a0,s1,0x20
    800022a4:	9101                	srli	a0,a0,0x20
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	64a2                	ld	s1,8(sp)
    800022ac:	6105                	addi	sp,sp,32
    800022ae:	8082                	ret

00000000800022b0 <sys_trace>:

uint64 
sys_trace(void)
{
    800022b0:	1101                	addi	sp,sp,-32
    800022b2:	ec06                	sd	ra,24(sp)
    800022b4:	e822                	sd	s0,16(sp)
    800022b6:	1000                	addi	s0,sp,32
  int trace_mask;
  if(argint(0, &trace_mask) < 0)  return -1;
    800022b8:	fec40593          	addi	a1,s0,-20
    800022bc:	4501                	li	a0,0
    800022be:	00000097          	auipc	ra,0x0
    800022c2:	cc4080e7          	jalr	-828(ra) # 80001f82 <argint>
    800022c6:	57fd                	li	a5,-1
    800022c8:	04054a63          	bltz	a0,8000231c <sys_trace+0x6c>
  struct proc *p = myproc();
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	ba2080e7          	jalr	-1118(ra) # 80000e6e <myproc>
  char *mask = p->mask;
  for(int i = 0; trace_mask > 0; i++, trace_mask >>= 1){
    800022d4:	fec42783          	lw	a5,-20(s0)
    800022d8:	04f05763          	blez	a5,80002326 <sys_trace+0x76>
    800022dc:	16850513          	addi	a0,a0,360
    if(trace_mask % 2 == 1) mask[i] = '1';
    800022e0:	4685                	li	a3,1
    else mask[i] = '0';
    800022e2:	03000613          	li	a2,48
    if(trace_mask % 2 == 1) mask[i] = '1';
    800022e6:	03100593          	li	a1,49
    800022ea:	a831                	j	80002306 <sys_trace+0x56>
    else mask[i] = '0';
    800022ec:	00c50023          	sb	a2,0(a0)
  for(int i = 0; trace_mask > 0; i++, trace_mask >>= 1){
    800022f0:	fec42703          	lw	a4,-20(s0)
    800022f4:	4017571b          	sraiw	a4,a4,0x1
    800022f8:	0007079b          	sext.w	a5,a4
    800022fc:	fee42623          	sw	a4,-20(s0)
    80002300:	0505                	addi	a0,a0,1
    80002302:	00f05c63          	blez	a5,8000231a <sys_trace+0x6a>
    if(trace_mask % 2 == 1) mask[i] = '1';
    80002306:	01f7d71b          	srliw	a4,a5,0x1f
    8000230a:	9fb9                	addw	a5,a5,a4
    8000230c:	8b85                	andi	a5,a5,1
    8000230e:	9f99                	subw	a5,a5,a4
    80002310:	fcd79ee3          	bne	a5,a3,800022ec <sys_trace+0x3c>
    80002314:	00b50023          	sb	a1,0(a0)
    80002318:	bfe1                	j	800022f0 <sys_trace+0x40>
  }
  return 0;
    8000231a:	4781                	li	a5,0
}
    8000231c:	853e                	mv	a0,a5
    8000231e:	60e2                	ld	ra,24(sp)
    80002320:	6442                	ld	s0,16(sp)
    80002322:	6105                	addi	sp,sp,32
    80002324:	8082                	ret
  return 0;
    80002326:	4781                	li	a5,0
    80002328:	bfd5                	j	8000231c <sys_trace+0x6c>

000000008000232a <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    8000232a:	7139                	addi	sp,sp,-64
    8000232c:	fc06                	sd	ra,56(sp)
    8000232e:	f822                	sd	s0,48(sp)
    80002330:	f426                	sd	s1,40(sp)
    80002332:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	b3a080e7          	jalr	-1222(ra) # 80000e6e <myproc>
    8000233c:	84aa                	mv	s1,a0
  struct sysinfo info;

  info.freemem = get_freemem();
    8000233e:	ffffe097          	auipc	ra,0xffffe
    80002342:	e3a080e7          	jalr	-454(ra) # 80000178 <get_freemem>
    80002346:	fca43823          	sd	a0,-48(s0)
  info.nproc = get_nproc();
    8000234a:	fffff097          	auipc	ra,0xfffff
    8000234e:	6f2080e7          	jalr	1778(ra) # 80001a3c <get_nproc>
    80002352:	fca43c23          	sd	a0,-40(s0)
  
  uint64 addr;
  if(argaddr(0, &addr) < 0)
    80002356:	fc840593          	addi	a1,s0,-56
    8000235a:	4501                	li	a0,0
    8000235c:	00000097          	auipc	ra,0x0
    80002360:	c48080e7          	jalr	-952(ra) # 80001fa4 <argaddr>
    return  -1;
    80002364:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0)
    80002366:	00054e63          	bltz	a0,80002382 <sys_sysinfo+0x58>
  
  if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    8000236a:	46c1                	li	a3,16
    8000236c:	fd040613          	addi	a2,s0,-48
    80002370:	fc843583          	ld	a1,-56(s0)
    80002374:	68a8                	ld	a0,80(s1)
    80002376:	ffffe097          	auipc	ra,0xffffe
    8000237a:	7ba080e7          	jalr	1978(ra) # 80000b30 <copyout>
    8000237e:	43f55793          	srai	a5,a0,0x3f
      return -1;

  return 0;
}
    80002382:	853e                	mv	a0,a5
    80002384:	70e2                	ld	ra,56(sp)
    80002386:	7442                	ld	s0,48(sp)
    80002388:	74a2                	ld	s1,40(sp)
    8000238a:	6121                	addi	sp,sp,64
    8000238c:	8082                	ret

000000008000238e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000238e:	7179                	addi	sp,sp,-48
    80002390:	f406                	sd	ra,40(sp)
    80002392:	f022                	sd	s0,32(sp)
    80002394:	ec26                	sd	s1,24(sp)
    80002396:	e84a                	sd	s2,16(sp)
    80002398:	e44e                	sd	s3,8(sp)
    8000239a:	e052                	sd	s4,0(sp)
    8000239c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000239e:	00006597          	auipc	a1,0x6
    800023a2:	2b258593          	addi	a1,a1,690 # 80008650 <syscall_name+0x100>
    800023a6:	0000d517          	auipc	a0,0xd
    800023aa:	2f250513          	addi	a0,a0,754 # 8000f698 <bcache>
    800023ae:	00004097          	auipc	ra,0x4
    800023b2:	dd4080e7          	jalr	-556(ra) # 80006182 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023b6:	00015797          	auipc	a5,0x15
    800023ba:	2e278793          	addi	a5,a5,738 # 80017698 <bcache+0x8000>
    800023be:	00015717          	auipc	a4,0x15
    800023c2:	54270713          	addi	a4,a4,1346 # 80017900 <bcache+0x8268>
    800023c6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023ca:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ce:	0000d497          	auipc	s1,0xd
    800023d2:	2e248493          	addi	s1,s1,738 # 8000f6b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023d6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023d8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023da:	00006a17          	auipc	s4,0x6
    800023de:	27ea0a13          	addi	s4,s4,638 # 80008658 <syscall_name+0x108>
    b->next = bcache.head.next;
    800023e2:	2b893783          	ld	a5,696(s2)
    800023e6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023e8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ec:	85d2                	mv	a1,s4
    800023ee:	01048513          	addi	a0,s1,16
    800023f2:	00001097          	auipc	ra,0x1
    800023f6:	4bc080e7          	jalr	1212(ra) # 800038ae <initsleeplock>
    bcache.head.next->prev = b;
    800023fa:	2b893783          	ld	a5,696(s2)
    800023fe:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002400:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002404:	45848493          	addi	s1,s1,1112
    80002408:	fd349de3          	bne	s1,s3,800023e2 <binit+0x54>
  }
}
    8000240c:	70a2                	ld	ra,40(sp)
    8000240e:	7402                	ld	s0,32(sp)
    80002410:	64e2                	ld	s1,24(sp)
    80002412:	6942                	ld	s2,16(sp)
    80002414:	69a2                	ld	s3,8(sp)
    80002416:	6a02                	ld	s4,0(sp)
    80002418:	6145                	addi	sp,sp,48
    8000241a:	8082                	ret

000000008000241c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000241c:	7179                	addi	sp,sp,-48
    8000241e:	f406                	sd	ra,40(sp)
    80002420:	f022                	sd	s0,32(sp)
    80002422:	ec26                	sd	s1,24(sp)
    80002424:	e84a                	sd	s2,16(sp)
    80002426:	e44e                	sd	s3,8(sp)
    80002428:	1800                	addi	s0,sp,48
    8000242a:	89aa                	mv	s3,a0
    8000242c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000242e:	0000d517          	auipc	a0,0xd
    80002432:	26a50513          	addi	a0,a0,618 # 8000f698 <bcache>
    80002436:	00004097          	auipc	ra,0x4
    8000243a:	ddc080e7          	jalr	-548(ra) # 80006212 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000243e:	00015497          	auipc	s1,0x15
    80002442:	5124b483          	ld	s1,1298(s1) # 80017950 <bcache+0x82b8>
    80002446:	00015797          	auipc	a5,0x15
    8000244a:	4ba78793          	addi	a5,a5,1210 # 80017900 <bcache+0x8268>
    8000244e:	02f48f63          	beq	s1,a5,8000248c <bread+0x70>
    80002452:	873e                	mv	a4,a5
    80002454:	a021                	j	8000245c <bread+0x40>
    80002456:	68a4                	ld	s1,80(s1)
    80002458:	02e48a63          	beq	s1,a4,8000248c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000245c:	449c                	lw	a5,8(s1)
    8000245e:	ff379ce3          	bne	a5,s3,80002456 <bread+0x3a>
    80002462:	44dc                	lw	a5,12(s1)
    80002464:	ff2799e3          	bne	a5,s2,80002456 <bread+0x3a>
      b->refcnt++;
    80002468:	40bc                	lw	a5,64(s1)
    8000246a:	2785                	addiw	a5,a5,1
    8000246c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000246e:	0000d517          	auipc	a0,0xd
    80002472:	22a50513          	addi	a0,a0,554 # 8000f698 <bcache>
    80002476:	00004097          	auipc	ra,0x4
    8000247a:	e50080e7          	jalr	-432(ra) # 800062c6 <release>
      acquiresleep(&b->lock);
    8000247e:	01048513          	addi	a0,s1,16
    80002482:	00001097          	auipc	ra,0x1
    80002486:	466080e7          	jalr	1126(ra) # 800038e8 <acquiresleep>
      return b;
    8000248a:	a8b9                	j	800024e8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000248c:	00015497          	auipc	s1,0x15
    80002490:	4bc4b483          	ld	s1,1212(s1) # 80017948 <bcache+0x82b0>
    80002494:	00015797          	auipc	a5,0x15
    80002498:	46c78793          	addi	a5,a5,1132 # 80017900 <bcache+0x8268>
    8000249c:	00f48863          	beq	s1,a5,800024ac <bread+0x90>
    800024a0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024a2:	40bc                	lw	a5,64(s1)
    800024a4:	cf81                	beqz	a5,800024bc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024a6:	64a4                	ld	s1,72(s1)
    800024a8:	fee49de3          	bne	s1,a4,800024a2 <bread+0x86>
  panic("bget: no buffers");
    800024ac:	00006517          	auipc	a0,0x6
    800024b0:	1b450513          	addi	a0,a0,436 # 80008660 <syscall_name+0x110>
    800024b4:	00004097          	auipc	ra,0x4
    800024b8:	814080e7          	jalr	-2028(ra) # 80005cc8 <panic>
      b->dev = dev;
    800024bc:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024c0:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024c4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024c8:	4785                	li	a5,1
    800024ca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024cc:	0000d517          	auipc	a0,0xd
    800024d0:	1cc50513          	addi	a0,a0,460 # 8000f698 <bcache>
    800024d4:	00004097          	auipc	ra,0x4
    800024d8:	df2080e7          	jalr	-526(ra) # 800062c6 <release>
      acquiresleep(&b->lock);
    800024dc:	01048513          	addi	a0,s1,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	408080e7          	jalr	1032(ra) # 800038e8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024e8:	409c                	lw	a5,0(s1)
    800024ea:	cb89                	beqz	a5,800024fc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ec:	8526                	mv	a0,s1
    800024ee:	70a2                	ld	ra,40(sp)
    800024f0:	7402                	ld	s0,32(sp)
    800024f2:	64e2                	ld	s1,24(sp)
    800024f4:	6942                	ld	s2,16(sp)
    800024f6:	69a2                	ld	s3,8(sp)
    800024f8:	6145                	addi	sp,sp,48
    800024fa:	8082                	ret
    virtio_disk_rw(b, 0);
    800024fc:	4581                	li	a1,0
    800024fe:	8526                	mv	a0,s1
    80002500:	00003097          	auipc	ra,0x3
    80002504:	f06080e7          	jalr	-250(ra) # 80005406 <virtio_disk_rw>
    b->valid = 1;
    80002508:	4785                	li	a5,1
    8000250a:	c09c                	sw	a5,0(s1)
  return b;
    8000250c:	b7c5                	j	800024ec <bread+0xd0>

000000008000250e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000250e:	1101                	addi	sp,sp,-32
    80002510:	ec06                	sd	ra,24(sp)
    80002512:	e822                	sd	s0,16(sp)
    80002514:	e426                	sd	s1,8(sp)
    80002516:	1000                	addi	s0,sp,32
    80002518:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251a:	0541                	addi	a0,a0,16
    8000251c:	00001097          	auipc	ra,0x1
    80002520:	466080e7          	jalr	1126(ra) # 80003982 <holdingsleep>
    80002524:	cd01                	beqz	a0,8000253c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002526:	4585                	li	a1,1
    80002528:	8526                	mv	a0,s1
    8000252a:	00003097          	auipc	ra,0x3
    8000252e:	edc080e7          	jalr	-292(ra) # 80005406 <virtio_disk_rw>
}
    80002532:	60e2                	ld	ra,24(sp)
    80002534:	6442                	ld	s0,16(sp)
    80002536:	64a2                	ld	s1,8(sp)
    80002538:	6105                	addi	sp,sp,32
    8000253a:	8082                	ret
    panic("bwrite");
    8000253c:	00006517          	auipc	a0,0x6
    80002540:	13c50513          	addi	a0,a0,316 # 80008678 <syscall_name+0x128>
    80002544:	00003097          	auipc	ra,0x3
    80002548:	784080e7          	jalr	1924(ra) # 80005cc8 <panic>

000000008000254c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000254c:	1101                	addi	sp,sp,-32
    8000254e:	ec06                	sd	ra,24(sp)
    80002550:	e822                	sd	s0,16(sp)
    80002552:	e426                	sd	s1,8(sp)
    80002554:	e04a                	sd	s2,0(sp)
    80002556:	1000                	addi	s0,sp,32
    80002558:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000255a:	01050913          	addi	s2,a0,16
    8000255e:	854a                	mv	a0,s2
    80002560:	00001097          	auipc	ra,0x1
    80002564:	422080e7          	jalr	1058(ra) # 80003982 <holdingsleep>
    80002568:	c92d                	beqz	a0,800025da <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000256a:	854a                	mv	a0,s2
    8000256c:	00001097          	auipc	ra,0x1
    80002570:	3d2080e7          	jalr	978(ra) # 8000393e <releasesleep>

  acquire(&bcache.lock);
    80002574:	0000d517          	auipc	a0,0xd
    80002578:	12450513          	addi	a0,a0,292 # 8000f698 <bcache>
    8000257c:	00004097          	auipc	ra,0x4
    80002580:	c96080e7          	jalr	-874(ra) # 80006212 <acquire>
  b->refcnt--;
    80002584:	40bc                	lw	a5,64(s1)
    80002586:	37fd                	addiw	a5,a5,-1
    80002588:	0007871b          	sext.w	a4,a5
    8000258c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000258e:	eb05                	bnez	a4,800025be <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002590:	68bc                	ld	a5,80(s1)
    80002592:	64b8                	ld	a4,72(s1)
    80002594:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002596:	64bc                	ld	a5,72(s1)
    80002598:	68b8                	ld	a4,80(s1)
    8000259a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000259c:	00015797          	auipc	a5,0x15
    800025a0:	0fc78793          	addi	a5,a5,252 # 80017698 <bcache+0x8000>
    800025a4:	2b87b703          	ld	a4,696(a5)
    800025a8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025aa:	00015717          	auipc	a4,0x15
    800025ae:	35670713          	addi	a4,a4,854 # 80017900 <bcache+0x8268>
    800025b2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025b4:	2b87b703          	ld	a4,696(a5)
    800025b8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025ba:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025be:	0000d517          	auipc	a0,0xd
    800025c2:	0da50513          	addi	a0,a0,218 # 8000f698 <bcache>
    800025c6:	00004097          	auipc	ra,0x4
    800025ca:	d00080e7          	jalr	-768(ra) # 800062c6 <release>
}
    800025ce:	60e2                	ld	ra,24(sp)
    800025d0:	6442                	ld	s0,16(sp)
    800025d2:	64a2                	ld	s1,8(sp)
    800025d4:	6902                	ld	s2,0(sp)
    800025d6:	6105                	addi	sp,sp,32
    800025d8:	8082                	ret
    panic("brelse");
    800025da:	00006517          	auipc	a0,0x6
    800025de:	0a650513          	addi	a0,a0,166 # 80008680 <syscall_name+0x130>
    800025e2:	00003097          	auipc	ra,0x3
    800025e6:	6e6080e7          	jalr	1766(ra) # 80005cc8 <panic>

00000000800025ea <bpin>:

void
bpin(struct buf *b) {
    800025ea:	1101                	addi	sp,sp,-32
    800025ec:	ec06                	sd	ra,24(sp)
    800025ee:	e822                	sd	s0,16(sp)
    800025f0:	e426                	sd	s1,8(sp)
    800025f2:	1000                	addi	s0,sp,32
    800025f4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f6:	0000d517          	auipc	a0,0xd
    800025fa:	0a250513          	addi	a0,a0,162 # 8000f698 <bcache>
    800025fe:	00004097          	auipc	ra,0x4
    80002602:	c14080e7          	jalr	-1004(ra) # 80006212 <acquire>
  b->refcnt++;
    80002606:	40bc                	lw	a5,64(s1)
    80002608:	2785                	addiw	a5,a5,1
    8000260a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260c:	0000d517          	auipc	a0,0xd
    80002610:	08c50513          	addi	a0,a0,140 # 8000f698 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	cb2080e7          	jalr	-846(ra) # 800062c6 <release>
}
    8000261c:	60e2                	ld	ra,24(sp)
    8000261e:	6442                	ld	s0,16(sp)
    80002620:	64a2                	ld	s1,8(sp)
    80002622:	6105                	addi	sp,sp,32
    80002624:	8082                	ret

0000000080002626 <bunpin>:

void
bunpin(struct buf *b) {
    80002626:	1101                	addi	sp,sp,-32
    80002628:	ec06                	sd	ra,24(sp)
    8000262a:	e822                	sd	s0,16(sp)
    8000262c:	e426                	sd	s1,8(sp)
    8000262e:	1000                	addi	s0,sp,32
    80002630:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002632:	0000d517          	auipc	a0,0xd
    80002636:	06650513          	addi	a0,a0,102 # 8000f698 <bcache>
    8000263a:	00004097          	auipc	ra,0x4
    8000263e:	bd8080e7          	jalr	-1064(ra) # 80006212 <acquire>
  b->refcnt--;
    80002642:	40bc                	lw	a5,64(s1)
    80002644:	37fd                	addiw	a5,a5,-1
    80002646:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002648:	0000d517          	auipc	a0,0xd
    8000264c:	05050513          	addi	a0,a0,80 # 8000f698 <bcache>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	c76080e7          	jalr	-906(ra) # 800062c6 <release>
}
    80002658:	60e2                	ld	ra,24(sp)
    8000265a:	6442                	ld	s0,16(sp)
    8000265c:	64a2                	ld	s1,8(sp)
    8000265e:	6105                	addi	sp,sp,32
    80002660:	8082                	ret

0000000080002662 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002662:	1101                	addi	sp,sp,-32
    80002664:	ec06                	sd	ra,24(sp)
    80002666:	e822                	sd	s0,16(sp)
    80002668:	e426                	sd	s1,8(sp)
    8000266a:	e04a                	sd	s2,0(sp)
    8000266c:	1000                	addi	s0,sp,32
    8000266e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002670:	00d5d59b          	srliw	a1,a1,0xd
    80002674:	00015797          	auipc	a5,0x15
    80002678:	7007a783          	lw	a5,1792(a5) # 80017d74 <sb+0x1c>
    8000267c:	9dbd                	addw	a1,a1,a5
    8000267e:	00000097          	auipc	ra,0x0
    80002682:	d9e080e7          	jalr	-610(ra) # 8000241c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002686:	0074f713          	andi	a4,s1,7
    8000268a:	4785                	li	a5,1
    8000268c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002690:	14ce                	slli	s1,s1,0x33
    80002692:	90d9                	srli	s1,s1,0x36
    80002694:	00950733          	add	a4,a0,s1
    80002698:	05874703          	lbu	a4,88(a4)
    8000269c:	00e7f6b3          	and	a3,a5,a4
    800026a0:	c69d                	beqz	a3,800026ce <bfree+0x6c>
    800026a2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026a4:	94aa                	add	s1,s1,a0
    800026a6:	fff7c793          	not	a5,a5
    800026aa:	8ff9                	and	a5,a5,a4
    800026ac:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026b0:	00001097          	auipc	ra,0x1
    800026b4:	118080e7          	jalr	280(ra) # 800037c8 <log_write>
  brelse(bp);
    800026b8:	854a                	mv	a0,s2
    800026ba:	00000097          	auipc	ra,0x0
    800026be:	e92080e7          	jalr	-366(ra) # 8000254c <brelse>
}
    800026c2:	60e2                	ld	ra,24(sp)
    800026c4:	6442                	ld	s0,16(sp)
    800026c6:	64a2                	ld	s1,8(sp)
    800026c8:	6902                	ld	s2,0(sp)
    800026ca:	6105                	addi	sp,sp,32
    800026cc:	8082                	ret
    panic("freeing free block");
    800026ce:	00006517          	auipc	a0,0x6
    800026d2:	fba50513          	addi	a0,a0,-70 # 80008688 <syscall_name+0x138>
    800026d6:	00003097          	auipc	ra,0x3
    800026da:	5f2080e7          	jalr	1522(ra) # 80005cc8 <panic>

00000000800026de <balloc>:
{
    800026de:	711d                	addi	sp,sp,-96
    800026e0:	ec86                	sd	ra,88(sp)
    800026e2:	e8a2                	sd	s0,80(sp)
    800026e4:	e4a6                	sd	s1,72(sp)
    800026e6:	e0ca                	sd	s2,64(sp)
    800026e8:	fc4e                	sd	s3,56(sp)
    800026ea:	f852                	sd	s4,48(sp)
    800026ec:	f456                	sd	s5,40(sp)
    800026ee:	f05a                	sd	s6,32(sp)
    800026f0:	ec5e                	sd	s7,24(sp)
    800026f2:	e862                	sd	s8,16(sp)
    800026f4:	e466                	sd	s9,8(sp)
    800026f6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026f8:	00015797          	auipc	a5,0x15
    800026fc:	6647a783          	lw	a5,1636(a5) # 80017d5c <sb+0x4>
    80002700:	cbd1                	beqz	a5,80002794 <balloc+0xb6>
    80002702:	8baa                	mv	s7,a0
    80002704:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002706:	00015b17          	auipc	s6,0x15
    8000270a:	652b0b13          	addi	s6,s6,1618 # 80017d58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002710:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002712:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002714:	6c89                	lui	s9,0x2
    80002716:	a831                	j	80002732 <balloc+0x54>
    brelse(bp);
    80002718:	854a                	mv	a0,s2
    8000271a:	00000097          	auipc	ra,0x0
    8000271e:	e32080e7          	jalr	-462(ra) # 8000254c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002722:	015c87bb          	addw	a5,s9,s5
    80002726:	00078a9b          	sext.w	s5,a5
    8000272a:	004b2703          	lw	a4,4(s6)
    8000272e:	06eaf363          	bgeu	s5,a4,80002794 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002732:	41fad79b          	sraiw	a5,s5,0x1f
    80002736:	0137d79b          	srliw	a5,a5,0x13
    8000273a:	015787bb          	addw	a5,a5,s5
    8000273e:	40d7d79b          	sraiw	a5,a5,0xd
    80002742:	01cb2583          	lw	a1,28(s6)
    80002746:	9dbd                	addw	a1,a1,a5
    80002748:	855e                	mv	a0,s7
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	cd2080e7          	jalr	-814(ra) # 8000241c <bread>
    80002752:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002754:	004b2503          	lw	a0,4(s6)
    80002758:	000a849b          	sext.w	s1,s5
    8000275c:	8662                	mv	a2,s8
    8000275e:	faa4fde3          	bgeu	s1,a0,80002718 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002762:	41f6579b          	sraiw	a5,a2,0x1f
    80002766:	01d7d69b          	srliw	a3,a5,0x1d
    8000276a:	00c6873b          	addw	a4,a3,a2
    8000276e:	00777793          	andi	a5,a4,7
    80002772:	9f95                	subw	a5,a5,a3
    80002774:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002778:	4037571b          	sraiw	a4,a4,0x3
    8000277c:	00e906b3          	add	a3,s2,a4
    80002780:	0586c683          	lbu	a3,88(a3)
    80002784:	00d7f5b3          	and	a1,a5,a3
    80002788:	cd91                	beqz	a1,800027a4 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000278a:	2605                	addiw	a2,a2,1
    8000278c:	2485                	addiw	s1,s1,1
    8000278e:	fd4618e3          	bne	a2,s4,8000275e <balloc+0x80>
    80002792:	b759                	j	80002718 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002794:	00006517          	auipc	a0,0x6
    80002798:	f0c50513          	addi	a0,a0,-244 # 800086a0 <syscall_name+0x150>
    8000279c:	00003097          	auipc	ra,0x3
    800027a0:	52c080e7          	jalr	1324(ra) # 80005cc8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027a4:	974a                	add	a4,a4,s2
    800027a6:	8fd5                	or	a5,a5,a3
    800027a8:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800027ac:	854a                	mv	a0,s2
    800027ae:	00001097          	auipc	ra,0x1
    800027b2:	01a080e7          	jalr	26(ra) # 800037c8 <log_write>
        brelse(bp);
    800027b6:	854a                	mv	a0,s2
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	d94080e7          	jalr	-620(ra) # 8000254c <brelse>
  bp = bread(dev, bno);
    800027c0:	85a6                	mv	a1,s1
    800027c2:	855e                	mv	a0,s7
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	c58080e7          	jalr	-936(ra) # 8000241c <bread>
    800027cc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027ce:	40000613          	li	a2,1024
    800027d2:	4581                	li	a1,0
    800027d4:	05850513          	addi	a0,a0,88
    800027d8:	ffffe097          	auipc	ra,0xffffe
    800027dc:	9c6080e7          	jalr	-1594(ra) # 8000019e <memset>
  log_write(bp);
    800027e0:	854a                	mv	a0,s2
    800027e2:	00001097          	auipc	ra,0x1
    800027e6:	fe6080e7          	jalr	-26(ra) # 800037c8 <log_write>
  brelse(bp);
    800027ea:	854a                	mv	a0,s2
    800027ec:	00000097          	auipc	ra,0x0
    800027f0:	d60080e7          	jalr	-672(ra) # 8000254c <brelse>
}
    800027f4:	8526                	mv	a0,s1
    800027f6:	60e6                	ld	ra,88(sp)
    800027f8:	6446                	ld	s0,80(sp)
    800027fa:	64a6                	ld	s1,72(sp)
    800027fc:	6906                	ld	s2,64(sp)
    800027fe:	79e2                	ld	s3,56(sp)
    80002800:	7a42                	ld	s4,48(sp)
    80002802:	7aa2                	ld	s5,40(sp)
    80002804:	7b02                	ld	s6,32(sp)
    80002806:	6be2                	ld	s7,24(sp)
    80002808:	6c42                	ld	s8,16(sp)
    8000280a:	6ca2                	ld	s9,8(sp)
    8000280c:	6125                	addi	sp,sp,96
    8000280e:	8082                	ret

0000000080002810 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002810:	7179                	addi	sp,sp,-48
    80002812:	f406                	sd	ra,40(sp)
    80002814:	f022                	sd	s0,32(sp)
    80002816:	ec26                	sd	s1,24(sp)
    80002818:	e84a                	sd	s2,16(sp)
    8000281a:	e44e                	sd	s3,8(sp)
    8000281c:	e052                	sd	s4,0(sp)
    8000281e:	1800                	addi	s0,sp,48
    80002820:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002822:	47ad                	li	a5,11
    80002824:	04b7fe63          	bgeu	a5,a1,80002880 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002828:	ff45849b          	addiw	s1,a1,-12
    8000282c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002830:	0ff00793          	li	a5,255
    80002834:	0ae7e363          	bltu	a5,a4,800028da <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002838:	08052583          	lw	a1,128(a0)
    8000283c:	c5ad                	beqz	a1,800028a6 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000283e:	00092503          	lw	a0,0(s2)
    80002842:	00000097          	auipc	ra,0x0
    80002846:	bda080e7          	jalr	-1062(ra) # 8000241c <bread>
    8000284a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000284c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002850:	02049593          	slli	a1,s1,0x20
    80002854:	9181                	srli	a1,a1,0x20
    80002856:	058a                	slli	a1,a1,0x2
    80002858:	00b784b3          	add	s1,a5,a1
    8000285c:	0004a983          	lw	s3,0(s1)
    80002860:	04098d63          	beqz	s3,800028ba <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002864:	8552                	mv	a0,s4
    80002866:	00000097          	auipc	ra,0x0
    8000286a:	ce6080e7          	jalr	-794(ra) # 8000254c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000286e:	854e                	mv	a0,s3
    80002870:	70a2                	ld	ra,40(sp)
    80002872:	7402                	ld	s0,32(sp)
    80002874:	64e2                	ld	s1,24(sp)
    80002876:	6942                	ld	s2,16(sp)
    80002878:	69a2                	ld	s3,8(sp)
    8000287a:	6a02                	ld	s4,0(sp)
    8000287c:	6145                	addi	sp,sp,48
    8000287e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002880:	02059493          	slli	s1,a1,0x20
    80002884:	9081                	srli	s1,s1,0x20
    80002886:	048a                	slli	s1,s1,0x2
    80002888:	94aa                	add	s1,s1,a0
    8000288a:	0504a983          	lw	s3,80(s1)
    8000288e:	fe0990e3          	bnez	s3,8000286e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002892:	4108                	lw	a0,0(a0)
    80002894:	00000097          	auipc	ra,0x0
    80002898:	e4a080e7          	jalr	-438(ra) # 800026de <balloc>
    8000289c:	0005099b          	sext.w	s3,a0
    800028a0:	0534a823          	sw	s3,80(s1)
    800028a4:	b7e9                	j	8000286e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028a6:	4108                	lw	a0,0(a0)
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	e36080e7          	jalr	-458(ra) # 800026de <balloc>
    800028b0:	0005059b          	sext.w	a1,a0
    800028b4:	08b92023          	sw	a1,128(s2)
    800028b8:	b759                	j	8000283e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028ba:	00092503          	lw	a0,0(s2)
    800028be:	00000097          	auipc	ra,0x0
    800028c2:	e20080e7          	jalr	-480(ra) # 800026de <balloc>
    800028c6:	0005099b          	sext.w	s3,a0
    800028ca:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028ce:	8552                	mv	a0,s4
    800028d0:	00001097          	auipc	ra,0x1
    800028d4:	ef8080e7          	jalr	-264(ra) # 800037c8 <log_write>
    800028d8:	b771                	j	80002864 <bmap+0x54>
  panic("bmap: out of range");
    800028da:	00006517          	auipc	a0,0x6
    800028de:	dde50513          	addi	a0,a0,-546 # 800086b8 <syscall_name+0x168>
    800028e2:	00003097          	auipc	ra,0x3
    800028e6:	3e6080e7          	jalr	998(ra) # 80005cc8 <panic>

00000000800028ea <iget>:
{
    800028ea:	7179                	addi	sp,sp,-48
    800028ec:	f406                	sd	ra,40(sp)
    800028ee:	f022                	sd	s0,32(sp)
    800028f0:	ec26                	sd	s1,24(sp)
    800028f2:	e84a                	sd	s2,16(sp)
    800028f4:	e44e                	sd	s3,8(sp)
    800028f6:	e052                	sd	s4,0(sp)
    800028f8:	1800                	addi	s0,sp,48
    800028fa:	89aa                	mv	s3,a0
    800028fc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028fe:	00015517          	auipc	a0,0x15
    80002902:	47a50513          	addi	a0,a0,1146 # 80017d78 <itable>
    80002906:	00004097          	auipc	ra,0x4
    8000290a:	90c080e7          	jalr	-1780(ra) # 80006212 <acquire>
  empty = 0;
    8000290e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002910:	00015497          	auipc	s1,0x15
    80002914:	48048493          	addi	s1,s1,1152 # 80017d90 <itable+0x18>
    80002918:	00017697          	auipc	a3,0x17
    8000291c:	f0868693          	addi	a3,a3,-248 # 80019820 <log>
    80002920:	a039                	j	8000292e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002922:	02090b63          	beqz	s2,80002958 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002926:	08848493          	addi	s1,s1,136
    8000292a:	02d48a63          	beq	s1,a3,8000295e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000292e:	449c                	lw	a5,8(s1)
    80002930:	fef059e3          	blez	a5,80002922 <iget+0x38>
    80002934:	4098                	lw	a4,0(s1)
    80002936:	ff3716e3          	bne	a4,s3,80002922 <iget+0x38>
    8000293a:	40d8                	lw	a4,4(s1)
    8000293c:	ff4713e3          	bne	a4,s4,80002922 <iget+0x38>
      ip->ref++;
    80002940:	2785                	addiw	a5,a5,1
    80002942:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002944:	00015517          	auipc	a0,0x15
    80002948:	43450513          	addi	a0,a0,1076 # 80017d78 <itable>
    8000294c:	00004097          	auipc	ra,0x4
    80002950:	97a080e7          	jalr	-1670(ra) # 800062c6 <release>
      return ip;
    80002954:	8926                	mv	s2,s1
    80002956:	a03d                	j	80002984 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002958:	f7f9                	bnez	a5,80002926 <iget+0x3c>
    8000295a:	8926                	mv	s2,s1
    8000295c:	b7e9                	j	80002926 <iget+0x3c>
  if(empty == 0)
    8000295e:	02090c63          	beqz	s2,80002996 <iget+0xac>
  ip->dev = dev;
    80002962:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002966:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000296a:	4785                	li	a5,1
    8000296c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002970:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002974:	00015517          	auipc	a0,0x15
    80002978:	40450513          	addi	a0,a0,1028 # 80017d78 <itable>
    8000297c:	00004097          	auipc	ra,0x4
    80002980:	94a080e7          	jalr	-1718(ra) # 800062c6 <release>
}
    80002984:	854a                	mv	a0,s2
    80002986:	70a2                	ld	ra,40(sp)
    80002988:	7402                	ld	s0,32(sp)
    8000298a:	64e2                	ld	s1,24(sp)
    8000298c:	6942                	ld	s2,16(sp)
    8000298e:	69a2                	ld	s3,8(sp)
    80002990:	6a02                	ld	s4,0(sp)
    80002992:	6145                	addi	sp,sp,48
    80002994:	8082                	ret
    panic("iget: no inodes");
    80002996:	00006517          	auipc	a0,0x6
    8000299a:	d3a50513          	addi	a0,a0,-710 # 800086d0 <syscall_name+0x180>
    8000299e:	00003097          	auipc	ra,0x3
    800029a2:	32a080e7          	jalr	810(ra) # 80005cc8 <panic>

00000000800029a6 <fsinit>:
fsinit(int dev) {
    800029a6:	7179                	addi	sp,sp,-48
    800029a8:	f406                	sd	ra,40(sp)
    800029aa:	f022                	sd	s0,32(sp)
    800029ac:	ec26                	sd	s1,24(sp)
    800029ae:	e84a                	sd	s2,16(sp)
    800029b0:	e44e                	sd	s3,8(sp)
    800029b2:	1800                	addi	s0,sp,48
    800029b4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029b6:	4585                	li	a1,1
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	a64080e7          	jalr	-1436(ra) # 8000241c <bread>
    800029c0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029c2:	00015997          	auipc	s3,0x15
    800029c6:	39698993          	addi	s3,s3,918 # 80017d58 <sb>
    800029ca:	02000613          	li	a2,32
    800029ce:	05850593          	addi	a1,a0,88
    800029d2:	854e                	mv	a0,s3
    800029d4:	ffffe097          	auipc	ra,0xffffe
    800029d8:	82a080e7          	jalr	-2006(ra) # 800001fe <memmove>
  brelse(bp);
    800029dc:	8526                	mv	a0,s1
    800029de:	00000097          	auipc	ra,0x0
    800029e2:	b6e080e7          	jalr	-1170(ra) # 8000254c <brelse>
  if(sb.magic != FSMAGIC)
    800029e6:	0009a703          	lw	a4,0(s3)
    800029ea:	102037b7          	lui	a5,0x10203
    800029ee:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029f2:	02f71263          	bne	a4,a5,80002a16 <fsinit+0x70>
  initlog(dev, &sb);
    800029f6:	00015597          	auipc	a1,0x15
    800029fa:	36258593          	addi	a1,a1,866 # 80017d58 <sb>
    800029fe:	854a                	mv	a0,s2
    80002a00:	00001097          	auipc	ra,0x1
    80002a04:	b4c080e7          	jalr	-1204(ra) # 8000354c <initlog>
}
    80002a08:	70a2                	ld	ra,40(sp)
    80002a0a:	7402                	ld	s0,32(sp)
    80002a0c:	64e2                	ld	s1,24(sp)
    80002a0e:	6942                	ld	s2,16(sp)
    80002a10:	69a2                	ld	s3,8(sp)
    80002a12:	6145                	addi	sp,sp,48
    80002a14:	8082                	ret
    panic("invalid file system");
    80002a16:	00006517          	auipc	a0,0x6
    80002a1a:	cca50513          	addi	a0,a0,-822 # 800086e0 <syscall_name+0x190>
    80002a1e:	00003097          	auipc	ra,0x3
    80002a22:	2aa080e7          	jalr	682(ra) # 80005cc8 <panic>

0000000080002a26 <iinit>:
{
    80002a26:	7179                	addi	sp,sp,-48
    80002a28:	f406                	sd	ra,40(sp)
    80002a2a:	f022                	sd	s0,32(sp)
    80002a2c:	ec26                	sd	s1,24(sp)
    80002a2e:	e84a                	sd	s2,16(sp)
    80002a30:	e44e                	sd	s3,8(sp)
    80002a32:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a34:	00006597          	auipc	a1,0x6
    80002a38:	cc458593          	addi	a1,a1,-828 # 800086f8 <syscall_name+0x1a8>
    80002a3c:	00015517          	auipc	a0,0x15
    80002a40:	33c50513          	addi	a0,a0,828 # 80017d78 <itable>
    80002a44:	00003097          	auipc	ra,0x3
    80002a48:	73e080e7          	jalr	1854(ra) # 80006182 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a4c:	00015497          	auipc	s1,0x15
    80002a50:	35448493          	addi	s1,s1,852 # 80017da0 <itable+0x28>
    80002a54:	00017997          	auipc	s3,0x17
    80002a58:	ddc98993          	addi	s3,s3,-548 # 80019830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a5c:	00006917          	auipc	s2,0x6
    80002a60:	ca490913          	addi	s2,s2,-860 # 80008700 <syscall_name+0x1b0>
    80002a64:	85ca                	mv	a1,s2
    80002a66:	8526                	mv	a0,s1
    80002a68:	00001097          	auipc	ra,0x1
    80002a6c:	e46080e7          	jalr	-442(ra) # 800038ae <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a70:	08848493          	addi	s1,s1,136
    80002a74:	ff3498e3          	bne	s1,s3,80002a64 <iinit+0x3e>
}
    80002a78:	70a2                	ld	ra,40(sp)
    80002a7a:	7402                	ld	s0,32(sp)
    80002a7c:	64e2                	ld	s1,24(sp)
    80002a7e:	6942                	ld	s2,16(sp)
    80002a80:	69a2                	ld	s3,8(sp)
    80002a82:	6145                	addi	sp,sp,48
    80002a84:	8082                	ret

0000000080002a86 <ialloc>:
{
    80002a86:	715d                	addi	sp,sp,-80
    80002a88:	e486                	sd	ra,72(sp)
    80002a8a:	e0a2                	sd	s0,64(sp)
    80002a8c:	fc26                	sd	s1,56(sp)
    80002a8e:	f84a                	sd	s2,48(sp)
    80002a90:	f44e                	sd	s3,40(sp)
    80002a92:	f052                	sd	s4,32(sp)
    80002a94:	ec56                	sd	s5,24(sp)
    80002a96:	e85a                	sd	s6,16(sp)
    80002a98:	e45e                	sd	s7,8(sp)
    80002a9a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a9c:	00015717          	auipc	a4,0x15
    80002aa0:	2c872703          	lw	a4,712(a4) # 80017d64 <sb+0xc>
    80002aa4:	4785                	li	a5,1
    80002aa6:	04e7fa63          	bgeu	a5,a4,80002afa <ialloc+0x74>
    80002aaa:	8aaa                	mv	s5,a0
    80002aac:	8bae                	mv	s7,a1
    80002aae:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ab0:	00015a17          	auipc	s4,0x15
    80002ab4:	2a8a0a13          	addi	s4,s4,680 # 80017d58 <sb>
    80002ab8:	00048b1b          	sext.w	s6,s1
    80002abc:	0044d593          	srli	a1,s1,0x4
    80002ac0:	018a2783          	lw	a5,24(s4)
    80002ac4:	9dbd                	addw	a1,a1,a5
    80002ac6:	8556                	mv	a0,s5
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	954080e7          	jalr	-1708(ra) # 8000241c <bread>
    80002ad0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ad2:	05850993          	addi	s3,a0,88
    80002ad6:	00f4f793          	andi	a5,s1,15
    80002ada:	079a                	slli	a5,a5,0x6
    80002adc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ade:	00099783          	lh	a5,0(s3)
    80002ae2:	c785                	beqz	a5,80002b0a <ialloc+0x84>
    brelse(bp);
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	a68080e7          	jalr	-1432(ra) # 8000254c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aec:	0485                	addi	s1,s1,1
    80002aee:	00ca2703          	lw	a4,12(s4)
    80002af2:	0004879b          	sext.w	a5,s1
    80002af6:	fce7e1e3          	bltu	a5,a4,80002ab8 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002afa:	00006517          	auipc	a0,0x6
    80002afe:	c0e50513          	addi	a0,a0,-1010 # 80008708 <syscall_name+0x1b8>
    80002b02:	00003097          	auipc	ra,0x3
    80002b06:	1c6080e7          	jalr	454(ra) # 80005cc8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b0a:	04000613          	li	a2,64
    80002b0e:	4581                	li	a1,0
    80002b10:	854e                	mv	a0,s3
    80002b12:	ffffd097          	auipc	ra,0xffffd
    80002b16:	68c080e7          	jalr	1676(ra) # 8000019e <memset>
      dip->type = type;
    80002b1a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b1e:	854a                	mv	a0,s2
    80002b20:	00001097          	auipc	ra,0x1
    80002b24:	ca8080e7          	jalr	-856(ra) # 800037c8 <log_write>
      brelse(bp);
    80002b28:	854a                	mv	a0,s2
    80002b2a:	00000097          	auipc	ra,0x0
    80002b2e:	a22080e7          	jalr	-1502(ra) # 8000254c <brelse>
      return iget(dev, inum);
    80002b32:	85da                	mv	a1,s6
    80002b34:	8556                	mv	a0,s5
    80002b36:	00000097          	auipc	ra,0x0
    80002b3a:	db4080e7          	jalr	-588(ra) # 800028ea <iget>
}
    80002b3e:	60a6                	ld	ra,72(sp)
    80002b40:	6406                	ld	s0,64(sp)
    80002b42:	74e2                	ld	s1,56(sp)
    80002b44:	7942                	ld	s2,48(sp)
    80002b46:	79a2                	ld	s3,40(sp)
    80002b48:	7a02                	ld	s4,32(sp)
    80002b4a:	6ae2                	ld	s5,24(sp)
    80002b4c:	6b42                	ld	s6,16(sp)
    80002b4e:	6ba2                	ld	s7,8(sp)
    80002b50:	6161                	addi	sp,sp,80
    80002b52:	8082                	ret

0000000080002b54 <iupdate>:
{
    80002b54:	1101                	addi	sp,sp,-32
    80002b56:	ec06                	sd	ra,24(sp)
    80002b58:	e822                	sd	s0,16(sp)
    80002b5a:	e426                	sd	s1,8(sp)
    80002b5c:	e04a                	sd	s2,0(sp)
    80002b5e:	1000                	addi	s0,sp,32
    80002b60:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b62:	415c                	lw	a5,4(a0)
    80002b64:	0047d79b          	srliw	a5,a5,0x4
    80002b68:	00015597          	auipc	a1,0x15
    80002b6c:	2085a583          	lw	a1,520(a1) # 80017d70 <sb+0x18>
    80002b70:	9dbd                	addw	a1,a1,a5
    80002b72:	4108                	lw	a0,0(a0)
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	8a8080e7          	jalr	-1880(ra) # 8000241c <bread>
    80002b7c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b7e:	05850793          	addi	a5,a0,88
    80002b82:	40c8                	lw	a0,4(s1)
    80002b84:	893d                	andi	a0,a0,15
    80002b86:	051a                	slli	a0,a0,0x6
    80002b88:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b8a:	04449703          	lh	a4,68(s1)
    80002b8e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b92:	04649703          	lh	a4,70(s1)
    80002b96:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b9a:	04849703          	lh	a4,72(s1)
    80002b9e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ba2:	04a49703          	lh	a4,74(s1)
    80002ba6:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002baa:	44f8                	lw	a4,76(s1)
    80002bac:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bae:	03400613          	li	a2,52
    80002bb2:	05048593          	addi	a1,s1,80
    80002bb6:	0531                	addi	a0,a0,12
    80002bb8:	ffffd097          	auipc	ra,0xffffd
    80002bbc:	646080e7          	jalr	1606(ra) # 800001fe <memmove>
  log_write(bp);
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	00001097          	auipc	ra,0x1
    80002bc6:	c06080e7          	jalr	-1018(ra) # 800037c8 <log_write>
  brelse(bp);
    80002bca:	854a                	mv	a0,s2
    80002bcc:	00000097          	auipc	ra,0x0
    80002bd0:	980080e7          	jalr	-1664(ra) # 8000254c <brelse>
}
    80002bd4:	60e2                	ld	ra,24(sp)
    80002bd6:	6442                	ld	s0,16(sp)
    80002bd8:	64a2                	ld	s1,8(sp)
    80002bda:	6902                	ld	s2,0(sp)
    80002bdc:	6105                	addi	sp,sp,32
    80002bde:	8082                	ret

0000000080002be0 <idup>:
{
    80002be0:	1101                	addi	sp,sp,-32
    80002be2:	ec06                	sd	ra,24(sp)
    80002be4:	e822                	sd	s0,16(sp)
    80002be6:	e426                	sd	s1,8(sp)
    80002be8:	1000                	addi	s0,sp,32
    80002bea:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bec:	00015517          	auipc	a0,0x15
    80002bf0:	18c50513          	addi	a0,a0,396 # 80017d78 <itable>
    80002bf4:	00003097          	auipc	ra,0x3
    80002bf8:	61e080e7          	jalr	1566(ra) # 80006212 <acquire>
  ip->ref++;
    80002bfc:	449c                	lw	a5,8(s1)
    80002bfe:	2785                	addiw	a5,a5,1
    80002c00:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c02:	00015517          	auipc	a0,0x15
    80002c06:	17650513          	addi	a0,a0,374 # 80017d78 <itable>
    80002c0a:	00003097          	auipc	ra,0x3
    80002c0e:	6bc080e7          	jalr	1724(ra) # 800062c6 <release>
}
    80002c12:	8526                	mv	a0,s1
    80002c14:	60e2                	ld	ra,24(sp)
    80002c16:	6442                	ld	s0,16(sp)
    80002c18:	64a2                	ld	s1,8(sp)
    80002c1a:	6105                	addi	sp,sp,32
    80002c1c:	8082                	ret

0000000080002c1e <ilock>:
{
    80002c1e:	1101                	addi	sp,sp,-32
    80002c20:	ec06                	sd	ra,24(sp)
    80002c22:	e822                	sd	s0,16(sp)
    80002c24:	e426                	sd	s1,8(sp)
    80002c26:	e04a                	sd	s2,0(sp)
    80002c28:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c2a:	c115                	beqz	a0,80002c4e <ilock+0x30>
    80002c2c:	84aa                	mv	s1,a0
    80002c2e:	451c                	lw	a5,8(a0)
    80002c30:	00f05f63          	blez	a5,80002c4e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c34:	0541                	addi	a0,a0,16
    80002c36:	00001097          	auipc	ra,0x1
    80002c3a:	cb2080e7          	jalr	-846(ra) # 800038e8 <acquiresleep>
  if(ip->valid == 0){
    80002c3e:	40bc                	lw	a5,64(s1)
    80002c40:	cf99                	beqz	a5,80002c5e <ilock+0x40>
}
    80002c42:	60e2                	ld	ra,24(sp)
    80002c44:	6442                	ld	s0,16(sp)
    80002c46:	64a2                	ld	s1,8(sp)
    80002c48:	6902                	ld	s2,0(sp)
    80002c4a:	6105                	addi	sp,sp,32
    80002c4c:	8082                	ret
    panic("ilock");
    80002c4e:	00006517          	auipc	a0,0x6
    80002c52:	ad250513          	addi	a0,a0,-1326 # 80008720 <syscall_name+0x1d0>
    80002c56:	00003097          	auipc	ra,0x3
    80002c5a:	072080e7          	jalr	114(ra) # 80005cc8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c5e:	40dc                	lw	a5,4(s1)
    80002c60:	0047d79b          	srliw	a5,a5,0x4
    80002c64:	00015597          	auipc	a1,0x15
    80002c68:	10c5a583          	lw	a1,268(a1) # 80017d70 <sb+0x18>
    80002c6c:	9dbd                	addw	a1,a1,a5
    80002c6e:	4088                	lw	a0,0(s1)
    80002c70:	fffff097          	auipc	ra,0xfffff
    80002c74:	7ac080e7          	jalr	1964(ra) # 8000241c <bread>
    80002c78:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c7a:	05850593          	addi	a1,a0,88
    80002c7e:	40dc                	lw	a5,4(s1)
    80002c80:	8bbd                	andi	a5,a5,15
    80002c82:	079a                	slli	a5,a5,0x6
    80002c84:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c86:	00059783          	lh	a5,0(a1)
    80002c8a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c8e:	00259783          	lh	a5,2(a1)
    80002c92:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c96:	00459783          	lh	a5,4(a1)
    80002c9a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c9e:	00659783          	lh	a5,6(a1)
    80002ca2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ca6:	459c                	lw	a5,8(a1)
    80002ca8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002caa:	03400613          	li	a2,52
    80002cae:	05b1                	addi	a1,a1,12
    80002cb0:	05048513          	addi	a0,s1,80
    80002cb4:	ffffd097          	auipc	ra,0xffffd
    80002cb8:	54a080e7          	jalr	1354(ra) # 800001fe <memmove>
    brelse(bp);
    80002cbc:	854a                	mv	a0,s2
    80002cbe:	00000097          	auipc	ra,0x0
    80002cc2:	88e080e7          	jalr	-1906(ra) # 8000254c <brelse>
    ip->valid = 1;
    80002cc6:	4785                	li	a5,1
    80002cc8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cca:	04449783          	lh	a5,68(s1)
    80002cce:	fbb5                	bnez	a5,80002c42 <ilock+0x24>
      panic("ilock: no type");
    80002cd0:	00006517          	auipc	a0,0x6
    80002cd4:	a5850513          	addi	a0,a0,-1448 # 80008728 <syscall_name+0x1d8>
    80002cd8:	00003097          	auipc	ra,0x3
    80002cdc:	ff0080e7          	jalr	-16(ra) # 80005cc8 <panic>

0000000080002ce0 <iunlock>:
{
    80002ce0:	1101                	addi	sp,sp,-32
    80002ce2:	ec06                	sd	ra,24(sp)
    80002ce4:	e822                	sd	s0,16(sp)
    80002ce6:	e426                	sd	s1,8(sp)
    80002ce8:	e04a                	sd	s2,0(sp)
    80002cea:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cec:	c905                	beqz	a0,80002d1c <iunlock+0x3c>
    80002cee:	84aa                	mv	s1,a0
    80002cf0:	01050913          	addi	s2,a0,16
    80002cf4:	854a                	mv	a0,s2
    80002cf6:	00001097          	auipc	ra,0x1
    80002cfa:	c8c080e7          	jalr	-884(ra) # 80003982 <holdingsleep>
    80002cfe:	cd19                	beqz	a0,80002d1c <iunlock+0x3c>
    80002d00:	449c                	lw	a5,8(s1)
    80002d02:	00f05d63          	blez	a5,80002d1c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d06:	854a                	mv	a0,s2
    80002d08:	00001097          	auipc	ra,0x1
    80002d0c:	c36080e7          	jalr	-970(ra) # 8000393e <releasesleep>
}
    80002d10:	60e2                	ld	ra,24(sp)
    80002d12:	6442                	ld	s0,16(sp)
    80002d14:	64a2                	ld	s1,8(sp)
    80002d16:	6902                	ld	s2,0(sp)
    80002d18:	6105                	addi	sp,sp,32
    80002d1a:	8082                	ret
    panic("iunlock");
    80002d1c:	00006517          	auipc	a0,0x6
    80002d20:	a1c50513          	addi	a0,a0,-1508 # 80008738 <syscall_name+0x1e8>
    80002d24:	00003097          	auipc	ra,0x3
    80002d28:	fa4080e7          	jalr	-92(ra) # 80005cc8 <panic>

0000000080002d2c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d2c:	7179                	addi	sp,sp,-48
    80002d2e:	f406                	sd	ra,40(sp)
    80002d30:	f022                	sd	s0,32(sp)
    80002d32:	ec26                	sd	s1,24(sp)
    80002d34:	e84a                	sd	s2,16(sp)
    80002d36:	e44e                	sd	s3,8(sp)
    80002d38:	e052                	sd	s4,0(sp)
    80002d3a:	1800                	addi	s0,sp,48
    80002d3c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d3e:	05050493          	addi	s1,a0,80
    80002d42:	08050913          	addi	s2,a0,128
    80002d46:	a021                	j	80002d4e <itrunc+0x22>
    80002d48:	0491                	addi	s1,s1,4
    80002d4a:	01248d63          	beq	s1,s2,80002d64 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d4e:	408c                	lw	a1,0(s1)
    80002d50:	dde5                	beqz	a1,80002d48 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d52:	0009a503          	lw	a0,0(s3)
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	90c080e7          	jalr	-1780(ra) # 80002662 <bfree>
      ip->addrs[i] = 0;
    80002d5e:	0004a023          	sw	zero,0(s1)
    80002d62:	b7dd                	j	80002d48 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d64:	0809a583          	lw	a1,128(s3)
    80002d68:	e185                	bnez	a1,80002d88 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d6a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d6e:	854e                	mv	a0,s3
    80002d70:	00000097          	auipc	ra,0x0
    80002d74:	de4080e7          	jalr	-540(ra) # 80002b54 <iupdate>
}
    80002d78:	70a2                	ld	ra,40(sp)
    80002d7a:	7402                	ld	s0,32(sp)
    80002d7c:	64e2                	ld	s1,24(sp)
    80002d7e:	6942                	ld	s2,16(sp)
    80002d80:	69a2                	ld	s3,8(sp)
    80002d82:	6a02                	ld	s4,0(sp)
    80002d84:	6145                	addi	sp,sp,48
    80002d86:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d88:	0009a503          	lw	a0,0(s3)
    80002d8c:	fffff097          	auipc	ra,0xfffff
    80002d90:	690080e7          	jalr	1680(ra) # 8000241c <bread>
    80002d94:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d96:	05850493          	addi	s1,a0,88
    80002d9a:	45850913          	addi	s2,a0,1112
    80002d9e:	a811                	j	80002db2 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002da0:	0009a503          	lw	a0,0(s3)
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	8be080e7          	jalr	-1858(ra) # 80002662 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002dac:	0491                	addi	s1,s1,4
    80002dae:	01248563          	beq	s1,s2,80002db8 <itrunc+0x8c>
      if(a[j])
    80002db2:	408c                	lw	a1,0(s1)
    80002db4:	dde5                	beqz	a1,80002dac <itrunc+0x80>
    80002db6:	b7ed                	j	80002da0 <itrunc+0x74>
    brelse(bp);
    80002db8:	8552                	mv	a0,s4
    80002dba:	fffff097          	auipc	ra,0xfffff
    80002dbe:	792080e7          	jalr	1938(ra) # 8000254c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dc2:	0809a583          	lw	a1,128(s3)
    80002dc6:	0009a503          	lw	a0,0(s3)
    80002dca:	00000097          	auipc	ra,0x0
    80002dce:	898080e7          	jalr	-1896(ra) # 80002662 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dd2:	0809a023          	sw	zero,128(s3)
    80002dd6:	bf51                	j	80002d6a <itrunc+0x3e>

0000000080002dd8 <iput>:
{
    80002dd8:	1101                	addi	sp,sp,-32
    80002dda:	ec06                	sd	ra,24(sp)
    80002ddc:	e822                	sd	s0,16(sp)
    80002dde:	e426                	sd	s1,8(sp)
    80002de0:	e04a                	sd	s2,0(sp)
    80002de2:	1000                	addi	s0,sp,32
    80002de4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002de6:	00015517          	auipc	a0,0x15
    80002dea:	f9250513          	addi	a0,a0,-110 # 80017d78 <itable>
    80002dee:	00003097          	auipc	ra,0x3
    80002df2:	424080e7          	jalr	1060(ra) # 80006212 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002df6:	4498                	lw	a4,8(s1)
    80002df8:	4785                	li	a5,1
    80002dfa:	02f70363          	beq	a4,a5,80002e20 <iput+0x48>
  ip->ref--;
    80002dfe:	449c                	lw	a5,8(s1)
    80002e00:	37fd                	addiw	a5,a5,-1
    80002e02:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e04:	00015517          	auipc	a0,0x15
    80002e08:	f7450513          	addi	a0,a0,-140 # 80017d78 <itable>
    80002e0c:	00003097          	auipc	ra,0x3
    80002e10:	4ba080e7          	jalr	1210(ra) # 800062c6 <release>
}
    80002e14:	60e2                	ld	ra,24(sp)
    80002e16:	6442                	ld	s0,16(sp)
    80002e18:	64a2                	ld	s1,8(sp)
    80002e1a:	6902                	ld	s2,0(sp)
    80002e1c:	6105                	addi	sp,sp,32
    80002e1e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e20:	40bc                	lw	a5,64(s1)
    80002e22:	dff1                	beqz	a5,80002dfe <iput+0x26>
    80002e24:	04a49783          	lh	a5,74(s1)
    80002e28:	fbf9                	bnez	a5,80002dfe <iput+0x26>
    acquiresleep(&ip->lock);
    80002e2a:	01048913          	addi	s2,s1,16
    80002e2e:	854a                	mv	a0,s2
    80002e30:	00001097          	auipc	ra,0x1
    80002e34:	ab8080e7          	jalr	-1352(ra) # 800038e8 <acquiresleep>
    release(&itable.lock);
    80002e38:	00015517          	auipc	a0,0x15
    80002e3c:	f4050513          	addi	a0,a0,-192 # 80017d78 <itable>
    80002e40:	00003097          	auipc	ra,0x3
    80002e44:	486080e7          	jalr	1158(ra) # 800062c6 <release>
    itrunc(ip);
    80002e48:	8526                	mv	a0,s1
    80002e4a:	00000097          	auipc	ra,0x0
    80002e4e:	ee2080e7          	jalr	-286(ra) # 80002d2c <itrunc>
    ip->type = 0;
    80002e52:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e56:	8526                	mv	a0,s1
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	cfc080e7          	jalr	-772(ra) # 80002b54 <iupdate>
    ip->valid = 0;
    80002e60:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e64:	854a                	mv	a0,s2
    80002e66:	00001097          	auipc	ra,0x1
    80002e6a:	ad8080e7          	jalr	-1320(ra) # 8000393e <releasesleep>
    acquire(&itable.lock);
    80002e6e:	00015517          	auipc	a0,0x15
    80002e72:	f0a50513          	addi	a0,a0,-246 # 80017d78 <itable>
    80002e76:	00003097          	auipc	ra,0x3
    80002e7a:	39c080e7          	jalr	924(ra) # 80006212 <acquire>
    80002e7e:	b741                	j	80002dfe <iput+0x26>

0000000080002e80 <iunlockput>:
{
    80002e80:	1101                	addi	sp,sp,-32
    80002e82:	ec06                	sd	ra,24(sp)
    80002e84:	e822                	sd	s0,16(sp)
    80002e86:	e426                	sd	s1,8(sp)
    80002e88:	1000                	addi	s0,sp,32
    80002e8a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e8c:	00000097          	auipc	ra,0x0
    80002e90:	e54080e7          	jalr	-428(ra) # 80002ce0 <iunlock>
  iput(ip);
    80002e94:	8526                	mv	a0,s1
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	f42080e7          	jalr	-190(ra) # 80002dd8 <iput>
}
    80002e9e:	60e2                	ld	ra,24(sp)
    80002ea0:	6442                	ld	s0,16(sp)
    80002ea2:	64a2                	ld	s1,8(sp)
    80002ea4:	6105                	addi	sp,sp,32
    80002ea6:	8082                	ret

0000000080002ea8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ea8:	1141                	addi	sp,sp,-16
    80002eaa:	e422                	sd	s0,8(sp)
    80002eac:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002eae:	411c                	lw	a5,0(a0)
    80002eb0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eb2:	415c                	lw	a5,4(a0)
    80002eb4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002eb6:	04451783          	lh	a5,68(a0)
    80002eba:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ebe:	04a51783          	lh	a5,74(a0)
    80002ec2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ec6:	04c56783          	lwu	a5,76(a0)
    80002eca:	e99c                	sd	a5,16(a1)
}
    80002ecc:	6422                	ld	s0,8(sp)
    80002ece:	0141                	addi	sp,sp,16
    80002ed0:	8082                	ret

0000000080002ed2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ed2:	457c                	lw	a5,76(a0)
    80002ed4:	0ed7e963          	bltu	a5,a3,80002fc6 <readi+0xf4>
{
    80002ed8:	7159                	addi	sp,sp,-112
    80002eda:	f486                	sd	ra,104(sp)
    80002edc:	f0a2                	sd	s0,96(sp)
    80002ede:	eca6                	sd	s1,88(sp)
    80002ee0:	e8ca                	sd	s2,80(sp)
    80002ee2:	e4ce                	sd	s3,72(sp)
    80002ee4:	e0d2                	sd	s4,64(sp)
    80002ee6:	fc56                	sd	s5,56(sp)
    80002ee8:	f85a                	sd	s6,48(sp)
    80002eea:	f45e                	sd	s7,40(sp)
    80002eec:	f062                	sd	s8,32(sp)
    80002eee:	ec66                	sd	s9,24(sp)
    80002ef0:	e86a                	sd	s10,16(sp)
    80002ef2:	e46e                	sd	s11,8(sp)
    80002ef4:	1880                	addi	s0,sp,112
    80002ef6:	8baa                	mv	s7,a0
    80002ef8:	8c2e                	mv	s8,a1
    80002efa:	8ab2                	mv	s5,a2
    80002efc:	84b6                	mv	s1,a3
    80002efe:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f00:	9f35                	addw	a4,a4,a3
    return 0;
    80002f02:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f04:	0ad76063          	bltu	a4,a3,80002fa4 <readi+0xd2>
  if(off + n > ip->size)
    80002f08:	00e7f463          	bgeu	a5,a4,80002f10 <readi+0x3e>
    n = ip->size - off;
    80002f0c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f10:	0a0b0963          	beqz	s6,80002fc2 <readi+0xf0>
    80002f14:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f16:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f1a:	5cfd                	li	s9,-1
    80002f1c:	a82d                	j	80002f56 <readi+0x84>
    80002f1e:	020a1d93          	slli	s11,s4,0x20
    80002f22:	020ddd93          	srli	s11,s11,0x20
    80002f26:	05890613          	addi	a2,s2,88
    80002f2a:	86ee                	mv	a3,s11
    80002f2c:	963a                	add	a2,a2,a4
    80002f2e:	85d6                	mv	a1,s5
    80002f30:	8562                	mv	a0,s8
    80002f32:	fffff097          	auipc	ra,0xfffff
    80002f36:	9b0080e7          	jalr	-1616(ra) # 800018e2 <either_copyout>
    80002f3a:	05950d63          	beq	a0,s9,80002f94 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f3e:	854a                	mv	a0,s2
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	60c080e7          	jalr	1548(ra) # 8000254c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f48:	013a09bb          	addw	s3,s4,s3
    80002f4c:	009a04bb          	addw	s1,s4,s1
    80002f50:	9aee                	add	s5,s5,s11
    80002f52:	0569f763          	bgeu	s3,s6,80002fa0 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f56:	000ba903          	lw	s2,0(s7)
    80002f5a:	00a4d59b          	srliw	a1,s1,0xa
    80002f5e:	855e                	mv	a0,s7
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	8b0080e7          	jalr	-1872(ra) # 80002810 <bmap>
    80002f68:	0005059b          	sext.w	a1,a0
    80002f6c:	854a                	mv	a0,s2
    80002f6e:	fffff097          	auipc	ra,0xfffff
    80002f72:	4ae080e7          	jalr	1198(ra) # 8000241c <bread>
    80002f76:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f78:	3ff4f713          	andi	a4,s1,1023
    80002f7c:	40ed07bb          	subw	a5,s10,a4
    80002f80:	413b06bb          	subw	a3,s6,s3
    80002f84:	8a3e                	mv	s4,a5
    80002f86:	2781                	sext.w	a5,a5
    80002f88:	0006861b          	sext.w	a2,a3
    80002f8c:	f8f679e3          	bgeu	a2,a5,80002f1e <readi+0x4c>
    80002f90:	8a36                	mv	s4,a3
    80002f92:	b771                	j	80002f1e <readi+0x4c>
      brelse(bp);
    80002f94:	854a                	mv	a0,s2
    80002f96:	fffff097          	auipc	ra,0xfffff
    80002f9a:	5b6080e7          	jalr	1462(ra) # 8000254c <brelse>
      tot = -1;
    80002f9e:	59fd                	li	s3,-1
  }
  return tot;
    80002fa0:	0009851b          	sext.w	a0,s3
}
    80002fa4:	70a6                	ld	ra,104(sp)
    80002fa6:	7406                	ld	s0,96(sp)
    80002fa8:	64e6                	ld	s1,88(sp)
    80002faa:	6946                	ld	s2,80(sp)
    80002fac:	69a6                	ld	s3,72(sp)
    80002fae:	6a06                	ld	s4,64(sp)
    80002fb0:	7ae2                	ld	s5,56(sp)
    80002fb2:	7b42                	ld	s6,48(sp)
    80002fb4:	7ba2                	ld	s7,40(sp)
    80002fb6:	7c02                	ld	s8,32(sp)
    80002fb8:	6ce2                	ld	s9,24(sp)
    80002fba:	6d42                	ld	s10,16(sp)
    80002fbc:	6da2                	ld	s11,8(sp)
    80002fbe:	6165                	addi	sp,sp,112
    80002fc0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc2:	89da                	mv	s3,s6
    80002fc4:	bff1                	j	80002fa0 <readi+0xce>
    return 0;
    80002fc6:	4501                	li	a0,0
}
    80002fc8:	8082                	ret

0000000080002fca <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fca:	457c                	lw	a5,76(a0)
    80002fcc:	10d7e863          	bltu	a5,a3,800030dc <writei+0x112>
{
    80002fd0:	7159                	addi	sp,sp,-112
    80002fd2:	f486                	sd	ra,104(sp)
    80002fd4:	f0a2                	sd	s0,96(sp)
    80002fd6:	eca6                	sd	s1,88(sp)
    80002fd8:	e8ca                	sd	s2,80(sp)
    80002fda:	e4ce                	sd	s3,72(sp)
    80002fdc:	e0d2                	sd	s4,64(sp)
    80002fde:	fc56                	sd	s5,56(sp)
    80002fe0:	f85a                	sd	s6,48(sp)
    80002fe2:	f45e                	sd	s7,40(sp)
    80002fe4:	f062                	sd	s8,32(sp)
    80002fe6:	ec66                	sd	s9,24(sp)
    80002fe8:	e86a                	sd	s10,16(sp)
    80002fea:	e46e                	sd	s11,8(sp)
    80002fec:	1880                	addi	s0,sp,112
    80002fee:	8b2a                	mv	s6,a0
    80002ff0:	8c2e                	mv	s8,a1
    80002ff2:	8ab2                	mv	s5,a2
    80002ff4:	8936                	mv	s2,a3
    80002ff6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002ff8:	00e687bb          	addw	a5,a3,a4
    80002ffc:	0ed7e263          	bltu	a5,a3,800030e0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003000:	00043737          	lui	a4,0x43
    80003004:	0ef76063          	bltu	a4,a5,800030e4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003008:	0c0b8863          	beqz	s7,800030d8 <writei+0x10e>
    8000300c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000300e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003012:	5cfd                	li	s9,-1
    80003014:	a091                	j	80003058 <writei+0x8e>
    80003016:	02099d93          	slli	s11,s3,0x20
    8000301a:	020ddd93          	srli	s11,s11,0x20
    8000301e:	05848513          	addi	a0,s1,88
    80003022:	86ee                	mv	a3,s11
    80003024:	8656                	mv	a2,s5
    80003026:	85e2                	mv	a1,s8
    80003028:	953a                	add	a0,a0,a4
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	90e080e7          	jalr	-1778(ra) # 80001938 <either_copyin>
    80003032:	07950263          	beq	a0,s9,80003096 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003036:	8526                	mv	a0,s1
    80003038:	00000097          	auipc	ra,0x0
    8000303c:	790080e7          	jalr	1936(ra) # 800037c8 <log_write>
    brelse(bp);
    80003040:	8526                	mv	a0,s1
    80003042:	fffff097          	auipc	ra,0xfffff
    80003046:	50a080e7          	jalr	1290(ra) # 8000254c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000304a:	01498a3b          	addw	s4,s3,s4
    8000304e:	0129893b          	addw	s2,s3,s2
    80003052:	9aee                	add	s5,s5,s11
    80003054:	057a7663          	bgeu	s4,s7,800030a0 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003058:	000b2483          	lw	s1,0(s6)
    8000305c:	00a9559b          	srliw	a1,s2,0xa
    80003060:	855a                	mv	a0,s6
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	7ae080e7          	jalr	1966(ra) # 80002810 <bmap>
    8000306a:	0005059b          	sext.w	a1,a0
    8000306e:	8526                	mv	a0,s1
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	3ac080e7          	jalr	940(ra) # 8000241c <bread>
    80003078:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000307a:	3ff97713          	andi	a4,s2,1023
    8000307e:	40ed07bb          	subw	a5,s10,a4
    80003082:	414b86bb          	subw	a3,s7,s4
    80003086:	89be                	mv	s3,a5
    80003088:	2781                	sext.w	a5,a5
    8000308a:	0006861b          	sext.w	a2,a3
    8000308e:	f8f674e3          	bgeu	a2,a5,80003016 <writei+0x4c>
    80003092:	89b6                	mv	s3,a3
    80003094:	b749                	j	80003016 <writei+0x4c>
      brelse(bp);
    80003096:	8526                	mv	a0,s1
    80003098:	fffff097          	auipc	ra,0xfffff
    8000309c:	4b4080e7          	jalr	1204(ra) # 8000254c <brelse>
  }

  if(off > ip->size)
    800030a0:	04cb2783          	lw	a5,76(s6)
    800030a4:	0127f463          	bgeu	a5,s2,800030ac <writei+0xe2>
    ip->size = off;
    800030a8:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030ac:	855a                	mv	a0,s6
    800030ae:	00000097          	auipc	ra,0x0
    800030b2:	aa6080e7          	jalr	-1370(ra) # 80002b54 <iupdate>

  return tot;
    800030b6:	000a051b          	sext.w	a0,s4
}
    800030ba:	70a6                	ld	ra,104(sp)
    800030bc:	7406                	ld	s0,96(sp)
    800030be:	64e6                	ld	s1,88(sp)
    800030c0:	6946                	ld	s2,80(sp)
    800030c2:	69a6                	ld	s3,72(sp)
    800030c4:	6a06                	ld	s4,64(sp)
    800030c6:	7ae2                	ld	s5,56(sp)
    800030c8:	7b42                	ld	s6,48(sp)
    800030ca:	7ba2                	ld	s7,40(sp)
    800030cc:	7c02                	ld	s8,32(sp)
    800030ce:	6ce2                	ld	s9,24(sp)
    800030d0:	6d42                	ld	s10,16(sp)
    800030d2:	6da2                	ld	s11,8(sp)
    800030d4:	6165                	addi	sp,sp,112
    800030d6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030d8:	8a5e                	mv	s4,s7
    800030da:	bfc9                	j	800030ac <writei+0xe2>
    return -1;
    800030dc:	557d                	li	a0,-1
}
    800030de:	8082                	ret
    return -1;
    800030e0:	557d                	li	a0,-1
    800030e2:	bfe1                	j	800030ba <writei+0xf0>
    return -1;
    800030e4:	557d                	li	a0,-1
    800030e6:	bfd1                	j	800030ba <writei+0xf0>

00000000800030e8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030e8:	1141                	addi	sp,sp,-16
    800030ea:	e406                	sd	ra,8(sp)
    800030ec:	e022                	sd	s0,0(sp)
    800030ee:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030f0:	4639                	li	a2,14
    800030f2:	ffffd097          	auipc	ra,0xffffd
    800030f6:	184080e7          	jalr	388(ra) # 80000276 <strncmp>
}
    800030fa:	60a2                	ld	ra,8(sp)
    800030fc:	6402                	ld	s0,0(sp)
    800030fe:	0141                	addi	sp,sp,16
    80003100:	8082                	ret

0000000080003102 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003102:	7139                	addi	sp,sp,-64
    80003104:	fc06                	sd	ra,56(sp)
    80003106:	f822                	sd	s0,48(sp)
    80003108:	f426                	sd	s1,40(sp)
    8000310a:	f04a                	sd	s2,32(sp)
    8000310c:	ec4e                	sd	s3,24(sp)
    8000310e:	e852                	sd	s4,16(sp)
    80003110:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003112:	04451703          	lh	a4,68(a0)
    80003116:	4785                	li	a5,1
    80003118:	00f71a63          	bne	a4,a5,8000312c <dirlookup+0x2a>
    8000311c:	892a                	mv	s2,a0
    8000311e:	89ae                	mv	s3,a1
    80003120:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003122:	457c                	lw	a5,76(a0)
    80003124:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003126:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003128:	e79d                	bnez	a5,80003156 <dirlookup+0x54>
    8000312a:	a8a5                	j	800031a2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000312c:	00005517          	auipc	a0,0x5
    80003130:	61450513          	addi	a0,a0,1556 # 80008740 <syscall_name+0x1f0>
    80003134:	00003097          	auipc	ra,0x3
    80003138:	b94080e7          	jalr	-1132(ra) # 80005cc8 <panic>
      panic("dirlookup read");
    8000313c:	00005517          	auipc	a0,0x5
    80003140:	61c50513          	addi	a0,a0,1564 # 80008758 <syscall_name+0x208>
    80003144:	00003097          	auipc	ra,0x3
    80003148:	b84080e7          	jalr	-1148(ra) # 80005cc8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000314c:	24c1                	addiw	s1,s1,16
    8000314e:	04c92783          	lw	a5,76(s2)
    80003152:	04f4f763          	bgeu	s1,a5,800031a0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003156:	4741                	li	a4,16
    80003158:	86a6                	mv	a3,s1
    8000315a:	fc040613          	addi	a2,s0,-64
    8000315e:	4581                	li	a1,0
    80003160:	854a                	mv	a0,s2
    80003162:	00000097          	auipc	ra,0x0
    80003166:	d70080e7          	jalr	-656(ra) # 80002ed2 <readi>
    8000316a:	47c1                	li	a5,16
    8000316c:	fcf518e3          	bne	a0,a5,8000313c <dirlookup+0x3a>
    if(de.inum == 0)
    80003170:	fc045783          	lhu	a5,-64(s0)
    80003174:	dfe1                	beqz	a5,8000314c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003176:	fc240593          	addi	a1,s0,-62
    8000317a:	854e                	mv	a0,s3
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	f6c080e7          	jalr	-148(ra) # 800030e8 <namecmp>
    80003184:	f561                	bnez	a0,8000314c <dirlookup+0x4a>
      if(poff)
    80003186:	000a0463          	beqz	s4,8000318e <dirlookup+0x8c>
        *poff = off;
    8000318a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000318e:	fc045583          	lhu	a1,-64(s0)
    80003192:	00092503          	lw	a0,0(s2)
    80003196:	fffff097          	auipc	ra,0xfffff
    8000319a:	754080e7          	jalr	1876(ra) # 800028ea <iget>
    8000319e:	a011                	j	800031a2 <dirlookup+0xa0>
  return 0;
    800031a0:	4501                	li	a0,0
}
    800031a2:	70e2                	ld	ra,56(sp)
    800031a4:	7442                	ld	s0,48(sp)
    800031a6:	74a2                	ld	s1,40(sp)
    800031a8:	7902                	ld	s2,32(sp)
    800031aa:	69e2                	ld	s3,24(sp)
    800031ac:	6a42                	ld	s4,16(sp)
    800031ae:	6121                	addi	sp,sp,64
    800031b0:	8082                	ret

00000000800031b2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031b2:	711d                	addi	sp,sp,-96
    800031b4:	ec86                	sd	ra,88(sp)
    800031b6:	e8a2                	sd	s0,80(sp)
    800031b8:	e4a6                	sd	s1,72(sp)
    800031ba:	e0ca                	sd	s2,64(sp)
    800031bc:	fc4e                	sd	s3,56(sp)
    800031be:	f852                	sd	s4,48(sp)
    800031c0:	f456                	sd	s5,40(sp)
    800031c2:	f05a                	sd	s6,32(sp)
    800031c4:	ec5e                	sd	s7,24(sp)
    800031c6:	e862                	sd	s8,16(sp)
    800031c8:	e466                	sd	s9,8(sp)
    800031ca:	1080                	addi	s0,sp,96
    800031cc:	84aa                	mv	s1,a0
    800031ce:	8b2e                	mv	s6,a1
    800031d0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031d2:	00054703          	lbu	a4,0(a0)
    800031d6:	02f00793          	li	a5,47
    800031da:	02f70363          	beq	a4,a5,80003200 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031de:	ffffe097          	auipc	ra,0xffffe
    800031e2:	c90080e7          	jalr	-880(ra) # 80000e6e <myproc>
    800031e6:	15053503          	ld	a0,336(a0)
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	9f6080e7          	jalr	-1546(ra) # 80002be0 <idup>
    800031f2:	89aa                	mv	s3,a0
  while(*path == '/')
    800031f4:	02f00913          	li	s2,47
  len = path - s;
    800031f8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031fa:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031fc:	4c05                	li	s8,1
    800031fe:	a865                	j	800032b6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003200:	4585                	li	a1,1
    80003202:	4505                	li	a0,1
    80003204:	fffff097          	auipc	ra,0xfffff
    80003208:	6e6080e7          	jalr	1766(ra) # 800028ea <iget>
    8000320c:	89aa                	mv	s3,a0
    8000320e:	b7dd                	j	800031f4 <namex+0x42>
      iunlockput(ip);
    80003210:	854e                	mv	a0,s3
    80003212:	00000097          	auipc	ra,0x0
    80003216:	c6e080e7          	jalr	-914(ra) # 80002e80 <iunlockput>
      return 0;
    8000321a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000321c:	854e                	mv	a0,s3
    8000321e:	60e6                	ld	ra,88(sp)
    80003220:	6446                	ld	s0,80(sp)
    80003222:	64a6                	ld	s1,72(sp)
    80003224:	6906                	ld	s2,64(sp)
    80003226:	79e2                	ld	s3,56(sp)
    80003228:	7a42                	ld	s4,48(sp)
    8000322a:	7aa2                	ld	s5,40(sp)
    8000322c:	7b02                	ld	s6,32(sp)
    8000322e:	6be2                	ld	s7,24(sp)
    80003230:	6c42                	ld	s8,16(sp)
    80003232:	6ca2                	ld	s9,8(sp)
    80003234:	6125                	addi	sp,sp,96
    80003236:	8082                	ret
      iunlock(ip);
    80003238:	854e                	mv	a0,s3
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	aa6080e7          	jalr	-1370(ra) # 80002ce0 <iunlock>
      return ip;
    80003242:	bfe9                	j	8000321c <namex+0x6a>
      iunlockput(ip);
    80003244:	854e                	mv	a0,s3
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	c3a080e7          	jalr	-966(ra) # 80002e80 <iunlockput>
      return 0;
    8000324e:	89d2                	mv	s3,s4
    80003250:	b7f1                	j	8000321c <namex+0x6a>
  len = path - s;
    80003252:	40b48633          	sub	a2,s1,a1
    80003256:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000325a:	094cd463          	bge	s9,s4,800032e2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000325e:	4639                	li	a2,14
    80003260:	8556                	mv	a0,s5
    80003262:	ffffd097          	auipc	ra,0xffffd
    80003266:	f9c080e7          	jalr	-100(ra) # 800001fe <memmove>
  while(*path == '/')
    8000326a:	0004c783          	lbu	a5,0(s1)
    8000326e:	01279763          	bne	a5,s2,8000327c <namex+0xca>
    path++;
    80003272:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003274:	0004c783          	lbu	a5,0(s1)
    80003278:	ff278de3          	beq	a5,s2,80003272 <namex+0xc0>
    ilock(ip);
    8000327c:	854e                	mv	a0,s3
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	9a0080e7          	jalr	-1632(ra) # 80002c1e <ilock>
    if(ip->type != T_DIR){
    80003286:	04499783          	lh	a5,68(s3)
    8000328a:	f98793e3          	bne	a5,s8,80003210 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000328e:	000b0563          	beqz	s6,80003298 <namex+0xe6>
    80003292:	0004c783          	lbu	a5,0(s1)
    80003296:	d3cd                	beqz	a5,80003238 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003298:	865e                	mv	a2,s7
    8000329a:	85d6                	mv	a1,s5
    8000329c:	854e                	mv	a0,s3
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	e64080e7          	jalr	-412(ra) # 80003102 <dirlookup>
    800032a6:	8a2a                	mv	s4,a0
    800032a8:	dd51                	beqz	a0,80003244 <namex+0x92>
    iunlockput(ip);
    800032aa:	854e                	mv	a0,s3
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	bd4080e7          	jalr	-1068(ra) # 80002e80 <iunlockput>
    ip = next;
    800032b4:	89d2                	mv	s3,s4
  while(*path == '/')
    800032b6:	0004c783          	lbu	a5,0(s1)
    800032ba:	05279763          	bne	a5,s2,80003308 <namex+0x156>
    path++;
    800032be:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032c0:	0004c783          	lbu	a5,0(s1)
    800032c4:	ff278de3          	beq	a5,s2,800032be <namex+0x10c>
  if(*path == 0)
    800032c8:	c79d                	beqz	a5,800032f6 <namex+0x144>
    path++;
    800032ca:	85a6                	mv	a1,s1
  len = path - s;
    800032cc:	8a5e                	mv	s4,s7
    800032ce:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032d0:	01278963          	beq	a5,s2,800032e2 <namex+0x130>
    800032d4:	dfbd                	beqz	a5,80003252 <namex+0xa0>
    path++;
    800032d6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032d8:	0004c783          	lbu	a5,0(s1)
    800032dc:	ff279ce3          	bne	a5,s2,800032d4 <namex+0x122>
    800032e0:	bf8d                	j	80003252 <namex+0xa0>
    memmove(name, s, len);
    800032e2:	2601                	sext.w	a2,a2
    800032e4:	8556                	mv	a0,s5
    800032e6:	ffffd097          	auipc	ra,0xffffd
    800032ea:	f18080e7          	jalr	-232(ra) # 800001fe <memmove>
    name[len] = 0;
    800032ee:	9a56                	add	s4,s4,s5
    800032f0:	000a0023          	sb	zero,0(s4)
    800032f4:	bf9d                	j	8000326a <namex+0xb8>
  if(nameiparent){
    800032f6:	f20b03e3          	beqz	s6,8000321c <namex+0x6a>
    iput(ip);
    800032fa:	854e                	mv	a0,s3
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	adc080e7          	jalr	-1316(ra) # 80002dd8 <iput>
    return 0;
    80003304:	4981                	li	s3,0
    80003306:	bf19                	j	8000321c <namex+0x6a>
  if(*path == 0)
    80003308:	d7fd                	beqz	a5,800032f6 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000330a:	0004c783          	lbu	a5,0(s1)
    8000330e:	85a6                	mv	a1,s1
    80003310:	b7d1                	j	800032d4 <namex+0x122>

0000000080003312 <dirlink>:
{
    80003312:	7139                	addi	sp,sp,-64
    80003314:	fc06                	sd	ra,56(sp)
    80003316:	f822                	sd	s0,48(sp)
    80003318:	f426                	sd	s1,40(sp)
    8000331a:	f04a                	sd	s2,32(sp)
    8000331c:	ec4e                	sd	s3,24(sp)
    8000331e:	e852                	sd	s4,16(sp)
    80003320:	0080                	addi	s0,sp,64
    80003322:	892a                	mv	s2,a0
    80003324:	8a2e                	mv	s4,a1
    80003326:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003328:	4601                	li	a2,0
    8000332a:	00000097          	auipc	ra,0x0
    8000332e:	dd8080e7          	jalr	-552(ra) # 80003102 <dirlookup>
    80003332:	e93d                	bnez	a0,800033a8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003334:	04c92483          	lw	s1,76(s2)
    80003338:	c49d                	beqz	s1,80003366 <dirlink+0x54>
    8000333a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000333c:	4741                	li	a4,16
    8000333e:	86a6                	mv	a3,s1
    80003340:	fc040613          	addi	a2,s0,-64
    80003344:	4581                	li	a1,0
    80003346:	854a                	mv	a0,s2
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	b8a080e7          	jalr	-1142(ra) # 80002ed2 <readi>
    80003350:	47c1                	li	a5,16
    80003352:	06f51163          	bne	a0,a5,800033b4 <dirlink+0xa2>
    if(de.inum == 0)
    80003356:	fc045783          	lhu	a5,-64(s0)
    8000335a:	c791                	beqz	a5,80003366 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000335c:	24c1                	addiw	s1,s1,16
    8000335e:	04c92783          	lw	a5,76(s2)
    80003362:	fcf4ede3          	bltu	s1,a5,8000333c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003366:	4639                	li	a2,14
    80003368:	85d2                	mv	a1,s4
    8000336a:	fc240513          	addi	a0,s0,-62
    8000336e:	ffffd097          	auipc	ra,0xffffd
    80003372:	f44080e7          	jalr	-188(ra) # 800002b2 <strncpy>
  de.inum = inum;
    80003376:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000337a:	4741                	li	a4,16
    8000337c:	86a6                	mv	a3,s1
    8000337e:	fc040613          	addi	a2,s0,-64
    80003382:	4581                	li	a1,0
    80003384:	854a                	mv	a0,s2
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	c44080e7          	jalr	-956(ra) # 80002fca <writei>
    8000338e:	872a                	mv	a4,a0
    80003390:	47c1                	li	a5,16
  return 0;
    80003392:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003394:	02f71863          	bne	a4,a5,800033c4 <dirlink+0xb2>
}
    80003398:	70e2                	ld	ra,56(sp)
    8000339a:	7442                	ld	s0,48(sp)
    8000339c:	74a2                	ld	s1,40(sp)
    8000339e:	7902                	ld	s2,32(sp)
    800033a0:	69e2                	ld	s3,24(sp)
    800033a2:	6a42                	ld	s4,16(sp)
    800033a4:	6121                	addi	sp,sp,64
    800033a6:	8082                	ret
    iput(ip);
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	a30080e7          	jalr	-1488(ra) # 80002dd8 <iput>
    return -1;
    800033b0:	557d                	li	a0,-1
    800033b2:	b7dd                	j	80003398 <dirlink+0x86>
      panic("dirlink read");
    800033b4:	00005517          	auipc	a0,0x5
    800033b8:	3b450513          	addi	a0,a0,948 # 80008768 <syscall_name+0x218>
    800033bc:	00003097          	auipc	ra,0x3
    800033c0:	90c080e7          	jalr	-1780(ra) # 80005cc8 <panic>
    panic("dirlink");
    800033c4:	00005517          	auipc	a0,0x5
    800033c8:	4ac50513          	addi	a0,a0,1196 # 80008870 <syscall_name+0x320>
    800033cc:	00003097          	auipc	ra,0x3
    800033d0:	8fc080e7          	jalr	-1796(ra) # 80005cc8 <panic>

00000000800033d4 <namei>:

struct inode*
namei(char *path)
{
    800033d4:	1101                	addi	sp,sp,-32
    800033d6:	ec06                	sd	ra,24(sp)
    800033d8:	e822                	sd	s0,16(sp)
    800033da:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033dc:	fe040613          	addi	a2,s0,-32
    800033e0:	4581                	li	a1,0
    800033e2:	00000097          	auipc	ra,0x0
    800033e6:	dd0080e7          	jalr	-560(ra) # 800031b2 <namex>
}
    800033ea:	60e2                	ld	ra,24(sp)
    800033ec:	6442                	ld	s0,16(sp)
    800033ee:	6105                	addi	sp,sp,32
    800033f0:	8082                	ret

00000000800033f2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033f2:	1141                	addi	sp,sp,-16
    800033f4:	e406                	sd	ra,8(sp)
    800033f6:	e022                	sd	s0,0(sp)
    800033f8:	0800                	addi	s0,sp,16
    800033fa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033fc:	4585                	li	a1,1
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	db4080e7          	jalr	-588(ra) # 800031b2 <namex>
}
    80003406:	60a2                	ld	ra,8(sp)
    80003408:	6402                	ld	s0,0(sp)
    8000340a:	0141                	addi	sp,sp,16
    8000340c:	8082                	ret

000000008000340e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000340e:	1101                	addi	sp,sp,-32
    80003410:	ec06                	sd	ra,24(sp)
    80003412:	e822                	sd	s0,16(sp)
    80003414:	e426                	sd	s1,8(sp)
    80003416:	e04a                	sd	s2,0(sp)
    80003418:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000341a:	00016917          	auipc	s2,0x16
    8000341e:	40690913          	addi	s2,s2,1030 # 80019820 <log>
    80003422:	01892583          	lw	a1,24(s2)
    80003426:	02892503          	lw	a0,40(s2)
    8000342a:	fffff097          	auipc	ra,0xfffff
    8000342e:	ff2080e7          	jalr	-14(ra) # 8000241c <bread>
    80003432:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003434:	02c92683          	lw	a3,44(s2)
    80003438:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000343a:	02d05763          	blez	a3,80003468 <write_head+0x5a>
    8000343e:	00016797          	auipc	a5,0x16
    80003442:	41278793          	addi	a5,a5,1042 # 80019850 <log+0x30>
    80003446:	05c50713          	addi	a4,a0,92
    8000344a:	36fd                	addiw	a3,a3,-1
    8000344c:	1682                	slli	a3,a3,0x20
    8000344e:	9281                	srli	a3,a3,0x20
    80003450:	068a                	slli	a3,a3,0x2
    80003452:	00016617          	auipc	a2,0x16
    80003456:	40260613          	addi	a2,a2,1026 # 80019854 <log+0x34>
    8000345a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000345c:	4390                	lw	a2,0(a5)
    8000345e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003460:	0791                	addi	a5,a5,4
    80003462:	0711                	addi	a4,a4,4
    80003464:	fed79ce3          	bne	a5,a3,8000345c <write_head+0x4e>
  }
  bwrite(buf);
    80003468:	8526                	mv	a0,s1
    8000346a:	fffff097          	auipc	ra,0xfffff
    8000346e:	0a4080e7          	jalr	164(ra) # 8000250e <bwrite>
  brelse(buf);
    80003472:	8526                	mv	a0,s1
    80003474:	fffff097          	auipc	ra,0xfffff
    80003478:	0d8080e7          	jalr	216(ra) # 8000254c <brelse>
}
    8000347c:	60e2                	ld	ra,24(sp)
    8000347e:	6442                	ld	s0,16(sp)
    80003480:	64a2                	ld	s1,8(sp)
    80003482:	6902                	ld	s2,0(sp)
    80003484:	6105                	addi	sp,sp,32
    80003486:	8082                	ret

0000000080003488 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003488:	00016797          	auipc	a5,0x16
    8000348c:	3c47a783          	lw	a5,964(a5) # 8001984c <log+0x2c>
    80003490:	0af05d63          	blez	a5,8000354a <install_trans+0xc2>
{
    80003494:	7139                	addi	sp,sp,-64
    80003496:	fc06                	sd	ra,56(sp)
    80003498:	f822                	sd	s0,48(sp)
    8000349a:	f426                	sd	s1,40(sp)
    8000349c:	f04a                	sd	s2,32(sp)
    8000349e:	ec4e                	sd	s3,24(sp)
    800034a0:	e852                	sd	s4,16(sp)
    800034a2:	e456                	sd	s5,8(sp)
    800034a4:	e05a                	sd	s6,0(sp)
    800034a6:	0080                	addi	s0,sp,64
    800034a8:	8b2a                	mv	s6,a0
    800034aa:	00016a97          	auipc	s5,0x16
    800034ae:	3a6a8a93          	addi	s5,s5,934 # 80019850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b4:	00016997          	auipc	s3,0x16
    800034b8:	36c98993          	addi	s3,s3,876 # 80019820 <log>
    800034bc:	a035                	j	800034e8 <install_trans+0x60>
      bunpin(dbuf);
    800034be:	8526                	mv	a0,s1
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	166080e7          	jalr	358(ra) # 80002626 <bunpin>
    brelse(lbuf);
    800034c8:	854a                	mv	a0,s2
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	082080e7          	jalr	130(ra) # 8000254c <brelse>
    brelse(dbuf);
    800034d2:	8526                	mv	a0,s1
    800034d4:	fffff097          	auipc	ra,0xfffff
    800034d8:	078080e7          	jalr	120(ra) # 8000254c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034dc:	2a05                	addiw	s4,s4,1
    800034de:	0a91                	addi	s5,s5,4
    800034e0:	02c9a783          	lw	a5,44(s3)
    800034e4:	04fa5963          	bge	s4,a5,80003536 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034e8:	0189a583          	lw	a1,24(s3)
    800034ec:	014585bb          	addw	a1,a1,s4
    800034f0:	2585                	addiw	a1,a1,1
    800034f2:	0289a503          	lw	a0,40(s3)
    800034f6:	fffff097          	auipc	ra,0xfffff
    800034fa:	f26080e7          	jalr	-218(ra) # 8000241c <bread>
    800034fe:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003500:	000aa583          	lw	a1,0(s5)
    80003504:	0289a503          	lw	a0,40(s3)
    80003508:	fffff097          	auipc	ra,0xfffff
    8000350c:	f14080e7          	jalr	-236(ra) # 8000241c <bread>
    80003510:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003512:	40000613          	li	a2,1024
    80003516:	05890593          	addi	a1,s2,88
    8000351a:	05850513          	addi	a0,a0,88
    8000351e:	ffffd097          	auipc	ra,0xffffd
    80003522:	ce0080e7          	jalr	-800(ra) # 800001fe <memmove>
    bwrite(dbuf);  // write dst to disk
    80003526:	8526                	mv	a0,s1
    80003528:	fffff097          	auipc	ra,0xfffff
    8000352c:	fe6080e7          	jalr	-26(ra) # 8000250e <bwrite>
    if(recovering == 0)
    80003530:	f80b1ce3          	bnez	s6,800034c8 <install_trans+0x40>
    80003534:	b769                	j	800034be <install_trans+0x36>
}
    80003536:	70e2                	ld	ra,56(sp)
    80003538:	7442                	ld	s0,48(sp)
    8000353a:	74a2                	ld	s1,40(sp)
    8000353c:	7902                	ld	s2,32(sp)
    8000353e:	69e2                	ld	s3,24(sp)
    80003540:	6a42                	ld	s4,16(sp)
    80003542:	6aa2                	ld	s5,8(sp)
    80003544:	6b02                	ld	s6,0(sp)
    80003546:	6121                	addi	sp,sp,64
    80003548:	8082                	ret
    8000354a:	8082                	ret

000000008000354c <initlog>:
{
    8000354c:	7179                	addi	sp,sp,-48
    8000354e:	f406                	sd	ra,40(sp)
    80003550:	f022                	sd	s0,32(sp)
    80003552:	ec26                	sd	s1,24(sp)
    80003554:	e84a                	sd	s2,16(sp)
    80003556:	e44e                	sd	s3,8(sp)
    80003558:	1800                	addi	s0,sp,48
    8000355a:	892a                	mv	s2,a0
    8000355c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000355e:	00016497          	auipc	s1,0x16
    80003562:	2c248493          	addi	s1,s1,706 # 80019820 <log>
    80003566:	00005597          	auipc	a1,0x5
    8000356a:	21258593          	addi	a1,a1,530 # 80008778 <syscall_name+0x228>
    8000356e:	8526                	mv	a0,s1
    80003570:	00003097          	auipc	ra,0x3
    80003574:	c12080e7          	jalr	-1006(ra) # 80006182 <initlock>
  log.start = sb->logstart;
    80003578:	0149a583          	lw	a1,20(s3)
    8000357c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000357e:	0109a783          	lw	a5,16(s3)
    80003582:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003584:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003588:	854a                	mv	a0,s2
    8000358a:	fffff097          	auipc	ra,0xfffff
    8000358e:	e92080e7          	jalr	-366(ra) # 8000241c <bread>
  log.lh.n = lh->n;
    80003592:	4d3c                	lw	a5,88(a0)
    80003594:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003596:	02f05563          	blez	a5,800035c0 <initlog+0x74>
    8000359a:	05c50713          	addi	a4,a0,92
    8000359e:	00016697          	auipc	a3,0x16
    800035a2:	2b268693          	addi	a3,a3,690 # 80019850 <log+0x30>
    800035a6:	37fd                	addiw	a5,a5,-1
    800035a8:	1782                	slli	a5,a5,0x20
    800035aa:	9381                	srli	a5,a5,0x20
    800035ac:	078a                	slli	a5,a5,0x2
    800035ae:	06050613          	addi	a2,a0,96
    800035b2:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035b4:	4310                	lw	a2,0(a4)
    800035b6:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035b8:	0711                	addi	a4,a4,4
    800035ba:	0691                	addi	a3,a3,4
    800035bc:	fef71ce3          	bne	a4,a5,800035b4 <initlog+0x68>
  brelse(buf);
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	f8c080e7          	jalr	-116(ra) # 8000254c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035c8:	4505                	li	a0,1
    800035ca:	00000097          	auipc	ra,0x0
    800035ce:	ebe080e7          	jalr	-322(ra) # 80003488 <install_trans>
  log.lh.n = 0;
    800035d2:	00016797          	auipc	a5,0x16
    800035d6:	2607ad23          	sw	zero,634(a5) # 8001984c <log+0x2c>
  write_head(); // clear the log
    800035da:	00000097          	auipc	ra,0x0
    800035de:	e34080e7          	jalr	-460(ra) # 8000340e <write_head>
}
    800035e2:	70a2                	ld	ra,40(sp)
    800035e4:	7402                	ld	s0,32(sp)
    800035e6:	64e2                	ld	s1,24(sp)
    800035e8:	6942                	ld	s2,16(sp)
    800035ea:	69a2                	ld	s3,8(sp)
    800035ec:	6145                	addi	sp,sp,48
    800035ee:	8082                	ret

00000000800035f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	e04a                	sd	s2,0(sp)
    800035fa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035fc:	00016517          	auipc	a0,0x16
    80003600:	22450513          	addi	a0,a0,548 # 80019820 <log>
    80003604:	00003097          	auipc	ra,0x3
    80003608:	c0e080e7          	jalr	-1010(ra) # 80006212 <acquire>
  while(1){
    if(log.committing){
    8000360c:	00016497          	auipc	s1,0x16
    80003610:	21448493          	addi	s1,s1,532 # 80019820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003614:	4979                	li	s2,30
    80003616:	a039                	j	80003624 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003618:	85a6                	mv	a1,s1
    8000361a:	8526                	mv	a0,s1
    8000361c:	ffffe097          	auipc	ra,0xffffe
    80003620:	f22080e7          	jalr	-222(ra) # 8000153e <sleep>
    if(log.committing){
    80003624:	50dc                	lw	a5,36(s1)
    80003626:	fbed                	bnez	a5,80003618 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003628:	509c                	lw	a5,32(s1)
    8000362a:	0017871b          	addiw	a4,a5,1
    8000362e:	0007069b          	sext.w	a3,a4
    80003632:	0027179b          	slliw	a5,a4,0x2
    80003636:	9fb9                	addw	a5,a5,a4
    80003638:	0017979b          	slliw	a5,a5,0x1
    8000363c:	54d8                	lw	a4,44(s1)
    8000363e:	9fb9                	addw	a5,a5,a4
    80003640:	00f95963          	bge	s2,a5,80003652 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003644:	85a6                	mv	a1,s1
    80003646:	8526                	mv	a0,s1
    80003648:	ffffe097          	auipc	ra,0xffffe
    8000364c:	ef6080e7          	jalr	-266(ra) # 8000153e <sleep>
    80003650:	bfd1                	j	80003624 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003652:	00016517          	auipc	a0,0x16
    80003656:	1ce50513          	addi	a0,a0,462 # 80019820 <log>
    8000365a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	c6a080e7          	jalr	-918(ra) # 800062c6 <release>
      break;
    }
  }
}
    80003664:	60e2                	ld	ra,24(sp)
    80003666:	6442                	ld	s0,16(sp)
    80003668:	64a2                	ld	s1,8(sp)
    8000366a:	6902                	ld	s2,0(sp)
    8000366c:	6105                	addi	sp,sp,32
    8000366e:	8082                	ret

0000000080003670 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003670:	7139                	addi	sp,sp,-64
    80003672:	fc06                	sd	ra,56(sp)
    80003674:	f822                	sd	s0,48(sp)
    80003676:	f426                	sd	s1,40(sp)
    80003678:	f04a                	sd	s2,32(sp)
    8000367a:	ec4e                	sd	s3,24(sp)
    8000367c:	e852                	sd	s4,16(sp)
    8000367e:	e456                	sd	s5,8(sp)
    80003680:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003682:	00016497          	auipc	s1,0x16
    80003686:	19e48493          	addi	s1,s1,414 # 80019820 <log>
    8000368a:	8526                	mv	a0,s1
    8000368c:	00003097          	auipc	ra,0x3
    80003690:	b86080e7          	jalr	-1146(ra) # 80006212 <acquire>
  log.outstanding -= 1;
    80003694:	509c                	lw	a5,32(s1)
    80003696:	37fd                	addiw	a5,a5,-1
    80003698:	0007891b          	sext.w	s2,a5
    8000369c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000369e:	50dc                	lw	a5,36(s1)
    800036a0:	efb9                	bnez	a5,800036fe <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036a2:	06091663          	bnez	s2,8000370e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036a6:	00016497          	auipc	s1,0x16
    800036aa:	17a48493          	addi	s1,s1,378 # 80019820 <log>
    800036ae:	4785                	li	a5,1
    800036b0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	c12080e7          	jalr	-1006(ra) # 800062c6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036bc:	54dc                	lw	a5,44(s1)
    800036be:	06f04763          	bgtz	a5,8000372c <end_op+0xbc>
    acquire(&log.lock);
    800036c2:	00016497          	auipc	s1,0x16
    800036c6:	15e48493          	addi	s1,s1,350 # 80019820 <log>
    800036ca:	8526                	mv	a0,s1
    800036cc:	00003097          	auipc	ra,0x3
    800036d0:	b46080e7          	jalr	-1210(ra) # 80006212 <acquire>
    log.committing = 0;
    800036d4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d8:	8526                	mv	a0,s1
    800036da:	ffffe097          	auipc	ra,0xffffe
    800036de:	ff0080e7          	jalr	-16(ra) # 800016ca <wakeup>
    release(&log.lock);
    800036e2:	8526                	mv	a0,s1
    800036e4:	00003097          	auipc	ra,0x3
    800036e8:	be2080e7          	jalr	-1054(ra) # 800062c6 <release>
}
    800036ec:	70e2                	ld	ra,56(sp)
    800036ee:	7442                	ld	s0,48(sp)
    800036f0:	74a2                	ld	s1,40(sp)
    800036f2:	7902                	ld	s2,32(sp)
    800036f4:	69e2                	ld	s3,24(sp)
    800036f6:	6a42                	ld	s4,16(sp)
    800036f8:	6aa2                	ld	s5,8(sp)
    800036fa:	6121                	addi	sp,sp,64
    800036fc:	8082                	ret
    panic("log.committing");
    800036fe:	00005517          	auipc	a0,0x5
    80003702:	08250513          	addi	a0,a0,130 # 80008780 <syscall_name+0x230>
    80003706:	00002097          	auipc	ra,0x2
    8000370a:	5c2080e7          	jalr	1474(ra) # 80005cc8 <panic>
    wakeup(&log);
    8000370e:	00016497          	auipc	s1,0x16
    80003712:	11248493          	addi	s1,s1,274 # 80019820 <log>
    80003716:	8526                	mv	a0,s1
    80003718:	ffffe097          	auipc	ra,0xffffe
    8000371c:	fb2080e7          	jalr	-78(ra) # 800016ca <wakeup>
  release(&log.lock);
    80003720:	8526                	mv	a0,s1
    80003722:	00003097          	auipc	ra,0x3
    80003726:	ba4080e7          	jalr	-1116(ra) # 800062c6 <release>
  if(do_commit){
    8000372a:	b7c9                	j	800036ec <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000372c:	00016a97          	auipc	s5,0x16
    80003730:	124a8a93          	addi	s5,s5,292 # 80019850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003734:	00016a17          	auipc	s4,0x16
    80003738:	0eca0a13          	addi	s4,s4,236 # 80019820 <log>
    8000373c:	018a2583          	lw	a1,24(s4)
    80003740:	012585bb          	addw	a1,a1,s2
    80003744:	2585                	addiw	a1,a1,1
    80003746:	028a2503          	lw	a0,40(s4)
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	cd2080e7          	jalr	-814(ra) # 8000241c <bread>
    80003752:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003754:	000aa583          	lw	a1,0(s5)
    80003758:	028a2503          	lw	a0,40(s4)
    8000375c:	fffff097          	auipc	ra,0xfffff
    80003760:	cc0080e7          	jalr	-832(ra) # 8000241c <bread>
    80003764:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003766:	40000613          	li	a2,1024
    8000376a:	05850593          	addi	a1,a0,88
    8000376e:	05848513          	addi	a0,s1,88
    80003772:	ffffd097          	auipc	ra,0xffffd
    80003776:	a8c080e7          	jalr	-1396(ra) # 800001fe <memmove>
    bwrite(to);  // write the log
    8000377a:	8526                	mv	a0,s1
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	d92080e7          	jalr	-622(ra) # 8000250e <bwrite>
    brelse(from);
    80003784:	854e                	mv	a0,s3
    80003786:	fffff097          	auipc	ra,0xfffff
    8000378a:	dc6080e7          	jalr	-570(ra) # 8000254c <brelse>
    brelse(to);
    8000378e:	8526                	mv	a0,s1
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	dbc080e7          	jalr	-580(ra) # 8000254c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003798:	2905                	addiw	s2,s2,1
    8000379a:	0a91                	addi	s5,s5,4
    8000379c:	02ca2783          	lw	a5,44(s4)
    800037a0:	f8f94ee3          	blt	s2,a5,8000373c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	c6a080e7          	jalr	-918(ra) # 8000340e <write_head>
    install_trans(0); // Now install writes to home locations
    800037ac:	4501                	li	a0,0
    800037ae:	00000097          	auipc	ra,0x0
    800037b2:	cda080e7          	jalr	-806(ra) # 80003488 <install_trans>
    log.lh.n = 0;
    800037b6:	00016797          	auipc	a5,0x16
    800037ba:	0807ab23          	sw	zero,150(a5) # 8001984c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037be:	00000097          	auipc	ra,0x0
    800037c2:	c50080e7          	jalr	-944(ra) # 8000340e <write_head>
    800037c6:	bdf5                	j	800036c2 <end_op+0x52>

00000000800037c8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037c8:	1101                	addi	sp,sp,-32
    800037ca:	ec06                	sd	ra,24(sp)
    800037cc:	e822                	sd	s0,16(sp)
    800037ce:	e426                	sd	s1,8(sp)
    800037d0:	e04a                	sd	s2,0(sp)
    800037d2:	1000                	addi	s0,sp,32
    800037d4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037d6:	00016917          	auipc	s2,0x16
    800037da:	04a90913          	addi	s2,s2,74 # 80019820 <log>
    800037de:	854a                	mv	a0,s2
    800037e0:	00003097          	auipc	ra,0x3
    800037e4:	a32080e7          	jalr	-1486(ra) # 80006212 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037e8:	02c92603          	lw	a2,44(s2)
    800037ec:	47f5                	li	a5,29
    800037ee:	06c7c563          	blt	a5,a2,80003858 <log_write+0x90>
    800037f2:	00016797          	auipc	a5,0x16
    800037f6:	04a7a783          	lw	a5,74(a5) # 8001983c <log+0x1c>
    800037fa:	37fd                	addiw	a5,a5,-1
    800037fc:	04f65e63          	bge	a2,a5,80003858 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003800:	00016797          	auipc	a5,0x16
    80003804:	0407a783          	lw	a5,64(a5) # 80019840 <log+0x20>
    80003808:	06f05063          	blez	a5,80003868 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000380c:	4781                	li	a5,0
    8000380e:	06c05563          	blez	a2,80003878 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003812:	44cc                	lw	a1,12(s1)
    80003814:	00016717          	auipc	a4,0x16
    80003818:	03c70713          	addi	a4,a4,60 # 80019850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000381c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000381e:	4314                	lw	a3,0(a4)
    80003820:	04b68c63          	beq	a3,a1,80003878 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003824:	2785                	addiw	a5,a5,1
    80003826:	0711                	addi	a4,a4,4
    80003828:	fef61be3          	bne	a2,a5,8000381e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000382c:	0621                	addi	a2,a2,8
    8000382e:	060a                	slli	a2,a2,0x2
    80003830:	00016797          	auipc	a5,0x16
    80003834:	ff078793          	addi	a5,a5,-16 # 80019820 <log>
    80003838:	963e                	add	a2,a2,a5
    8000383a:	44dc                	lw	a5,12(s1)
    8000383c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000383e:	8526                	mv	a0,s1
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	daa080e7          	jalr	-598(ra) # 800025ea <bpin>
    log.lh.n++;
    80003848:	00016717          	auipc	a4,0x16
    8000384c:	fd870713          	addi	a4,a4,-40 # 80019820 <log>
    80003850:	575c                	lw	a5,44(a4)
    80003852:	2785                	addiw	a5,a5,1
    80003854:	d75c                	sw	a5,44(a4)
    80003856:	a835                	j	80003892 <log_write+0xca>
    panic("too big a transaction");
    80003858:	00005517          	auipc	a0,0x5
    8000385c:	f3850513          	addi	a0,a0,-200 # 80008790 <syscall_name+0x240>
    80003860:	00002097          	auipc	ra,0x2
    80003864:	468080e7          	jalr	1128(ra) # 80005cc8 <panic>
    panic("log_write outside of trans");
    80003868:	00005517          	auipc	a0,0x5
    8000386c:	f4050513          	addi	a0,a0,-192 # 800087a8 <syscall_name+0x258>
    80003870:	00002097          	auipc	ra,0x2
    80003874:	458080e7          	jalr	1112(ra) # 80005cc8 <panic>
  log.lh.block[i] = b->blockno;
    80003878:	00878713          	addi	a4,a5,8
    8000387c:	00271693          	slli	a3,a4,0x2
    80003880:	00016717          	auipc	a4,0x16
    80003884:	fa070713          	addi	a4,a4,-96 # 80019820 <log>
    80003888:	9736                	add	a4,a4,a3
    8000388a:	44d4                	lw	a3,12(s1)
    8000388c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000388e:	faf608e3          	beq	a2,a5,8000383e <log_write+0x76>
  }
  release(&log.lock);
    80003892:	00016517          	auipc	a0,0x16
    80003896:	f8e50513          	addi	a0,a0,-114 # 80019820 <log>
    8000389a:	00003097          	auipc	ra,0x3
    8000389e:	a2c080e7          	jalr	-1492(ra) # 800062c6 <release>
}
    800038a2:	60e2                	ld	ra,24(sp)
    800038a4:	6442                	ld	s0,16(sp)
    800038a6:	64a2                	ld	s1,8(sp)
    800038a8:	6902                	ld	s2,0(sp)
    800038aa:	6105                	addi	sp,sp,32
    800038ac:	8082                	ret

00000000800038ae <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038ae:	1101                	addi	sp,sp,-32
    800038b0:	ec06                	sd	ra,24(sp)
    800038b2:	e822                	sd	s0,16(sp)
    800038b4:	e426                	sd	s1,8(sp)
    800038b6:	e04a                	sd	s2,0(sp)
    800038b8:	1000                	addi	s0,sp,32
    800038ba:	84aa                	mv	s1,a0
    800038bc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038be:	00005597          	auipc	a1,0x5
    800038c2:	f0a58593          	addi	a1,a1,-246 # 800087c8 <syscall_name+0x278>
    800038c6:	0521                	addi	a0,a0,8
    800038c8:	00003097          	auipc	ra,0x3
    800038cc:	8ba080e7          	jalr	-1862(ra) # 80006182 <initlock>
  lk->name = name;
    800038d0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038d4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d8:	0204a423          	sw	zero,40(s1)
}
    800038dc:	60e2                	ld	ra,24(sp)
    800038de:	6442                	ld	s0,16(sp)
    800038e0:	64a2                	ld	s1,8(sp)
    800038e2:	6902                	ld	s2,0(sp)
    800038e4:	6105                	addi	sp,sp,32
    800038e6:	8082                	ret

00000000800038e8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038e8:	1101                	addi	sp,sp,-32
    800038ea:	ec06                	sd	ra,24(sp)
    800038ec:	e822                	sd	s0,16(sp)
    800038ee:	e426                	sd	s1,8(sp)
    800038f0:	e04a                	sd	s2,0(sp)
    800038f2:	1000                	addi	s0,sp,32
    800038f4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f6:	00850913          	addi	s2,a0,8
    800038fa:	854a                	mv	a0,s2
    800038fc:	00003097          	auipc	ra,0x3
    80003900:	916080e7          	jalr	-1770(ra) # 80006212 <acquire>
  while (lk->locked) {
    80003904:	409c                	lw	a5,0(s1)
    80003906:	cb89                	beqz	a5,80003918 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003908:	85ca                	mv	a1,s2
    8000390a:	8526                	mv	a0,s1
    8000390c:	ffffe097          	auipc	ra,0xffffe
    80003910:	c32080e7          	jalr	-974(ra) # 8000153e <sleep>
  while (lk->locked) {
    80003914:	409c                	lw	a5,0(s1)
    80003916:	fbed                	bnez	a5,80003908 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003918:	4785                	li	a5,1
    8000391a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000391c:	ffffd097          	auipc	ra,0xffffd
    80003920:	552080e7          	jalr	1362(ra) # 80000e6e <myproc>
    80003924:	591c                	lw	a5,48(a0)
    80003926:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003928:	854a                	mv	a0,s2
    8000392a:	00003097          	auipc	ra,0x3
    8000392e:	99c080e7          	jalr	-1636(ra) # 800062c6 <release>
}
    80003932:	60e2                	ld	ra,24(sp)
    80003934:	6442                	ld	s0,16(sp)
    80003936:	64a2                	ld	s1,8(sp)
    80003938:	6902                	ld	s2,0(sp)
    8000393a:	6105                	addi	sp,sp,32
    8000393c:	8082                	ret

000000008000393e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000393e:	1101                	addi	sp,sp,-32
    80003940:	ec06                	sd	ra,24(sp)
    80003942:	e822                	sd	s0,16(sp)
    80003944:	e426                	sd	s1,8(sp)
    80003946:	e04a                	sd	s2,0(sp)
    80003948:	1000                	addi	s0,sp,32
    8000394a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000394c:	00850913          	addi	s2,a0,8
    80003950:	854a                	mv	a0,s2
    80003952:	00003097          	auipc	ra,0x3
    80003956:	8c0080e7          	jalr	-1856(ra) # 80006212 <acquire>
  lk->locked = 0;
    8000395a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000395e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003962:	8526                	mv	a0,s1
    80003964:	ffffe097          	auipc	ra,0xffffe
    80003968:	d66080e7          	jalr	-666(ra) # 800016ca <wakeup>
  release(&lk->lk);
    8000396c:	854a                	mv	a0,s2
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	958080e7          	jalr	-1704(ra) # 800062c6 <release>
}
    80003976:	60e2                	ld	ra,24(sp)
    80003978:	6442                	ld	s0,16(sp)
    8000397a:	64a2                	ld	s1,8(sp)
    8000397c:	6902                	ld	s2,0(sp)
    8000397e:	6105                	addi	sp,sp,32
    80003980:	8082                	ret

0000000080003982 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003982:	7179                	addi	sp,sp,-48
    80003984:	f406                	sd	ra,40(sp)
    80003986:	f022                	sd	s0,32(sp)
    80003988:	ec26                	sd	s1,24(sp)
    8000398a:	e84a                	sd	s2,16(sp)
    8000398c:	e44e                	sd	s3,8(sp)
    8000398e:	1800                	addi	s0,sp,48
    80003990:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003992:	00850913          	addi	s2,a0,8
    80003996:	854a                	mv	a0,s2
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	87a080e7          	jalr	-1926(ra) # 80006212 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039a0:	409c                	lw	a5,0(s1)
    800039a2:	ef99                	bnez	a5,800039c0 <holdingsleep+0x3e>
    800039a4:	4481                	li	s1,0
  release(&lk->lk);
    800039a6:	854a                	mv	a0,s2
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	91e080e7          	jalr	-1762(ra) # 800062c6 <release>
  return r;
}
    800039b0:	8526                	mv	a0,s1
    800039b2:	70a2                	ld	ra,40(sp)
    800039b4:	7402                	ld	s0,32(sp)
    800039b6:	64e2                	ld	s1,24(sp)
    800039b8:	6942                	ld	s2,16(sp)
    800039ba:	69a2                	ld	s3,8(sp)
    800039bc:	6145                	addi	sp,sp,48
    800039be:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039c0:	0284a983          	lw	s3,40(s1)
    800039c4:	ffffd097          	auipc	ra,0xffffd
    800039c8:	4aa080e7          	jalr	1194(ra) # 80000e6e <myproc>
    800039cc:	5904                	lw	s1,48(a0)
    800039ce:	413484b3          	sub	s1,s1,s3
    800039d2:	0014b493          	seqz	s1,s1
    800039d6:	bfc1                	j	800039a6 <holdingsleep+0x24>

00000000800039d8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039d8:	1141                	addi	sp,sp,-16
    800039da:	e406                	sd	ra,8(sp)
    800039dc:	e022                	sd	s0,0(sp)
    800039de:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039e0:	00005597          	auipc	a1,0x5
    800039e4:	df858593          	addi	a1,a1,-520 # 800087d8 <syscall_name+0x288>
    800039e8:	00016517          	auipc	a0,0x16
    800039ec:	f8050513          	addi	a0,a0,-128 # 80019968 <ftable>
    800039f0:	00002097          	auipc	ra,0x2
    800039f4:	792080e7          	jalr	1938(ra) # 80006182 <initlock>
}
    800039f8:	60a2                	ld	ra,8(sp)
    800039fa:	6402                	ld	s0,0(sp)
    800039fc:	0141                	addi	sp,sp,16
    800039fe:	8082                	ret

0000000080003a00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a00:	1101                	addi	sp,sp,-32
    80003a02:	ec06                	sd	ra,24(sp)
    80003a04:	e822                	sd	s0,16(sp)
    80003a06:	e426                	sd	s1,8(sp)
    80003a08:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a0a:	00016517          	auipc	a0,0x16
    80003a0e:	f5e50513          	addi	a0,a0,-162 # 80019968 <ftable>
    80003a12:	00003097          	auipc	ra,0x3
    80003a16:	800080e7          	jalr	-2048(ra) # 80006212 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a1a:	00016497          	auipc	s1,0x16
    80003a1e:	f6648493          	addi	s1,s1,-154 # 80019980 <ftable+0x18>
    80003a22:	00017717          	auipc	a4,0x17
    80003a26:	efe70713          	addi	a4,a4,-258 # 8001a920 <ftable+0xfb8>
    if(f->ref == 0){
    80003a2a:	40dc                	lw	a5,4(s1)
    80003a2c:	cf99                	beqz	a5,80003a4a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a2e:	02848493          	addi	s1,s1,40
    80003a32:	fee49ce3          	bne	s1,a4,80003a2a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a36:	00016517          	auipc	a0,0x16
    80003a3a:	f3250513          	addi	a0,a0,-206 # 80019968 <ftable>
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	888080e7          	jalr	-1912(ra) # 800062c6 <release>
  return 0;
    80003a46:	4481                	li	s1,0
    80003a48:	a819                	j	80003a5e <filealloc+0x5e>
      f->ref = 1;
    80003a4a:	4785                	li	a5,1
    80003a4c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a4e:	00016517          	auipc	a0,0x16
    80003a52:	f1a50513          	addi	a0,a0,-230 # 80019968 <ftable>
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	870080e7          	jalr	-1936(ra) # 800062c6 <release>
}
    80003a5e:	8526                	mv	a0,s1
    80003a60:	60e2                	ld	ra,24(sp)
    80003a62:	6442                	ld	s0,16(sp)
    80003a64:	64a2                	ld	s1,8(sp)
    80003a66:	6105                	addi	sp,sp,32
    80003a68:	8082                	ret

0000000080003a6a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a6a:	1101                	addi	sp,sp,-32
    80003a6c:	ec06                	sd	ra,24(sp)
    80003a6e:	e822                	sd	s0,16(sp)
    80003a70:	e426                	sd	s1,8(sp)
    80003a72:	1000                	addi	s0,sp,32
    80003a74:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a76:	00016517          	auipc	a0,0x16
    80003a7a:	ef250513          	addi	a0,a0,-270 # 80019968 <ftable>
    80003a7e:	00002097          	auipc	ra,0x2
    80003a82:	794080e7          	jalr	1940(ra) # 80006212 <acquire>
  if(f->ref < 1)
    80003a86:	40dc                	lw	a5,4(s1)
    80003a88:	02f05263          	blez	a5,80003aac <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a8c:	2785                	addiw	a5,a5,1
    80003a8e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a90:	00016517          	auipc	a0,0x16
    80003a94:	ed850513          	addi	a0,a0,-296 # 80019968 <ftable>
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	82e080e7          	jalr	-2002(ra) # 800062c6 <release>
  return f;
}
    80003aa0:	8526                	mv	a0,s1
    80003aa2:	60e2                	ld	ra,24(sp)
    80003aa4:	6442                	ld	s0,16(sp)
    80003aa6:	64a2                	ld	s1,8(sp)
    80003aa8:	6105                	addi	sp,sp,32
    80003aaa:	8082                	ret
    panic("filedup");
    80003aac:	00005517          	auipc	a0,0x5
    80003ab0:	d3450513          	addi	a0,a0,-716 # 800087e0 <syscall_name+0x290>
    80003ab4:	00002097          	auipc	ra,0x2
    80003ab8:	214080e7          	jalr	532(ra) # 80005cc8 <panic>

0000000080003abc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003abc:	7139                	addi	sp,sp,-64
    80003abe:	fc06                	sd	ra,56(sp)
    80003ac0:	f822                	sd	s0,48(sp)
    80003ac2:	f426                	sd	s1,40(sp)
    80003ac4:	f04a                	sd	s2,32(sp)
    80003ac6:	ec4e                	sd	s3,24(sp)
    80003ac8:	e852                	sd	s4,16(sp)
    80003aca:	e456                	sd	s5,8(sp)
    80003acc:	0080                	addi	s0,sp,64
    80003ace:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ad0:	00016517          	auipc	a0,0x16
    80003ad4:	e9850513          	addi	a0,a0,-360 # 80019968 <ftable>
    80003ad8:	00002097          	auipc	ra,0x2
    80003adc:	73a080e7          	jalr	1850(ra) # 80006212 <acquire>
  if(f->ref < 1)
    80003ae0:	40dc                	lw	a5,4(s1)
    80003ae2:	06f05163          	blez	a5,80003b44 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ae6:	37fd                	addiw	a5,a5,-1
    80003ae8:	0007871b          	sext.w	a4,a5
    80003aec:	c0dc                	sw	a5,4(s1)
    80003aee:	06e04363          	bgtz	a4,80003b54 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003af2:	0004a903          	lw	s2,0(s1)
    80003af6:	0094ca83          	lbu	s5,9(s1)
    80003afa:	0104ba03          	ld	s4,16(s1)
    80003afe:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b02:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b06:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b0a:	00016517          	auipc	a0,0x16
    80003b0e:	e5e50513          	addi	a0,a0,-418 # 80019968 <ftable>
    80003b12:	00002097          	auipc	ra,0x2
    80003b16:	7b4080e7          	jalr	1972(ra) # 800062c6 <release>

  if(ff.type == FD_PIPE){
    80003b1a:	4785                	li	a5,1
    80003b1c:	04f90d63          	beq	s2,a5,80003b76 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b20:	3979                	addiw	s2,s2,-2
    80003b22:	4785                	li	a5,1
    80003b24:	0527e063          	bltu	a5,s2,80003b64 <fileclose+0xa8>
    begin_op();
    80003b28:	00000097          	auipc	ra,0x0
    80003b2c:	ac8080e7          	jalr	-1336(ra) # 800035f0 <begin_op>
    iput(ff.ip);
    80003b30:	854e                	mv	a0,s3
    80003b32:	fffff097          	auipc	ra,0xfffff
    80003b36:	2a6080e7          	jalr	678(ra) # 80002dd8 <iput>
    end_op();
    80003b3a:	00000097          	auipc	ra,0x0
    80003b3e:	b36080e7          	jalr	-1226(ra) # 80003670 <end_op>
    80003b42:	a00d                	j	80003b64 <fileclose+0xa8>
    panic("fileclose");
    80003b44:	00005517          	auipc	a0,0x5
    80003b48:	ca450513          	addi	a0,a0,-860 # 800087e8 <syscall_name+0x298>
    80003b4c:	00002097          	auipc	ra,0x2
    80003b50:	17c080e7          	jalr	380(ra) # 80005cc8 <panic>
    release(&ftable.lock);
    80003b54:	00016517          	auipc	a0,0x16
    80003b58:	e1450513          	addi	a0,a0,-492 # 80019968 <ftable>
    80003b5c:	00002097          	auipc	ra,0x2
    80003b60:	76a080e7          	jalr	1898(ra) # 800062c6 <release>
  }
}
    80003b64:	70e2                	ld	ra,56(sp)
    80003b66:	7442                	ld	s0,48(sp)
    80003b68:	74a2                	ld	s1,40(sp)
    80003b6a:	7902                	ld	s2,32(sp)
    80003b6c:	69e2                	ld	s3,24(sp)
    80003b6e:	6a42                	ld	s4,16(sp)
    80003b70:	6aa2                	ld	s5,8(sp)
    80003b72:	6121                	addi	sp,sp,64
    80003b74:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b76:	85d6                	mv	a1,s5
    80003b78:	8552                	mv	a0,s4
    80003b7a:	00000097          	auipc	ra,0x0
    80003b7e:	34c080e7          	jalr	844(ra) # 80003ec6 <pipeclose>
    80003b82:	b7cd                	j	80003b64 <fileclose+0xa8>

0000000080003b84 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b84:	715d                	addi	sp,sp,-80
    80003b86:	e486                	sd	ra,72(sp)
    80003b88:	e0a2                	sd	s0,64(sp)
    80003b8a:	fc26                	sd	s1,56(sp)
    80003b8c:	f84a                	sd	s2,48(sp)
    80003b8e:	f44e                	sd	s3,40(sp)
    80003b90:	0880                	addi	s0,sp,80
    80003b92:	84aa                	mv	s1,a0
    80003b94:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b96:	ffffd097          	auipc	ra,0xffffd
    80003b9a:	2d8080e7          	jalr	728(ra) # 80000e6e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b9e:	409c                	lw	a5,0(s1)
    80003ba0:	37f9                	addiw	a5,a5,-2
    80003ba2:	4705                	li	a4,1
    80003ba4:	04f76763          	bltu	a4,a5,80003bf2 <filestat+0x6e>
    80003ba8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003baa:	6c88                	ld	a0,24(s1)
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	072080e7          	jalr	114(ra) # 80002c1e <ilock>
    stati(f->ip, &st);
    80003bb4:	fb840593          	addi	a1,s0,-72
    80003bb8:	6c88                	ld	a0,24(s1)
    80003bba:	fffff097          	auipc	ra,0xfffff
    80003bbe:	2ee080e7          	jalr	750(ra) # 80002ea8 <stati>
    iunlock(f->ip);
    80003bc2:	6c88                	ld	a0,24(s1)
    80003bc4:	fffff097          	auipc	ra,0xfffff
    80003bc8:	11c080e7          	jalr	284(ra) # 80002ce0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bcc:	46e1                	li	a3,24
    80003bce:	fb840613          	addi	a2,s0,-72
    80003bd2:	85ce                	mv	a1,s3
    80003bd4:	05093503          	ld	a0,80(s2)
    80003bd8:	ffffd097          	auipc	ra,0xffffd
    80003bdc:	f58080e7          	jalr	-168(ra) # 80000b30 <copyout>
    80003be0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003be4:	60a6                	ld	ra,72(sp)
    80003be6:	6406                	ld	s0,64(sp)
    80003be8:	74e2                	ld	s1,56(sp)
    80003bea:	7942                	ld	s2,48(sp)
    80003bec:	79a2                	ld	s3,40(sp)
    80003bee:	6161                	addi	sp,sp,80
    80003bf0:	8082                	ret
  return -1;
    80003bf2:	557d                	li	a0,-1
    80003bf4:	bfc5                	j	80003be4 <filestat+0x60>

0000000080003bf6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bf6:	7179                	addi	sp,sp,-48
    80003bf8:	f406                	sd	ra,40(sp)
    80003bfa:	f022                	sd	s0,32(sp)
    80003bfc:	ec26                	sd	s1,24(sp)
    80003bfe:	e84a                	sd	s2,16(sp)
    80003c00:	e44e                	sd	s3,8(sp)
    80003c02:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c04:	00854783          	lbu	a5,8(a0)
    80003c08:	c3d5                	beqz	a5,80003cac <fileread+0xb6>
    80003c0a:	84aa                	mv	s1,a0
    80003c0c:	89ae                	mv	s3,a1
    80003c0e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c10:	411c                	lw	a5,0(a0)
    80003c12:	4705                	li	a4,1
    80003c14:	04e78963          	beq	a5,a4,80003c66 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c18:	470d                	li	a4,3
    80003c1a:	04e78d63          	beq	a5,a4,80003c74 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c1e:	4709                	li	a4,2
    80003c20:	06e79e63          	bne	a5,a4,80003c9c <fileread+0xa6>
    ilock(f->ip);
    80003c24:	6d08                	ld	a0,24(a0)
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	ff8080e7          	jalr	-8(ra) # 80002c1e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c2e:	874a                	mv	a4,s2
    80003c30:	5094                	lw	a3,32(s1)
    80003c32:	864e                	mv	a2,s3
    80003c34:	4585                	li	a1,1
    80003c36:	6c88                	ld	a0,24(s1)
    80003c38:	fffff097          	auipc	ra,0xfffff
    80003c3c:	29a080e7          	jalr	666(ra) # 80002ed2 <readi>
    80003c40:	892a                	mv	s2,a0
    80003c42:	00a05563          	blez	a0,80003c4c <fileread+0x56>
      f->off += r;
    80003c46:	509c                	lw	a5,32(s1)
    80003c48:	9fa9                	addw	a5,a5,a0
    80003c4a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c4c:	6c88                	ld	a0,24(s1)
    80003c4e:	fffff097          	auipc	ra,0xfffff
    80003c52:	092080e7          	jalr	146(ra) # 80002ce0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c56:	854a                	mv	a0,s2
    80003c58:	70a2                	ld	ra,40(sp)
    80003c5a:	7402                	ld	s0,32(sp)
    80003c5c:	64e2                	ld	s1,24(sp)
    80003c5e:	6942                	ld	s2,16(sp)
    80003c60:	69a2                	ld	s3,8(sp)
    80003c62:	6145                	addi	sp,sp,48
    80003c64:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c66:	6908                	ld	a0,16(a0)
    80003c68:	00000097          	auipc	ra,0x0
    80003c6c:	3c8080e7          	jalr	968(ra) # 80004030 <piperead>
    80003c70:	892a                	mv	s2,a0
    80003c72:	b7d5                	j	80003c56 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c74:	02451783          	lh	a5,36(a0)
    80003c78:	03079693          	slli	a3,a5,0x30
    80003c7c:	92c1                	srli	a3,a3,0x30
    80003c7e:	4725                	li	a4,9
    80003c80:	02d76863          	bltu	a4,a3,80003cb0 <fileread+0xba>
    80003c84:	0792                	slli	a5,a5,0x4
    80003c86:	00016717          	auipc	a4,0x16
    80003c8a:	c4270713          	addi	a4,a4,-958 # 800198c8 <devsw>
    80003c8e:	97ba                	add	a5,a5,a4
    80003c90:	639c                	ld	a5,0(a5)
    80003c92:	c38d                	beqz	a5,80003cb4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c94:	4505                	li	a0,1
    80003c96:	9782                	jalr	a5
    80003c98:	892a                	mv	s2,a0
    80003c9a:	bf75                	j	80003c56 <fileread+0x60>
    panic("fileread");
    80003c9c:	00005517          	auipc	a0,0x5
    80003ca0:	b5c50513          	addi	a0,a0,-1188 # 800087f8 <syscall_name+0x2a8>
    80003ca4:	00002097          	auipc	ra,0x2
    80003ca8:	024080e7          	jalr	36(ra) # 80005cc8 <panic>
    return -1;
    80003cac:	597d                	li	s2,-1
    80003cae:	b765                	j	80003c56 <fileread+0x60>
      return -1;
    80003cb0:	597d                	li	s2,-1
    80003cb2:	b755                	j	80003c56 <fileread+0x60>
    80003cb4:	597d                	li	s2,-1
    80003cb6:	b745                	j	80003c56 <fileread+0x60>

0000000080003cb8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cb8:	715d                	addi	sp,sp,-80
    80003cba:	e486                	sd	ra,72(sp)
    80003cbc:	e0a2                	sd	s0,64(sp)
    80003cbe:	fc26                	sd	s1,56(sp)
    80003cc0:	f84a                	sd	s2,48(sp)
    80003cc2:	f44e                	sd	s3,40(sp)
    80003cc4:	f052                	sd	s4,32(sp)
    80003cc6:	ec56                	sd	s5,24(sp)
    80003cc8:	e85a                	sd	s6,16(sp)
    80003cca:	e45e                	sd	s7,8(sp)
    80003ccc:	e062                	sd	s8,0(sp)
    80003cce:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003cd0:	00954783          	lbu	a5,9(a0)
    80003cd4:	10078663          	beqz	a5,80003de0 <filewrite+0x128>
    80003cd8:	892a                	mv	s2,a0
    80003cda:	8aae                	mv	s5,a1
    80003cdc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cde:	411c                	lw	a5,0(a0)
    80003ce0:	4705                	li	a4,1
    80003ce2:	02e78263          	beq	a5,a4,80003d06 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ce6:	470d                	li	a4,3
    80003ce8:	02e78663          	beq	a5,a4,80003d14 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cec:	4709                	li	a4,2
    80003cee:	0ee79163          	bne	a5,a4,80003dd0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cf2:	0ac05d63          	blez	a2,80003dac <filewrite+0xf4>
    int i = 0;
    80003cf6:	4981                	li	s3,0
    80003cf8:	6b05                	lui	s6,0x1
    80003cfa:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cfe:	6b85                	lui	s7,0x1
    80003d00:	c00b8b9b          	addiw	s7,s7,-1024
    80003d04:	a861                	j	80003d9c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d06:	6908                	ld	a0,16(a0)
    80003d08:	00000097          	auipc	ra,0x0
    80003d0c:	22e080e7          	jalr	558(ra) # 80003f36 <pipewrite>
    80003d10:	8a2a                	mv	s4,a0
    80003d12:	a045                	j	80003db2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d14:	02451783          	lh	a5,36(a0)
    80003d18:	03079693          	slli	a3,a5,0x30
    80003d1c:	92c1                	srli	a3,a3,0x30
    80003d1e:	4725                	li	a4,9
    80003d20:	0cd76263          	bltu	a4,a3,80003de4 <filewrite+0x12c>
    80003d24:	0792                	slli	a5,a5,0x4
    80003d26:	00016717          	auipc	a4,0x16
    80003d2a:	ba270713          	addi	a4,a4,-1118 # 800198c8 <devsw>
    80003d2e:	97ba                	add	a5,a5,a4
    80003d30:	679c                	ld	a5,8(a5)
    80003d32:	cbdd                	beqz	a5,80003de8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d34:	4505                	li	a0,1
    80003d36:	9782                	jalr	a5
    80003d38:	8a2a                	mv	s4,a0
    80003d3a:	a8a5                	j	80003db2 <filewrite+0xfa>
    80003d3c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	8b0080e7          	jalr	-1872(ra) # 800035f0 <begin_op>
      ilock(f->ip);
    80003d48:	01893503          	ld	a0,24(s2)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	ed2080e7          	jalr	-302(ra) # 80002c1e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d54:	8762                	mv	a4,s8
    80003d56:	02092683          	lw	a3,32(s2)
    80003d5a:	01598633          	add	a2,s3,s5
    80003d5e:	4585                	li	a1,1
    80003d60:	01893503          	ld	a0,24(s2)
    80003d64:	fffff097          	auipc	ra,0xfffff
    80003d68:	266080e7          	jalr	614(ra) # 80002fca <writei>
    80003d6c:	84aa                	mv	s1,a0
    80003d6e:	00a05763          	blez	a0,80003d7c <filewrite+0xc4>
        f->off += r;
    80003d72:	02092783          	lw	a5,32(s2)
    80003d76:	9fa9                	addw	a5,a5,a0
    80003d78:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d7c:	01893503          	ld	a0,24(s2)
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	f60080e7          	jalr	-160(ra) # 80002ce0 <iunlock>
      end_op();
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	8e8080e7          	jalr	-1816(ra) # 80003670 <end_op>

      if(r != n1){
    80003d90:	009c1f63          	bne	s8,s1,80003dae <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d94:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d98:	0149db63          	bge	s3,s4,80003dae <filewrite+0xf6>
      int n1 = n - i;
    80003d9c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003da0:	84be                	mv	s1,a5
    80003da2:	2781                	sext.w	a5,a5
    80003da4:	f8fb5ce3          	bge	s6,a5,80003d3c <filewrite+0x84>
    80003da8:	84de                	mv	s1,s7
    80003daa:	bf49                	j	80003d3c <filewrite+0x84>
    int i = 0;
    80003dac:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003dae:	013a1f63          	bne	s4,s3,80003dcc <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003db2:	8552                	mv	a0,s4
    80003db4:	60a6                	ld	ra,72(sp)
    80003db6:	6406                	ld	s0,64(sp)
    80003db8:	74e2                	ld	s1,56(sp)
    80003dba:	7942                	ld	s2,48(sp)
    80003dbc:	79a2                	ld	s3,40(sp)
    80003dbe:	7a02                	ld	s4,32(sp)
    80003dc0:	6ae2                	ld	s5,24(sp)
    80003dc2:	6b42                	ld	s6,16(sp)
    80003dc4:	6ba2                	ld	s7,8(sp)
    80003dc6:	6c02                	ld	s8,0(sp)
    80003dc8:	6161                	addi	sp,sp,80
    80003dca:	8082                	ret
    ret = (i == n ? n : -1);
    80003dcc:	5a7d                	li	s4,-1
    80003dce:	b7d5                	j	80003db2 <filewrite+0xfa>
    panic("filewrite");
    80003dd0:	00005517          	auipc	a0,0x5
    80003dd4:	a3850513          	addi	a0,a0,-1480 # 80008808 <syscall_name+0x2b8>
    80003dd8:	00002097          	auipc	ra,0x2
    80003ddc:	ef0080e7          	jalr	-272(ra) # 80005cc8 <panic>
    return -1;
    80003de0:	5a7d                	li	s4,-1
    80003de2:	bfc1                	j	80003db2 <filewrite+0xfa>
      return -1;
    80003de4:	5a7d                	li	s4,-1
    80003de6:	b7f1                	j	80003db2 <filewrite+0xfa>
    80003de8:	5a7d                	li	s4,-1
    80003dea:	b7e1                	j	80003db2 <filewrite+0xfa>

0000000080003dec <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dec:	7179                	addi	sp,sp,-48
    80003dee:	f406                	sd	ra,40(sp)
    80003df0:	f022                	sd	s0,32(sp)
    80003df2:	ec26                	sd	s1,24(sp)
    80003df4:	e84a                	sd	s2,16(sp)
    80003df6:	e44e                	sd	s3,8(sp)
    80003df8:	e052                	sd	s4,0(sp)
    80003dfa:	1800                	addi	s0,sp,48
    80003dfc:	84aa                	mv	s1,a0
    80003dfe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e00:	0005b023          	sd	zero,0(a1)
    80003e04:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	bf8080e7          	jalr	-1032(ra) # 80003a00 <filealloc>
    80003e10:	e088                	sd	a0,0(s1)
    80003e12:	c551                	beqz	a0,80003e9e <pipealloc+0xb2>
    80003e14:	00000097          	auipc	ra,0x0
    80003e18:	bec080e7          	jalr	-1044(ra) # 80003a00 <filealloc>
    80003e1c:	00aa3023          	sd	a0,0(s4)
    80003e20:	c92d                	beqz	a0,80003e92 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e22:	ffffc097          	auipc	ra,0xffffc
    80003e26:	2f6080e7          	jalr	758(ra) # 80000118 <kalloc>
    80003e2a:	892a                	mv	s2,a0
    80003e2c:	c125                	beqz	a0,80003e8c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e2e:	4985                	li	s3,1
    80003e30:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e34:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e38:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e3c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e40:	00004597          	auipc	a1,0x4
    80003e44:	5a058593          	addi	a1,a1,1440 # 800083e0 <states.1715+0x1a0>
    80003e48:	00002097          	auipc	ra,0x2
    80003e4c:	33a080e7          	jalr	826(ra) # 80006182 <initlock>
  (*f0)->type = FD_PIPE;
    80003e50:	609c                	ld	a5,0(s1)
    80003e52:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e56:	609c                	ld	a5,0(s1)
    80003e58:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e5c:	609c                	ld	a5,0(s1)
    80003e5e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e62:	609c                	ld	a5,0(s1)
    80003e64:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e68:	000a3783          	ld	a5,0(s4)
    80003e6c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e70:	000a3783          	ld	a5,0(s4)
    80003e74:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e78:	000a3783          	ld	a5,0(s4)
    80003e7c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e80:	000a3783          	ld	a5,0(s4)
    80003e84:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e88:	4501                	li	a0,0
    80003e8a:	a025                	j	80003eb2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e8c:	6088                	ld	a0,0(s1)
    80003e8e:	e501                	bnez	a0,80003e96 <pipealloc+0xaa>
    80003e90:	a039                	j	80003e9e <pipealloc+0xb2>
    80003e92:	6088                	ld	a0,0(s1)
    80003e94:	c51d                	beqz	a0,80003ec2 <pipealloc+0xd6>
    fileclose(*f0);
    80003e96:	00000097          	auipc	ra,0x0
    80003e9a:	c26080e7          	jalr	-986(ra) # 80003abc <fileclose>
  if(*f1)
    80003e9e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ea2:	557d                	li	a0,-1
  if(*f1)
    80003ea4:	c799                	beqz	a5,80003eb2 <pipealloc+0xc6>
    fileclose(*f1);
    80003ea6:	853e                	mv	a0,a5
    80003ea8:	00000097          	auipc	ra,0x0
    80003eac:	c14080e7          	jalr	-1004(ra) # 80003abc <fileclose>
  return -1;
    80003eb0:	557d                	li	a0,-1
}
    80003eb2:	70a2                	ld	ra,40(sp)
    80003eb4:	7402                	ld	s0,32(sp)
    80003eb6:	64e2                	ld	s1,24(sp)
    80003eb8:	6942                	ld	s2,16(sp)
    80003eba:	69a2                	ld	s3,8(sp)
    80003ebc:	6a02                	ld	s4,0(sp)
    80003ebe:	6145                	addi	sp,sp,48
    80003ec0:	8082                	ret
  return -1;
    80003ec2:	557d                	li	a0,-1
    80003ec4:	b7fd                	j	80003eb2 <pipealloc+0xc6>

0000000080003ec6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ec6:	1101                	addi	sp,sp,-32
    80003ec8:	ec06                	sd	ra,24(sp)
    80003eca:	e822                	sd	s0,16(sp)
    80003ecc:	e426                	sd	s1,8(sp)
    80003ece:	e04a                	sd	s2,0(sp)
    80003ed0:	1000                	addi	s0,sp,32
    80003ed2:	84aa                	mv	s1,a0
    80003ed4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ed6:	00002097          	auipc	ra,0x2
    80003eda:	33c080e7          	jalr	828(ra) # 80006212 <acquire>
  if(writable){
    80003ede:	02090d63          	beqz	s2,80003f18 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ee2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ee6:	21848513          	addi	a0,s1,536
    80003eea:	ffffd097          	auipc	ra,0xffffd
    80003eee:	7e0080e7          	jalr	2016(ra) # 800016ca <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ef2:	2204b783          	ld	a5,544(s1)
    80003ef6:	eb95                	bnez	a5,80003f2a <pipeclose+0x64>
    release(&pi->lock);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	00002097          	auipc	ra,0x2
    80003efe:	3cc080e7          	jalr	972(ra) # 800062c6 <release>
    kfree((char*)pi);
    80003f02:	8526                	mv	a0,s1
    80003f04:	ffffc097          	auipc	ra,0xffffc
    80003f08:	118080e7          	jalr	280(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f0c:	60e2                	ld	ra,24(sp)
    80003f0e:	6442                	ld	s0,16(sp)
    80003f10:	64a2                	ld	s1,8(sp)
    80003f12:	6902                	ld	s2,0(sp)
    80003f14:	6105                	addi	sp,sp,32
    80003f16:	8082                	ret
    pi->readopen = 0;
    80003f18:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f1c:	21c48513          	addi	a0,s1,540
    80003f20:	ffffd097          	auipc	ra,0xffffd
    80003f24:	7aa080e7          	jalr	1962(ra) # 800016ca <wakeup>
    80003f28:	b7e9                	j	80003ef2 <pipeclose+0x2c>
    release(&pi->lock);
    80003f2a:	8526                	mv	a0,s1
    80003f2c:	00002097          	auipc	ra,0x2
    80003f30:	39a080e7          	jalr	922(ra) # 800062c6 <release>
}
    80003f34:	bfe1                	j	80003f0c <pipeclose+0x46>

0000000080003f36 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f36:	7159                	addi	sp,sp,-112
    80003f38:	f486                	sd	ra,104(sp)
    80003f3a:	f0a2                	sd	s0,96(sp)
    80003f3c:	eca6                	sd	s1,88(sp)
    80003f3e:	e8ca                	sd	s2,80(sp)
    80003f40:	e4ce                	sd	s3,72(sp)
    80003f42:	e0d2                	sd	s4,64(sp)
    80003f44:	fc56                	sd	s5,56(sp)
    80003f46:	f85a                	sd	s6,48(sp)
    80003f48:	f45e                	sd	s7,40(sp)
    80003f4a:	f062                	sd	s8,32(sp)
    80003f4c:	ec66                	sd	s9,24(sp)
    80003f4e:	1880                	addi	s0,sp,112
    80003f50:	84aa                	mv	s1,a0
    80003f52:	8aae                	mv	s5,a1
    80003f54:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f56:	ffffd097          	auipc	ra,0xffffd
    80003f5a:	f18080e7          	jalr	-232(ra) # 80000e6e <myproc>
    80003f5e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f60:	8526                	mv	a0,s1
    80003f62:	00002097          	auipc	ra,0x2
    80003f66:	2b0080e7          	jalr	688(ra) # 80006212 <acquire>
  while(i < n){
    80003f6a:	0d405163          	blez	s4,8000402c <pipewrite+0xf6>
    80003f6e:	8ba6                	mv	s7,s1
  int i = 0;
    80003f70:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f72:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f74:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f78:	21c48c13          	addi	s8,s1,540
    80003f7c:	a08d                	j	80003fde <pipewrite+0xa8>
      release(&pi->lock);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	00002097          	auipc	ra,0x2
    80003f84:	346080e7          	jalr	838(ra) # 800062c6 <release>
      return -1;
    80003f88:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	70a6                	ld	ra,104(sp)
    80003f8e:	7406                	ld	s0,96(sp)
    80003f90:	64e6                	ld	s1,88(sp)
    80003f92:	6946                	ld	s2,80(sp)
    80003f94:	69a6                	ld	s3,72(sp)
    80003f96:	6a06                	ld	s4,64(sp)
    80003f98:	7ae2                	ld	s5,56(sp)
    80003f9a:	7b42                	ld	s6,48(sp)
    80003f9c:	7ba2                	ld	s7,40(sp)
    80003f9e:	7c02                	ld	s8,32(sp)
    80003fa0:	6ce2                	ld	s9,24(sp)
    80003fa2:	6165                	addi	sp,sp,112
    80003fa4:	8082                	ret
      wakeup(&pi->nread);
    80003fa6:	8566                	mv	a0,s9
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	722080e7          	jalr	1826(ra) # 800016ca <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fb0:	85de                	mv	a1,s7
    80003fb2:	8562                	mv	a0,s8
    80003fb4:	ffffd097          	auipc	ra,0xffffd
    80003fb8:	58a080e7          	jalr	1418(ra) # 8000153e <sleep>
    80003fbc:	a839                	j	80003fda <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fbe:	21c4a783          	lw	a5,540(s1)
    80003fc2:	0017871b          	addiw	a4,a5,1
    80003fc6:	20e4ae23          	sw	a4,540(s1)
    80003fca:	1ff7f793          	andi	a5,a5,511
    80003fce:	97a6                	add	a5,a5,s1
    80003fd0:	f9f44703          	lbu	a4,-97(s0)
    80003fd4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fd8:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fda:	03495d63          	bge	s2,s4,80004014 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003fde:	2204a783          	lw	a5,544(s1)
    80003fe2:	dfd1                	beqz	a5,80003f7e <pipewrite+0x48>
    80003fe4:	0289a783          	lw	a5,40(s3)
    80003fe8:	fbd9                	bnez	a5,80003f7e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fea:	2184a783          	lw	a5,536(s1)
    80003fee:	21c4a703          	lw	a4,540(s1)
    80003ff2:	2007879b          	addiw	a5,a5,512
    80003ff6:	faf708e3          	beq	a4,a5,80003fa6 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ffa:	4685                	li	a3,1
    80003ffc:	01590633          	add	a2,s2,s5
    80004000:	f9f40593          	addi	a1,s0,-97
    80004004:	0509b503          	ld	a0,80(s3)
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	bb4080e7          	jalr	-1100(ra) # 80000bbc <copyin>
    80004010:	fb6517e3          	bne	a0,s6,80003fbe <pipewrite+0x88>
  wakeup(&pi->nread);
    80004014:	21848513          	addi	a0,s1,536
    80004018:	ffffd097          	auipc	ra,0xffffd
    8000401c:	6b2080e7          	jalr	1714(ra) # 800016ca <wakeup>
  release(&pi->lock);
    80004020:	8526                	mv	a0,s1
    80004022:	00002097          	auipc	ra,0x2
    80004026:	2a4080e7          	jalr	676(ra) # 800062c6 <release>
  return i;
    8000402a:	b785                	j	80003f8a <pipewrite+0x54>
  int i = 0;
    8000402c:	4901                	li	s2,0
    8000402e:	b7dd                	j	80004014 <pipewrite+0xde>

0000000080004030 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004030:	715d                	addi	sp,sp,-80
    80004032:	e486                	sd	ra,72(sp)
    80004034:	e0a2                	sd	s0,64(sp)
    80004036:	fc26                	sd	s1,56(sp)
    80004038:	f84a                	sd	s2,48(sp)
    8000403a:	f44e                	sd	s3,40(sp)
    8000403c:	f052                	sd	s4,32(sp)
    8000403e:	ec56                	sd	s5,24(sp)
    80004040:	e85a                	sd	s6,16(sp)
    80004042:	0880                	addi	s0,sp,80
    80004044:	84aa                	mv	s1,a0
    80004046:	892e                	mv	s2,a1
    80004048:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	e24080e7          	jalr	-476(ra) # 80000e6e <myproc>
    80004052:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004054:	8b26                	mv	s6,s1
    80004056:	8526                	mv	a0,s1
    80004058:	00002097          	auipc	ra,0x2
    8000405c:	1ba080e7          	jalr	442(ra) # 80006212 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004060:	2184a703          	lw	a4,536(s1)
    80004064:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004068:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000406c:	02f71463          	bne	a4,a5,80004094 <piperead+0x64>
    80004070:	2244a783          	lw	a5,548(s1)
    80004074:	c385                	beqz	a5,80004094 <piperead+0x64>
    if(pr->killed){
    80004076:	028a2783          	lw	a5,40(s4)
    8000407a:	ebc1                	bnez	a5,8000410a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000407c:	85da                	mv	a1,s6
    8000407e:	854e                	mv	a0,s3
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	4be080e7          	jalr	1214(ra) # 8000153e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004088:	2184a703          	lw	a4,536(s1)
    8000408c:	21c4a783          	lw	a5,540(s1)
    80004090:	fef700e3          	beq	a4,a5,80004070 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004094:	09505263          	blez	s5,80004118 <piperead+0xe8>
    80004098:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000409a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000409c:	2184a783          	lw	a5,536(s1)
    800040a0:	21c4a703          	lw	a4,540(s1)
    800040a4:	02f70d63          	beq	a4,a5,800040de <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040a8:	0017871b          	addiw	a4,a5,1
    800040ac:	20e4ac23          	sw	a4,536(s1)
    800040b0:	1ff7f793          	andi	a5,a5,511
    800040b4:	97a6                	add	a5,a5,s1
    800040b6:	0187c783          	lbu	a5,24(a5)
    800040ba:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040be:	4685                	li	a3,1
    800040c0:	fbf40613          	addi	a2,s0,-65
    800040c4:	85ca                	mv	a1,s2
    800040c6:	050a3503          	ld	a0,80(s4)
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	a66080e7          	jalr	-1434(ra) # 80000b30 <copyout>
    800040d2:	01650663          	beq	a0,s6,800040de <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d6:	2985                	addiw	s3,s3,1
    800040d8:	0905                	addi	s2,s2,1
    800040da:	fd3a91e3          	bne	s5,s3,8000409c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040de:	21c48513          	addi	a0,s1,540
    800040e2:	ffffd097          	auipc	ra,0xffffd
    800040e6:	5e8080e7          	jalr	1512(ra) # 800016ca <wakeup>
  release(&pi->lock);
    800040ea:	8526                	mv	a0,s1
    800040ec:	00002097          	auipc	ra,0x2
    800040f0:	1da080e7          	jalr	474(ra) # 800062c6 <release>
  return i;
}
    800040f4:	854e                	mv	a0,s3
    800040f6:	60a6                	ld	ra,72(sp)
    800040f8:	6406                	ld	s0,64(sp)
    800040fa:	74e2                	ld	s1,56(sp)
    800040fc:	7942                	ld	s2,48(sp)
    800040fe:	79a2                	ld	s3,40(sp)
    80004100:	7a02                	ld	s4,32(sp)
    80004102:	6ae2                	ld	s5,24(sp)
    80004104:	6b42                	ld	s6,16(sp)
    80004106:	6161                	addi	sp,sp,80
    80004108:	8082                	ret
      release(&pi->lock);
    8000410a:	8526                	mv	a0,s1
    8000410c:	00002097          	auipc	ra,0x2
    80004110:	1ba080e7          	jalr	442(ra) # 800062c6 <release>
      return -1;
    80004114:	59fd                	li	s3,-1
    80004116:	bff9                	j	800040f4 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004118:	4981                	li	s3,0
    8000411a:	b7d1                	j	800040de <piperead+0xae>

000000008000411c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000411c:	df010113          	addi	sp,sp,-528
    80004120:	20113423          	sd	ra,520(sp)
    80004124:	20813023          	sd	s0,512(sp)
    80004128:	ffa6                	sd	s1,504(sp)
    8000412a:	fbca                	sd	s2,496(sp)
    8000412c:	f7ce                	sd	s3,488(sp)
    8000412e:	f3d2                	sd	s4,480(sp)
    80004130:	efd6                	sd	s5,472(sp)
    80004132:	ebda                	sd	s6,464(sp)
    80004134:	e7de                	sd	s7,456(sp)
    80004136:	e3e2                	sd	s8,448(sp)
    80004138:	ff66                	sd	s9,440(sp)
    8000413a:	fb6a                	sd	s10,432(sp)
    8000413c:	f76e                	sd	s11,424(sp)
    8000413e:	0c00                	addi	s0,sp,528
    80004140:	84aa                	mv	s1,a0
    80004142:	dea43c23          	sd	a0,-520(s0)
    80004146:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	d24080e7          	jalr	-732(ra) # 80000e6e <myproc>
    80004152:	892a                	mv	s2,a0

  begin_op();
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	49c080e7          	jalr	1180(ra) # 800035f0 <begin_op>

  if((ip = namei(path)) == 0){
    8000415c:	8526                	mv	a0,s1
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	276080e7          	jalr	630(ra) # 800033d4 <namei>
    80004166:	c92d                	beqz	a0,800041d8 <exec+0xbc>
    80004168:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	ab4080e7          	jalr	-1356(ra) # 80002c1e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004172:	04000713          	li	a4,64
    80004176:	4681                	li	a3,0
    80004178:	e5040613          	addi	a2,s0,-432
    8000417c:	4581                	li	a1,0
    8000417e:	8526                	mv	a0,s1
    80004180:	fffff097          	auipc	ra,0xfffff
    80004184:	d52080e7          	jalr	-686(ra) # 80002ed2 <readi>
    80004188:	04000793          	li	a5,64
    8000418c:	00f51a63          	bne	a0,a5,800041a0 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004190:	e5042703          	lw	a4,-432(s0)
    80004194:	464c47b7          	lui	a5,0x464c4
    80004198:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000419c:	04f70463          	beq	a4,a5,800041e4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041a0:	8526                	mv	a0,s1
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	cde080e7          	jalr	-802(ra) # 80002e80 <iunlockput>
    end_op();
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	4c6080e7          	jalr	1222(ra) # 80003670 <end_op>
  }
  return -1;
    800041b2:	557d                	li	a0,-1
}
    800041b4:	20813083          	ld	ra,520(sp)
    800041b8:	20013403          	ld	s0,512(sp)
    800041bc:	74fe                	ld	s1,504(sp)
    800041be:	795e                	ld	s2,496(sp)
    800041c0:	79be                	ld	s3,488(sp)
    800041c2:	7a1e                	ld	s4,480(sp)
    800041c4:	6afe                	ld	s5,472(sp)
    800041c6:	6b5e                	ld	s6,464(sp)
    800041c8:	6bbe                	ld	s7,456(sp)
    800041ca:	6c1e                	ld	s8,448(sp)
    800041cc:	7cfa                	ld	s9,440(sp)
    800041ce:	7d5a                	ld	s10,432(sp)
    800041d0:	7dba                	ld	s11,424(sp)
    800041d2:	21010113          	addi	sp,sp,528
    800041d6:	8082                	ret
    end_op();
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	498080e7          	jalr	1176(ra) # 80003670 <end_op>
    return -1;
    800041e0:	557d                	li	a0,-1
    800041e2:	bfc9                	j	800041b4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041e4:	854a                	mv	a0,s2
    800041e6:	ffffd097          	auipc	ra,0xffffd
    800041ea:	d4c080e7          	jalr	-692(ra) # 80000f32 <proc_pagetable>
    800041ee:	8baa                	mv	s7,a0
    800041f0:	d945                	beqz	a0,800041a0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f2:	e7042983          	lw	s3,-400(s0)
    800041f6:	e8845783          	lhu	a5,-376(s0)
    800041fa:	c7ad                	beqz	a5,80004264 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041fc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041fe:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004200:	6c85                	lui	s9,0x1
    80004202:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004206:	def43823          	sd	a5,-528(s0)
    8000420a:	a42d                	j	80004434 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000420c:	00004517          	auipc	a0,0x4
    80004210:	60c50513          	addi	a0,a0,1548 # 80008818 <syscall_name+0x2c8>
    80004214:	00002097          	auipc	ra,0x2
    80004218:	ab4080e7          	jalr	-1356(ra) # 80005cc8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000421c:	8756                	mv	a4,s5
    8000421e:	012d86bb          	addw	a3,s11,s2
    80004222:	4581                	li	a1,0
    80004224:	8526                	mv	a0,s1
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	cac080e7          	jalr	-852(ra) # 80002ed2 <readi>
    8000422e:	2501                	sext.w	a0,a0
    80004230:	1aaa9963          	bne	s5,a0,800043e2 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004234:	6785                	lui	a5,0x1
    80004236:	0127893b          	addw	s2,a5,s2
    8000423a:	77fd                	lui	a5,0xfffff
    8000423c:	01478a3b          	addw	s4,a5,s4
    80004240:	1f897163          	bgeu	s2,s8,80004422 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004244:	02091593          	slli	a1,s2,0x20
    80004248:	9181                	srli	a1,a1,0x20
    8000424a:	95ea                	add	a1,a1,s10
    8000424c:	855e                	mv	a0,s7
    8000424e:	ffffc097          	auipc	ra,0xffffc
    80004252:	2de080e7          	jalr	734(ra) # 8000052c <walkaddr>
    80004256:	862a                	mv	a2,a0
    if(pa == 0)
    80004258:	d955                	beqz	a0,8000420c <exec+0xf0>
      n = PGSIZE;
    8000425a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000425c:	fd9a70e3          	bgeu	s4,s9,8000421c <exec+0x100>
      n = sz - i;
    80004260:	8ad2                	mv	s5,s4
    80004262:	bf6d                	j	8000421c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004264:	4901                	li	s2,0
  iunlockput(ip);
    80004266:	8526                	mv	a0,s1
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	c18080e7          	jalr	-1000(ra) # 80002e80 <iunlockput>
  end_op();
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	400080e7          	jalr	1024(ra) # 80003670 <end_op>
  p = myproc();
    80004278:	ffffd097          	auipc	ra,0xffffd
    8000427c:	bf6080e7          	jalr	-1034(ra) # 80000e6e <myproc>
    80004280:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004282:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004286:	6785                	lui	a5,0x1
    80004288:	17fd                	addi	a5,a5,-1
    8000428a:	993e                	add	s2,s2,a5
    8000428c:	757d                	lui	a0,0xfffff
    8000428e:	00a977b3          	and	a5,s2,a0
    80004292:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004296:	6609                	lui	a2,0x2
    80004298:	963e                	add	a2,a2,a5
    8000429a:	85be                	mv	a1,a5
    8000429c:	855e                	mv	a0,s7
    8000429e:	ffffc097          	auipc	ra,0xffffc
    800042a2:	642080e7          	jalr	1602(ra) # 800008e0 <uvmalloc>
    800042a6:	8b2a                	mv	s6,a0
  ip = 0;
    800042a8:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042aa:	12050c63          	beqz	a0,800043e2 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042ae:	75f9                	lui	a1,0xffffe
    800042b0:	95aa                	add	a1,a1,a0
    800042b2:	855e                	mv	a0,s7
    800042b4:	ffffd097          	auipc	ra,0xffffd
    800042b8:	84a080e7          	jalr	-1974(ra) # 80000afe <uvmclear>
  stackbase = sp - PGSIZE;
    800042bc:	7c7d                	lui	s8,0xfffff
    800042be:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800042c0:	e0043783          	ld	a5,-512(s0)
    800042c4:	6388                	ld	a0,0(a5)
    800042c6:	c535                	beqz	a0,80004332 <exec+0x216>
    800042c8:	e9040993          	addi	s3,s0,-368
    800042cc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042d0:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042d2:	ffffc097          	auipc	ra,0xffffc
    800042d6:	050080e7          	jalr	80(ra) # 80000322 <strlen>
    800042da:	2505                	addiw	a0,a0,1
    800042dc:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042e0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042e4:	13896363          	bltu	s2,s8,8000440a <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042e8:	e0043d83          	ld	s11,-512(s0)
    800042ec:	000dba03          	ld	s4,0(s11)
    800042f0:	8552                	mv	a0,s4
    800042f2:	ffffc097          	auipc	ra,0xffffc
    800042f6:	030080e7          	jalr	48(ra) # 80000322 <strlen>
    800042fa:	0015069b          	addiw	a3,a0,1
    800042fe:	8652                	mv	a2,s4
    80004300:	85ca                	mv	a1,s2
    80004302:	855e                	mv	a0,s7
    80004304:	ffffd097          	auipc	ra,0xffffd
    80004308:	82c080e7          	jalr	-2004(ra) # 80000b30 <copyout>
    8000430c:	10054363          	bltz	a0,80004412 <exec+0x2f6>
    ustack[argc] = sp;
    80004310:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004314:	0485                	addi	s1,s1,1
    80004316:	008d8793          	addi	a5,s11,8
    8000431a:	e0f43023          	sd	a5,-512(s0)
    8000431e:	008db503          	ld	a0,8(s11)
    80004322:	c911                	beqz	a0,80004336 <exec+0x21a>
    if(argc >= MAXARG)
    80004324:	09a1                	addi	s3,s3,8
    80004326:	fb3c96e3          	bne	s9,s3,800042d2 <exec+0x1b6>
  sz = sz1;
    8000432a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000432e:	4481                	li	s1,0
    80004330:	a84d                	j	800043e2 <exec+0x2c6>
  sp = sz;
    80004332:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004334:	4481                	li	s1,0
  ustack[argc] = 0;
    80004336:	00349793          	slli	a5,s1,0x3
    8000433a:	f9040713          	addi	a4,s0,-112
    8000433e:	97ba                	add	a5,a5,a4
    80004340:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004344:	00148693          	addi	a3,s1,1
    80004348:	068e                	slli	a3,a3,0x3
    8000434a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000434e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004352:	01897663          	bgeu	s2,s8,8000435e <exec+0x242>
  sz = sz1;
    80004356:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000435a:	4481                	li	s1,0
    8000435c:	a059                	j	800043e2 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000435e:	e9040613          	addi	a2,s0,-368
    80004362:	85ca                	mv	a1,s2
    80004364:	855e                	mv	a0,s7
    80004366:	ffffc097          	auipc	ra,0xffffc
    8000436a:	7ca080e7          	jalr	1994(ra) # 80000b30 <copyout>
    8000436e:	0a054663          	bltz	a0,8000441a <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004372:	058ab783          	ld	a5,88(s5)
    80004376:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000437a:	df843783          	ld	a5,-520(s0)
    8000437e:	0007c703          	lbu	a4,0(a5)
    80004382:	cf11                	beqz	a4,8000439e <exec+0x282>
    80004384:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004386:	02f00693          	li	a3,47
    8000438a:	a039                	j	80004398 <exec+0x27c>
      last = s+1;
    8000438c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004390:	0785                	addi	a5,a5,1
    80004392:	fff7c703          	lbu	a4,-1(a5)
    80004396:	c701                	beqz	a4,8000439e <exec+0x282>
    if(*s == '/')
    80004398:	fed71ce3          	bne	a4,a3,80004390 <exec+0x274>
    8000439c:	bfc5                	j	8000438c <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000439e:	4641                	li	a2,16
    800043a0:	df843583          	ld	a1,-520(s0)
    800043a4:	158a8513          	addi	a0,s5,344
    800043a8:	ffffc097          	auipc	ra,0xffffc
    800043ac:	f48080e7          	jalr	-184(ra) # 800002f0 <safestrcpy>
  oldpagetable = p->pagetable;
    800043b0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043b4:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800043b8:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043bc:	058ab783          	ld	a5,88(s5)
    800043c0:	e6843703          	ld	a4,-408(s0)
    800043c4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043c6:	058ab783          	ld	a5,88(s5)
    800043ca:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043ce:	85ea                	mv	a1,s10
    800043d0:	ffffd097          	auipc	ra,0xffffd
    800043d4:	bfe080e7          	jalr	-1026(ra) # 80000fce <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043d8:	0004851b          	sext.w	a0,s1
    800043dc:	bbe1                	j	800041b4 <exec+0x98>
    800043de:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043e2:	e0843583          	ld	a1,-504(s0)
    800043e6:	855e                	mv	a0,s7
    800043e8:	ffffd097          	auipc	ra,0xffffd
    800043ec:	be6080e7          	jalr	-1050(ra) # 80000fce <proc_freepagetable>
  if(ip){
    800043f0:	da0498e3          	bnez	s1,800041a0 <exec+0x84>
  return -1;
    800043f4:	557d                	li	a0,-1
    800043f6:	bb7d                	j	800041b4 <exec+0x98>
    800043f8:	e1243423          	sd	s2,-504(s0)
    800043fc:	b7dd                	j	800043e2 <exec+0x2c6>
    800043fe:	e1243423          	sd	s2,-504(s0)
    80004402:	b7c5                	j	800043e2 <exec+0x2c6>
    80004404:	e1243423          	sd	s2,-504(s0)
    80004408:	bfe9                	j	800043e2 <exec+0x2c6>
  sz = sz1;
    8000440a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000440e:	4481                	li	s1,0
    80004410:	bfc9                	j	800043e2 <exec+0x2c6>
  sz = sz1;
    80004412:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004416:	4481                	li	s1,0
    80004418:	b7e9                	j	800043e2 <exec+0x2c6>
  sz = sz1;
    8000441a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000441e:	4481                	li	s1,0
    80004420:	b7c9                	j	800043e2 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004422:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004426:	2b05                	addiw	s6,s6,1
    80004428:	0389899b          	addiw	s3,s3,56
    8000442c:	e8845783          	lhu	a5,-376(s0)
    80004430:	e2fb5be3          	bge	s6,a5,80004266 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004434:	2981                	sext.w	s3,s3
    80004436:	03800713          	li	a4,56
    8000443a:	86ce                	mv	a3,s3
    8000443c:	e1840613          	addi	a2,s0,-488
    80004440:	4581                	li	a1,0
    80004442:	8526                	mv	a0,s1
    80004444:	fffff097          	auipc	ra,0xfffff
    80004448:	a8e080e7          	jalr	-1394(ra) # 80002ed2 <readi>
    8000444c:	03800793          	li	a5,56
    80004450:	f8f517e3          	bne	a0,a5,800043de <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004454:	e1842783          	lw	a5,-488(s0)
    80004458:	4705                	li	a4,1
    8000445a:	fce796e3          	bne	a5,a4,80004426 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000445e:	e4043603          	ld	a2,-448(s0)
    80004462:	e3843783          	ld	a5,-456(s0)
    80004466:	f8f669e3          	bltu	a2,a5,800043f8 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000446a:	e2843783          	ld	a5,-472(s0)
    8000446e:	963e                	add	a2,a2,a5
    80004470:	f8f667e3          	bltu	a2,a5,800043fe <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004474:	85ca                	mv	a1,s2
    80004476:	855e                	mv	a0,s7
    80004478:	ffffc097          	auipc	ra,0xffffc
    8000447c:	468080e7          	jalr	1128(ra) # 800008e0 <uvmalloc>
    80004480:	e0a43423          	sd	a0,-504(s0)
    80004484:	d141                	beqz	a0,80004404 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004486:	e2843d03          	ld	s10,-472(s0)
    8000448a:	df043783          	ld	a5,-528(s0)
    8000448e:	00fd77b3          	and	a5,s10,a5
    80004492:	fba1                	bnez	a5,800043e2 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004494:	e2042d83          	lw	s11,-480(s0)
    80004498:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000449c:	f80c03e3          	beqz	s8,80004422 <exec+0x306>
    800044a0:	8a62                	mv	s4,s8
    800044a2:	4901                	li	s2,0
    800044a4:	b345                	j	80004244 <exec+0x128>

00000000800044a6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044a6:	7179                	addi	sp,sp,-48
    800044a8:	f406                	sd	ra,40(sp)
    800044aa:	f022                	sd	s0,32(sp)
    800044ac:	ec26                	sd	s1,24(sp)
    800044ae:	e84a                	sd	s2,16(sp)
    800044b0:	1800                	addi	s0,sp,48
    800044b2:	892e                	mv	s2,a1
    800044b4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800044b6:	fdc40593          	addi	a1,s0,-36
    800044ba:	ffffe097          	auipc	ra,0xffffe
    800044be:	ac8080e7          	jalr	-1336(ra) # 80001f82 <argint>
    800044c2:	04054063          	bltz	a0,80004502 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044c6:	fdc42703          	lw	a4,-36(s0)
    800044ca:	47bd                	li	a5,15
    800044cc:	02e7ed63          	bltu	a5,a4,80004506 <argfd+0x60>
    800044d0:	ffffd097          	auipc	ra,0xffffd
    800044d4:	99e080e7          	jalr	-1634(ra) # 80000e6e <myproc>
    800044d8:	fdc42703          	lw	a4,-36(s0)
    800044dc:	01a70793          	addi	a5,a4,26
    800044e0:	078e                	slli	a5,a5,0x3
    800044e2:	953e                	add	a0,a0,a5
    800044e4:	611c                	ld	a5,0(a0)
    800044e6:	c395                	beqz	a5,8000450a <argfd+0x64>
    return -1;
  if(pfd)
    800044e8:	00090463          	beqz	s2,800044f0 <argfd+0x4a>
    *pfd = fd;
    800044ec:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044f0:	4501                	li	a0,0
  if(pf)
    800044f2:	c091                	beqz	s1,800044f6 <argfd+0x50>
    *pf = f;
    800044f4:	e09c                	sd	a5,0(s1)
}
    800044f6:	70a2                	ld	ra,40(sp)
    800044f8:	7402                	ld	s0,32(sp)
    800044fa:	64e2                	ld	s1,24(sp)
    800044fc:	6942                	ld	s2,16(sp)
    800044fe:	6145                	addi	sp,sp,48
    80004500:	8082                	ret
    return -1;
    80004502:	557d                	li	a0,-1
    80004504:	bfcd                	j	800044f6 <argfd+0x50>
    return -1;
    80004506:	557d                	li	a0,-1
    80004508:	b7fd                	j	800044f6 <argfd+0x50>
    8000450a:	557d                	li	a0,-1
    8000450c:	b7ed                	j	800044f6 <argfd+0x50>

000000008000450e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000450e:	1101                	addi	sp,sp,-32
    80004510:	ec06                	sd	ra,24(sp)
    80004512:	e822                	sd	s0,16(sp)
    80004514:	e426                	sd	s1,8(sp)
    80004516:	1000                	addi	s0,sp,32
    80004518:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000451a:	ffffd097          	auipc	ra,0xffffd
    8000451e:	954080e7          	jalr	-1708(ra) # 80000e6e <myproc>
    80004522:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004524:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    80004528:	4501                	li	a0,0
    8000452a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000452c:	6398                	ld	a4,0(a5)
    8000452e:	cb19                	beqz	a4,80004544 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004530:	2505                	addiw	a0,a0,1
    80004532:	07a1                	addi	a5,a5,8
    80004534:	fed51ce3          	bne	a0,a3,8000452c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004538:	557d                	li	a0,-1
}
    8000453a:	60e2                	ld	ra,24(sp)
    8000453c:	6442                	ld	s0,16(sp)
    8000453e:	64a2                	ld	s1,8(sp)
    80004540:	6105                	addi	sp,sp,32
    80004542:	8082                	ret
      p->ofile[fd] = f;
    80004544:	01a50793          	addi	a5,a0,26
    80004548:	078e                	slli	a5,a5,0x3
    8000454a:	963e                	add	a2,a2,a5
    8000454c:	e204                	sd	s1,0(a2)
      return fd;
    8000454e:	b7f5                	j	8000453a <fdalloc+0x2c>

0000000080004550 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004550:	715d                	addi	sp,sp,-80
    80004552:	e486                	sd	ra,72(sp)
    80004554:	e0a2                	sd	s0,64(sp)
    80004556:	fc26                	sd	s1,56(sp)
    80004558:	f84a                	sd	s2,48(sp)
    8000455a:	f44e                	sd	s3,40(sp)
    8000455c:	f052                	sd	s4,32(sp)
    8000455e:	ec56                	sd	s5,24(sp)
    80004560:	0880                	addi	s0,sp,80
    80004562:	89ae                	mv	s3,a1
    80004564:	8ab2                	mv	s5,a2
    80004566:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004568:	fb040593          	addi	a1,s0,-80
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	e86080e7          	jalr	-378(ra) # 800033f2 <nameiparent>
    80004574:	892a                	mv	s2,a0
    80004576:	12050f63          	beqz	a0,800046b4 <create+0x164>
    return 0;

  ilock(dp);
    8000457a:	ffffe097          	auipc	ra,0xffffe
    8000457e:	6a4080e7          	jalr	1700(ra) # 80002c1e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004582:	4601                	li	a2,0
    80004584:	fb040593          	addi	a1,s0,-80
    80004588:	854a                	mv	a0,s2
    8000458a:	fffff097          	auipc	ra,0xfffff
    8000458e:	b78080e7          	jalr	-1160(ra) # 80003102 <dirlookup>
    80004592:	84aa                	mv	s1,a0
    80004594:	c921                	beqz	a0,800045e4 <create+0x94>
    iunlockput(dp);
    80004596:	854a                	mv	a0,s2
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	8e8080e7          	jalr	-1816(ra) # 80002e80 <iunlockput>
    ilock(ip);
    800045a0:	8526                	mv	a0,s1
    800045a2:	ffffe097          	auipc	ra,0xffffe
    800045a6:	67c080e7          	jalr	1660(ra) # 80002c1e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045aa:	2981                	sext.w	s3,s3
    800045ac:	4789                	li	a5,2
    800045ae:	02f99463          	bne	s3,a5,800045d6 <create+0x86>
    800045b2:	0444d783          	lhu	a5,68(s1)
    800045b6:	37f9                	addiw	a5,a5,-2
    800045b8:	17c2                	slli	a5,a5,0x30
    800045ba:	93c1                	srli	a5,a5,0x30
    800045bc:	4705                	li	a4,1
    800045be:	00f76c63          	bltu	a4,a5,800045d6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045c2:	8526                	mv	a0,s1
    800045c4:	60a6                	ld	ra,72(sp)
    800045c6:	6406                	ld	s0,64(sp)
    800045c8:	74e2                	ld	s1,56(sp)
    800045ca:	7942                	ld	s2,48(sp)
    800045cc:	79a2                	ld	s3,40(sp)
    800045ce:	7a02                	ld	s4,32(sp)
    800045d0:	6ae2                	ld	s5,24(sp)
    800045d2:	6161                	addi	sp,sp,80
    800045d4:	8082                	ret
    iunlockput(ip);
    800045d6:	8526                	mv	a0,s1
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	8a8080e7          	jalr	-1880(ra) # 80002e80 <iunlockput>
    return 0;
    800045e0:	4481                	li	s1,0
    800045e2:	b7c5                	j	800045c2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045e4:	85ce                	mv	a1,s3
    800045e6:	00092503          	lw	a0,0(s2)
    800045ea:	ffffe097          	auipc	ra,0xffffe
    800045ee:	49c080e7          	jalr	1180(ra) # 80002a86 <ialloc>
    800045f2:	84aa                	mv	s1,a0
    800045f4:	c529                	beqz	a0,8000463e <create+0xee>
  ilock(ip);
    800045f6:	ffffe097          	auipc	ra,0xffffe
    800045fa:	628080e7          	jalr	1576(ra) # 80002c1e <ilock>
  ip->major = major;
    800045fe:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004602:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004606:	4785                	li	a5,1
    80004608:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000460c:	8526                	mv	a0,s1
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	546080e7          	jalr	1350(ra) # 80002b54 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004616:	2981                	sext.w	s3,s3
    80004618:	4785                	li	a5,1
    8000461a:	02f98a63          	beq	s3,a5,8000464e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000461e:	40d0                	lw	a2,4(s1)
    80004620:	fb040593          	addi	a1,s0,-80
    80004624:	854a                	mv	a0,s2
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	cec080e7          	jalr	-788(ra) # 80003312 <dirlink>
    8000462e:	06054b63          	bltz	a0,800046a4 <create+0x154>
  iunlockput(dp);
    80004632:	854a                	mv	a0,s2
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	84c080e7          	jalr	-1972(ra) # 80002e80 <iunlockput>
  return ip;
    8000463c:	b759                	j	800045c2 <create+0x72>
    panic("create: ialloc");
    8000463e:	00004517          	auipc	a0,0x4
    80004642:	1fa50513          	addi	a0,a0,506 # 80008838 <syscall_name+0x2e8>
    80004646:	00001097          	auipc	ra,0x1
    8000464a:	682080e7          	jalr	1666(ra) # 80005cc8 <panic>
    dp->nlink++;  // for ".."
    8000464e:	04a95783          	lhu	a5,74(s2)
    80004652:	2785                	addiw	a5,a5,1
    80004654:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004658:	854a                	mv	a0,s2
    8000465a:	ffffe097          	auipc	ra,0xffffe
    8000465e:	4fa080e7          	jalr	1274(ra) # 80002b54 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004662:	40d0                	lw	a2,4(s1)
    80004664:	00004597          	auipc	a1,0x4
    80004668:	1e458593          	addi	a1,a1,484 # 80008848 <syscall_name+0x2f8>
    8000466c:	8526                	mv	a0,s1
    8000466e:	fffff097          	auipc	ra,0xfffff
    80004672:	ca4080e7          	jalr	-860(ra) # 80003312 <dirlink>
    80004676:	00054f63          	bltz	a0,80004694 <create+0x144>
    8000467a:	00492603          	lw	a2,4(s2)
    8000467e:	00004597          	auipc	a1,0x4
    80004682:	1d258593          	addi	a1,a1,466 # 80008850 <syscall_name+0x300>
    80004686:	8526                	mv	a0,s1
    80004688:	fffff097          	auipc	ra,0xfffff
    8000468c:	c8a080e7          	jalr	-886(ra) # 80003312 <dirlink>
    80004690:	f80557e3          	bgez	a0,8000461e <create+0xce>
      panic("create dots");
    80004694:	00004517          	auipc	a0,0x4
    80004698:	1c450513          	addi	a0,a0,452 # 80008858 <syscall_name+0x308>
    8000469c:	00001097          	auipc	ra,0x1
    800046a0:	62c080e7          	jalr	1580(ra) # 80005cc8 <panic>
    panic("create: dirlink");
    800046a4:	00004517          	auipc	a0,0x4
    800046a8:	1c450513          	addi	a0,a0,452 # 80008868 <syscall_name+0x318>
    800046ac:	00001097          	auipc	ra,0x1
    800046b0:	61c080e7          	jalr	1564(ra) # 80005cc8 <panic>
    return 0;
    800046b4:	84aa                	mv	s1,a0
    800046b6:	b731                	j	800045c2 <create+0x72>

00000000800046b8 <sys_dup>:
{
    800046b8:	7179                	addi	sp,sp,-48
    800046ba:	f406                	sd	ra,40(sp)
    800046bc:	f022                	sd	s0,32(sp)
    800046be:	ec26                	sd	s1,24(sp)
    800046c0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046c2:	fd840613          	addi	a2,s0,-40
    800046c6:	4581                	li	a1,0
    800046c8:	4501                	li	a0,0
    800046ca:	00000097          	auipc	ra,0x0
    800046ce:	ddc080e7          	jalr	-548(ra) # 800044a6 <argfd>
    return -1;
    800046d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046d4:	02054363          	bltz	a0,800046fa <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046d8:	fd843503          	ld	a0,-40(s0)
    800046dc:	00000097          	auipc	ra,0x0
    800046e0:	e32080e7          	jalr	-462(ra) # 8000450e <fdalloc>
    800046e4:	84aa                	mv	s1,a0
    return -1;
    800046e6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046e8:	00054963          	bltz	a0,800046fa <sys_dup+0x42>
  filedup(f);
    800046ec:	fd843503          	ld	a0,-40(s0)
    800046f0:	fffff097          	auipc	ra,0xfffff
    800046f4:	37a080e7          	jalr	890(ra) # 80003a6a <filedup>
  return fd;
    800046f8:	87a6                	mv	a5,s1
}
    800046fa:	853e                	mv	a0,a5
    800046fc:	70a2                	ld	ra,40(sp)
    800046fe:	7402                	ld	s0,32(sp)
    80004700:	64e2                	ld	s1,24(sp)
    80004702:	6145                	addi	sp,sp,48
    80004704:	8082                	ret

0000000080004706 <sys_read>:
{
    80004706:	7179                	addi	sp,sp,-48
    80004708:	f406                	sd	ra,40(sp)
    8000470a:	f022                	sd	s0,32(sp)
    8000470c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000470e:	fe840613          	addi	a2,s0,-24
    80004712:	4581                	li	a1,0
    80004714:	4501                	li	a0,0
    80004716:	00000097          	auipc	ra,0x0
    8000471a:	d90080e7          	jalr	-624(ra) # 800044a6 <argfd>
    return -1;
    8000471e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004720:	04054163          	bltz	a0,80004762 <sys_read+0x5c>
    80004724:	fe440593          	addi	a1,s0,-28
    80004728:	4509                	li	a0,2
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	858080e7          	jalr	-1960(ra) # 80001f82 <argint>
    return -1;
    80004732:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004734:	02054763          	bltz	a0,80004762 <sys_read+0x5c>
    80004738:	fd840593          	addi	a1,s0,-40
    8000473c:	4505                	li	a0,1
    8000473e:	ffffe097          	auipc	ra,0xffffe
    80004742:	866080e7          	jalr	-1946(ra) # 80001fa4 <argaddr>
    return -1;
    80004746:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004748:	00054d63          	bltz	a0,80004762 <sys_read+0x5c>
  return fileread(f, p, n);
    8000474c:	fe442603          	lw	a2,-28(s0)
    80004750:	fd843583          	ld	a1,-40(s0)
    80004754:	fe843503          	ld	a0,-24(s0)
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	49e080e7          	jalr	1182(ra) # 80003bf6 <fileread>
    80004760:	87aa                	mv	a5,a0
}
    80004762:	853e                	mv	a0,a5
    80004764:	70a2                	ld	ra,40(sp)
    80004766:	7402                	ld	s0,32(sp)
    80004768:	6145                	addi	sp,sp,48
    8000476a:	8082                	ret

000000008000476c <sys_write>:
{
    8000476c:	7179                	addi	sp,sp,-48
    8000476e:	f406                	sd	ra,40(sp)
    80004770:	f022                	sd	s0,32(sp)
    80004772:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004774:	fe840613          	addi	a2,s0,-24
    80004778:	4581                	li	a1,0
    8000477a:	4501                	li	a0,0
    8000477c:	00000097          	auipc	ra,0x0
    80004780:	d2a080e7          	jalr	-726(ra) # 800044a6 <argfd>
    return -1;
    80004784:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004786:	04054163          	bltz	a0,800047c8 <sys_write+0x5c>
    8000478a:	fe440593          	addi	a1,s0,-28
    8000478e:	4509                	li	a0,2
    80004790:	ffffd097          	auipc	ra,0xffffd
    80004794:	7f2080e7          	jalr	2034(ra) # 80001f82 <argint>
    return -1;
    80004798:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000479a:	02054763          	bltz	a0,800047c8 <sys_write+0x5c>
    8000479e:	fd840593          	addi	a1,s0,-40
    800047a2:	4505                	li	a0,1
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	800080e7          	jalr	-2048(ra) # 80001fa4 <argaddr>
    return -1;
    800047ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ae:	00054d63          	bltz	a0,800047c8 <sys_write+0x5c>
  return filewrite(f, p, n);
    800047b2:	fe442603          	lw	a2,-28(s0)
    800047b6:	fd843583          	ld	a1,-40(s0)
    800047ba:	fe843503          	ld	a0,-24(s0)
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	4fa080e7          	jalr	1274(ra) # 80003cb8 <filewrite>
    800047c6:	87aa                	mv	a5,a0
}
    800047c8:	853e                	mv	a0,a5
    800047ca:	70a2                	ld	ra,40(sp)
    800047cc:	7402                	ld	s0,32(sp)
    800047ce:	6145                	addi	sp,sp,48
    800047d0:	8082                	ret

00000000800047d2 <sys_close>:
{
    800047d2:	1101                	addi	sp,sp,-32
    800047d4:	ec06                	sd	ra,24(sp)
    800047d6:	e822                	sd	s0,16(sp)
    800047d8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047da:	fe040613          	addi	a2,s0,-32
    800047de:	fec40593          	addi	a1,s0,-20
    800047e2:	4501                	li	a0,0
    800047e4:	00000097          	auipc	ra,0x0
    800047e8:	cc2080e7          	jalr	-830(ra) # 800044a6 <argfd>
    return -1;
    800047ec:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047ee:	02054463          	bltz	a0,80004816 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047f2:	ffffc097          	auipc	ra,0xffffc
    800047f6:	67c080e7          	jalr	1660(ra) # 80000e6e <myproc>
    800047fa:	fec42783          	lw	a5,-20(s0)
    800047fe:	07e9                	addi	a5,a5,26
    80004800:	078e                	slli	a5,a5,0x3
    80004802:	97aa                	add	a5,a5,a0
    80004804:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004808:	fe043503          	ld	a0,-32(s0)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	2b0080e7          	jalr	688(ra) # 80003abc <fileclose>
  return 0;
    80004814:	4781                	li	a5,0
}
    80004816:	853e                	mv	a0,a5
    80004818:	60e2                	ld	ra,24(sp)
    8000481a:	6442                	ld	s0,16(sp)
    8000481c:	6105                	addi	sp,sp,32
    8000481e:	8082                	ret

0000000080004820 <sys_fstat>:
{
    80004820:	1101                	addi	sp,sp,-32
    80004822:	ec06                	sd	ra,24(sp)
    80004824:	e822                	sd	s0,16(sp)
    80004826:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004828:	fe840613          	addi	a2,s0,-24
    8000482c:	4581                	li	a1,0
    8000482e:	4501                	li	a0,0
    80004830:	00000097          	auipc	ra,0x0
    80004834:	c76080e7          	jalr	-906(ra) # 800044a6 <argfd>
    return -1;
    80004838:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000483a:	02054563          	bltz	a0,80004864 <sys_fstat+0x44>
    8000483e:	fe040593          	addi	a1,s0,-32
    80004842:	4505                	li	a0,1
    80004844:	ffffd097          	auipc	ra,0xffffd
    80004848:	760080e7          	jalr	1888(ra) # 80001fa4 <argaddr>
    return -1;
    8000484c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000484e:	00054b63          	bltz	a0,80004864 <sys_fstat+0x44>
  return filestat(f, st);
    80004852:	fe043583          	ld	a1,-32(s0)
    80004856:	fe843503          	ld	a0,-24(s0)
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	32a080e7          	jalr	810(ra) # 80003b84 <filestat>
    80004862:	87aa                	mv	a5,a0
}
    80004864:	853e                	mv	a0,a5
    80004866:	60e2                	ld	ra,24(sp)
    80004868:	6442                	ld	s0,16(sp)
    8000486a:	6105                	addi	sp,sp,32
    8000486c:	8082                	ret

000000008000486e <sys_link>:
{
    8000486e:	7169                	addi	sp,sp,-304
    80004870:	f606                	sd	ra,296(sp)
    80004872:	f222                	sd	s0,288(sp)
    80004874:	ee26                	sd	s1,280(sp)
    80004876:	ea4a                	sd	s2,272(sp)
    80004878:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000487a:	08000613          	li	a2,128
    8000487e:	ed040593          	addi	a1,s0,-304
    80004882:	4501                	li	a0,0
    80004884:	ffffd097          	auipc	ra,0xffffd
    80004888:	742080e7          	jalr	1858(ra) # 80001fc6 <argstr>
    return -1;
    8000488c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000488e:	10054e63          	bltz	a0,800049aa <sys_link+0x13c>
    80004892:	08000613          	li	a2,128
    80004896:	f5040593          	addi	a1,s0,-176
    8000489a:	4505                	li	a0,1
    8000489c:	ffffd097          	auipc	ra,0xffffd
    800048a0:	72a080e7          	jalr	1834(ra) # 80001fc6 <argstr>
    return -1;
    800048a4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048a6:	10054263          	bltz	a0,800049aa <sys_link+0x13c>
  begin_op();
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	d46080e7          	jalr	-698(ra) # 800035f0 <begin_op>
  if((ip = namei(old)) == 0){
    800048b2:	ed040513          	addi	a0,s0,-304
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	b1e080e7          	jalr	-1250(ra) # 800033d4 <namei>
    800048be:	84aa                	mv	s1,a0
    800048c0:	c551                	beqz	a0,8000494c <sys_link+0xde>
  ilock(ip);
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	35c080e7          	jalr	860(ra) # 80002c1e <ilock>
  if(ip->type == T_DIR){
    800048ca:	04449703          	lh	a4,68(s1)
    800048ce:	4785                	li	a5,1
    800048d0:	08f70463          	beq	a4,a5,80004958 <sys_link+0xea>
  ip->nlink++;
    800048d4:	04a4d783          	lhu	a5,74(s1)
    800048d8:	2785                	addiw	a5,a5,1
    800048da:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048de:	8526                	mv	a0,s1
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	274080e7          	jalr	628(ra) # 80002b54 <iupdate>
  iunlock(ip);
    800048e8:	8526                	mv	a0,s1
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	3f6080e7          	jalr	1014(ra) # 80002ce0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048f2:	fd040593          	addi	a1,s0,-48
    800048f6:	f5040513          	addi	a0,s0,-176
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	af8080e7          	jalr	-1288(ra) # 800033f2 <nameiparent>
    80004902:	892a                	mv	s2,a0
    80004904:	c935                	beqz	a0,80004978 <sys_link+0x10a>
  ilock(dp);
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	318080e7          	jalr	792(ra) # 80002c1e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000490e:	00092703          	lw	a4,0(s2)
    80004912:	409c                	lw	a5,0(s1)
    80004914:	04f71d63          	bne	a4,a5,8000496e <sys_link+0x100>
    80004918:	40d0                	lw	a2,4(s1)
    8000491a:	fd040593          	addi	a1,s0,-48
    8000491e:	854a                	mv	a0,s2
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	9f2080e7          	jalr	-1550(ra) # 80003312 <dirlink>
    80004928:	04054363          	bltz	a0,8000496e <sys_link+0x100>
  iunlockput(dp);
    8000492c:	854a                	mv	a0,s2
    8000492e:	ffffe097          	auipc	ra,0xffffe
    80004932:	552080e7          	jalr	1362(ra) # 80002e80 <iunlockput>
  iput(ip);
    80004936:	8526                	mv	a0,s1
    80004938:	ffffe097          	auipc	ra,0xffffe
    8000493c:	4a0080e7          	jalr	1184(ra) # 80002dd8 <iput>
  end_op();
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	d30080e7          	jalr	-720(ra) # 80003670 <end_op>
  return 0;
    80004948:	4781                	li	a5,0
    8000494a:	a085                	j	800049aa <sys_link+0x13c>
    end_op();
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	d24080e7          	jalr	-732(ra) # 80003670 <end_op>
    return -1;
    80004954:	57fd                	li	a5,-1
    80004956:	a891                	j	800049aa <sys_link+0x13c>
    iunlockput(ip);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	526080e7          	jalr	1318(ra) # 80002e80 <iunlockput>
    end_op();
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	d0e080e7          	jalr	-754(ra) # 80003670 <end_op>
    return -1;
    8000496a:	57fd                	li	a5,-1
    8000496c:	a83d                	j	800049aa <sys_link+0x13c>
    iunlockput(dp);
    8000496e:	854a                	mv	a0,s2
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	510080e7          	jalr	1296(ra) # 80002e80 <iunlockput>
  ilock(ip);
    80004978:	8526                	mv	a0,s1
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	2a4080e7          	jalr	676(ra) # 80002c1e <ilock>
  ip->nlink--;
    80004982:	04a4d783          	lhu	a5,74(s1)
    80004986:	37fd                	addiw	a5,a5,-1
    80004988:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	1c6080e7          	jalr	454(ra) # 80002b54 <iupdate>
  iunlockput(ip);
    80004996:	8526                	mv	a0,s1
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	4e8080e7          	jalr	1256(ra) # 80002e80 <iunlockput>
  end_op();
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	cd0080e7          	jalr	-816(ra) # 80003670 <end_op>
  return -1;
    800049a8:	57fd                	li	a5,-1
}
    800049aa:	853e                	mv	a0,a5
    800049ac:	70b2                	ld	ra,296(sp)
    800049ae:	7412                	ld	s0,288(sp)
    800049b0:	64f2                	ld	s1,280(sp)
    800049b2:	6952                	ld	s2,272(sp)
    800049b4:	6155                	addi	sp,sp,304
    800049b6:	8082                	ret

00000000800049b8 <sys_unlink>:
{
    800049b8:	7151                	addi	sp,sp,-240
    800049ba:	f586                	sd	ra,232(sp)
    800049bc:	f1a2                	sd	s0,224(sp)
    800049be:	eda6                	sd	s1,216(sp)
    800049c0:	e9ca                	sd	s2,208(sp)
    800049c2:	e5ce                	sd	s3,200(sp)
    800049c4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049c6:	08000613          	li	a2,128
    800049ca:	f3040593          	addi	a1,s0,-208
    800049ce:	4501                	li	a0,0
    800049d0:	ffffd097          	auipc	ra,0xffffd
    800049d4:	5f6080e7          	jalr	1526(ra) # 80001fc6 <argstr>
    800049d8:	18054163          	bltz	a0,80004b5a <sys_unlink+0x1a2>
  begin_op();
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	c14080e7          	jalr	-1004(ra) # 800035f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049e4:	fb040593          	addi	a1,s0,-80
    800049e8:	f3040513          	addi	a0,s0,-208
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	a06080e7          	jalr	-1530(ra) # 800033f2 <nameiparent>
    800049f4:	84aa                	mv	s1,a0
    800049f6:	c979                	beqz	a0,80004acc <sys_unlink+0x114>
  ilock(dp);
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	226080e7          	jalr	550(ra) # 80002c1e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a00:	00004597          	auipc	a1,0x4
    80004a04:	e4858593          	addi	a1,a1,-440 # 80008848 <syscall_name+0x2f8>
    80004a08:	fb040513          	addi	a0,s0,-80
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	6dc080e7          	jalr	1756(ra) # 800030e8 <namecmp>
    80004a14:	14050a63          	beqz	a0,80004b68 <sys_unlink+0x1b0>
    80004a18:	00004597          	auipc	a1,0x4
    80004a1c:	e3858593          	addi	a1,a1,-456 # 80008850 <syscall_name+0x300>
    80004a20:	fb040513          	addi	a0,s0,-80
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	6c4080e7          	jalr	1732(ra) # 800030e8 <namecmp>
    80004a2c:	12050e63          	beqz	a0,80004b68 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a30:	f2c40613          	addi	a2,s0,-212
    80004a34:	fb040593          	addi	a1,s0,-80
    80004a38:	8526                	mv	a0,s1
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	6c8080e7          	jalr	1736(ra) # 80003102 <dirlookup>
    80004a42:	892a                	mv	s2,a0
    80004a44:	12050263          	beqz	a0,80004b68 <sys_unlink+0x1b0>
  ilock(ip);
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	1d6080e7          	jalr	470(ra) # 80002c1e <ilock>
  if(ip->nlink < 1)
    80004a50:	04a91783          	lh	a5,74(s2)
    80004a54:	08f05263          	blez	a5,80004ad8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a58:	04491703          	lh	a4,68(s2)
    80004a5c:	4785                	li	a5,1
    80004a5e:	08f70563          	beq	a4,a5,80004ae8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a62:	4641                	li	a2,16
    80004a64:	4581                	li	a1,0
    80004a66:	fc040513          	addi	a0,s0,-64
    80004a6a:	ffffb097          	auipc	ra,0xffffb
    80004a6e:	734080e7          	jalr	1844(ra) # 8000019e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a72:	4741                	li	a4,16
    80004a74:	f2c42683          	lw	a3,-212(s0)
    80004a78:	fc040613          	addi	a2,s0,-64
    80004a7c:	4581                	li	a1,0
    80004a7e:	8526                	mv	a0,s1
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	54a080e7          	jalr	1354(ra) # 80002fca <writei>
    80004a88:	47c1                	li	a5,16
    80004a8a:	0af51563          	bne	a0,a5,80004b34 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a8e:	04491703          	lh	a4,68(s2)
    80004a92:	4785                	li	a5,1
    80004a94:	0af70863          	beq	a4,a5,80004b44 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a98:	8526                	mv	a0,s1
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	3e6080e7          	jalr	998(ra) # 80002e80 <iunlockput>
  ip->nlink--;
    80004aa2:	04a95783          	lhu	a5,74(s2)
    80004aa6:	37fd                	addiw	a5,a5,-1
    80004aa8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004aac:	854a                	mv	a0,s2
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	0a6080e7          	jalr	166(ra) # 80002b54 <iupdate>
  iunlockput(ip);
    80004ab6:	854a                	mv	a0,s2
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	3c8080e7          	jalr	968(ra) # 80002e80 <iunlockput>
  end_op();
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	bb0080e7          	jalr	-1104(ra) # 80003670 <end_op>
  return 0;
    80004ac8:	4501                	li	a0,0
    80004aca:	a84d                	j	80004b7c <sys_unlink+0x1c4>
    end_op();
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	ba4080e7          	jalr	-1116(ra) # 80003670 <end_op>
    return -1;
    80004ad4:	557d                	li	a0,-1
    80004ad6:	a05d                	j	80004b7c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ad8:	00004517          	auipc	a0,0x4
    80004adc:	da050513          	addi	a0,a0,-608 # 80008878 <syscall_name+0x328>
    80004ae0:	00001097          	auipc	ra,0x1
    80004ae4:	1e8080e7          	jalr	488(ra) # 80005cc8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae8:	04c92703          	lw	a4,76(s2)
    80004aec:	02000793          	li	a5,32
    80004af0:	f6e7f9e3          	bgeu	a5,a4,80004a62 <sys_unlink+0xaa>
    80004af4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af8:	4741                	li	a4,16
    80004afa:	86ce                	mv	a3,s3
    80004afc:	f1840613          	addi	a2,s0,-232
    80004b00:	4581                	li	a1,0
    80004b02:	854a                	mv	a0,s2
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	3ce080e7          	jalr	974(ra) # 80002ed2 <readi>
    80004b0c:	47c1                	li	a5,16
    80004b0e:	00f51b63          	bne	a0,a5,80004b24 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b12:	f1845783          	lhu	a5,-232(s0)
    80004b16:	e7a1                	bnez	a5,80004b5e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b18:	29c1                	addiw	s3,s3,16
    80004b1a:	04c92783          	lw	a5,76(s2)
    80004b1e:	fcf9ede3          	bltu	s3,a5,80004af8 <sys_unlink+0x140>
    80004b22:	b781                	j	80004a62 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b24:	00004517          	auipc	a0,0x4
    80004b28:	d6c50513          	addi	a0,a0,-660 # 80008890 <syscall_name+0x340>
    80004b2c:	00001097          	auipc	ra,0x1
    80004b30:	19c080e7          	jalr	412(ra) # 80005cc8 <panic>
    panic("unlink: writei");
    80004b34:	00004517          	auipc	a0,0x4
    80004b38:	d7450513          	addi	a0,a0,-652 # 800088a8 <syscall_name+0x358>
    80004b3c:	00001097          	auipc	ra,0x1
    80004b40:	18c080e7          	jalr	396(ra) # 80005cc8 <panic>
    dp->nlink--;
    80004b44:	04a4d783          	lhu	a5,74(s1)
    80004b48:	37fd                	addiw	a5,a5,-1
    80004b4a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	004080e7          	jalr	4(ra) # 80002b54 <iupdate>
    80004b58:	b781                	j	80004a98 <sys_unlink+0xe0>
    return -1;
    80004b5a:	557d                	li	a0,-1
    80004b5c:	a005                	j	80004b7c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b5e:	854a                	mv	a0,s2
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	320080e7          	jalr	800(ra) # 80002e80 <iunlockput>
  iunlockput(dp);
    80004b68:	8526                	mv	a0,s1
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	316080e7          	jalr	790(ra) # 80002e80 <iunlockput>
  end_op();
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	afe080e7          	jalr	-1282(ra) # 80003670 <end_op>
  return -1;
    80004b7a:	557d                	li	a0,-1
}
    80004b7c:	70ae                	ld	ra,232(sp)
    80004b7e:	740e                	ld	s0,224(sp)
    80004b80:	64ee                	ld	s1,216(sp)
    80004b82:	694e                	ld	s2,208(sp)
    80004b84:	69ae                	ld	s3,200(sp)
    80004b86:	616d                	addi	sp,sp,240
    80004b88:	8082                	ret

0000000080004b8a <sys_open>:

uint64
sys_open(void)
{
    80004b8a:	7131                	addi	sp,sp,-192
    80004b8c:	fd06                	sd	ra,184(sp)
    80004b8e:	f922                	sd	s0,176(sp)
    80004b90:	f526                	sd	s1,168(sp)
    80004b92:	f14a                	sd	s2,160(sp)
    80004b94:	ed4e                	sd	s3,152(sp)
    80004b96:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b98:	08000613          	li	a2,128
    80004b9c:	f5040593          	addi	a1,s0,-176
    80004ba0:	4501                	li	a0,0
    80004ba2:	ffffd097          	auipc	ra,0xffffd
    80004ba6:	424080e7          	jalr	1060(ra) # 80001fc6 <argstr>
    return -1;
    80004baa:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bac:	0c054163          	bltz	a0,80004c6e <sys_open+0xe4>
    80004bb0:	f4c40593          	addi	a1,s0,-180
    80004bb4:	4505                	li	a0,1
    80004bb6:	ffffd097          	auipc	ra,0xffffd
    80004bba:	3cc080e7          	jalr	972(ra) # 80001f82 <argint>
    80004bbe:	0a054863          	bltz	a0,80004c6e <sys_open+0xe4>

  begin_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	a2e080e7          	jalr	-1490(ra) # 800035f0 <begin_op>

  if(omode & O_CREATE){
    80004bca:	f4c42783          	lw	a5,-180(s0)
    80004bce:	2007f793          	andi	a5,a5,512
    80004bd2:	cbdd                	beqz	a5,80004c88 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bd4:	4681                	li	a3,0
    80004bd6:	4601                	li	a2,0
    80004bd8:	4589                	li	a1,2
    80004bda:	f5040513          	addi	a0,s0,-176
    80004bde:	00000097          	auipc	ra,0x0
    80004be2:	972080e7          	jalr	-1678(ra) # 80004550 <create>
    80004be6:	892a                	mv	s2,a0
    if(ip == 0){
    80004be8:	c959                	beqz	a0,80004c7e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bea:	04491703          	lh	a4,68(s2)
    80004bee:	478d                	li	a5,3
    80004bf0:	00f71763          	bne	a4,a5,80004bfe <sys_open+0x74>
    80004bf4:	04695703          	lhu	a4,70(s2)
    80004bf8:	47a5                	li	a5,9
    80004bfa:	0ce7ec63          	bltu	a5,a4,80004cd2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	e02080e7          	jalr	-510(ra) # 80003a00 <filealloc>
    80004c06:	89aa                	mv	s3,a0
    80004c08:	10050263          	beqz	a0,80004d0c <sys_open+0x182>
    80004c0c:	00000097          	auipc	ra,0x0
    80004c10:	902080e7          	jalr	-1790(ra) # 8000450e <fdalloc>
    80004c14:	84aa                	mv	s1,a0
    80004c16:	0e054663          	bltz	a0,80004d02 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c1a:	04491703          	lh	a4,68(s2)
    80004c1e:	478d                	li	a5,3
    80004c20:	0cf70463          	beq	a4,a5,80004ce8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c24:	4789                	li	a5,2
    80004c26:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c2a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c2e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c32:	f4c42783          	lw	a5,-180(s0)
    80004c36:	0017c713          	xori	a4,a5,1
    80004c3a:	8b05                	andi	a4,a4,1
    80004c3c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c40:	0037f713          	andi	a4,a5,3
    80004c44:	00e03733          	snez	a4,a4
    80004c48:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c4c:	4007f793          	andi	a5,a5,1024
    80004c50:	c791                	beqz	a5,80004c5c <sys_open+0xd2>
    80004c52:	04491703          	lh	a4,68(s2)
    80004c56:	4789                	li	a5,2
    80004c58:	08f70f63          	beq	a4,a5,80004cf6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c5c:	854a                	mv	a0,s2
    80004c5e:	ffffe097          	auipc	ra,0xffffe
    80004c62:	082080e7          	jalr	130(ra) # 80002ce0 <iunlock>
  end_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	a0a080e7          	jalr	-1526(ra) # 80003670 <end_op>

  return fd;
}
    80004c6e:	8526                	mv	a0,s1
    80004c70:	70ea                	ld	ra,184(sp)
    80004c72:	744a                	ld	s0,176(sp)
    80004c74:	74aa                	ld	s1,168(sp)
    80004c76:	790a                	ld	s2,160(sp)
    80004c78:	69ea                	ld	s3,152(sp)
    80004c7a:	6129                	addi	sp,sp,192
    80004c7c:	8082                	ret
      end_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	9f2080e7          	jalr	-1550(ra) # 80003670 <end_op>
      return -1;
    80004c86:	b7e5                	j	80004c6e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c88:	f5040513          	addi	a0,s0,-176
    80004c8c:	ffffe097          	auipc	ra,0xffffe
    80004c90:	748080e7          	jalr	1864(ra) # 800033d4 <namei>
    80004c94:	892a                	mv	s2,a0
    80004c96:	c905                	beqz	a0,80004cc6 <sys_open+0x13c>
    ilock(ip);
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	f86080e7          	jalr	-122(ra) # 80002c1e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ca0:	04491703          	lh	a4,68(s2)
    80004ca4:	4785                	li	a5,1
    80004ca6:	f4f712e3          	bne	a4,a5,80004bea <sys_open+0x60>
    80004caa:	f4c42783          	lw	a5,-180(s0)
    80004cae:	dba1                	beqz	a5,80004bfe <sys_open+0x74>
      iunlockput(ip);
    80004cb0:	854a                	mv	a0,s2
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	1ce080e7          	jalr	462(ra) # 80002e80 <iunlockput>
      end_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	9b6080e7          	jalr	-1610(ra) # 80003670 <end_op>
      return -1;
    80004cc2:	54fd                	li	s1,-1
    80004cc4:	b76d                	j	80004c6e <sys_open+0xe4>
      end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	9aa080e7          	jalr	-1622(ra) # 80003670 <end_op>
      return -1;
    80004cce:	54fd                	li	s1,-1
    80004cd0:	bf79                	j	80004c6e <sys_open+0xe4>
    iunlockput(ip);
    80004cd2:	854a                	mv	a0,s2
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	1ac080e7          	jalr	428(ra) # 80002e80 <iunlockput>
    end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	994080e7          	jalr	-1644(ra) # 80003670 <end_op>
    return -1;
    80004ce4:	54fd                	li	s1,-1
    80004ce6:	b761                	j	80004c6e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ce8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cec:	04691783          	lh	a5,70(s2)
    80004cf0:	02f99223          	sh	a5,36(s3)
    80004cf4:	bf2d                	j	80004c2e <sys_open+0xa4>
    itrunc(ip);
    80004cf6:	854a                	mv	a0,s2
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	034080e7          	jalr	52(ra) # 80002d2c <itrunc>
    80004d00:	bfb1                	j	80004c5c <sys_open+0xd2>
      fileclose(f);
    80004d02:	854e                	mv	a0,s3
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	db8080e7          	jalr	-584(ra) # 80003abc <fileclose>
    iunlockput(ip);
    80004d0c:	854a                	mv	a0,s2
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	172080e7          	jalr	370(ra) # 80002e80 <iunlockput>
    end_op();
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	95a080e7          	jalr	-1702(ra) # 80003670 <end_op>
    return -1;
    80004d1e:	54fd                	li	s1,-1
    80004d20:	b7b9                	j	80004c6e <sys_open+0xe4>

0000000080004d22 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d22:	7175                	addi	sp,sp,-144
    80004d24:	e506                	sd	ra,136(sp)
    80004d26:	e122                	sd	s0,128(sp)
    80004d28:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	8c6080e7          	jalr	-1850(ra) # 800035f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d32:	08000613          	li	a2,128
    80004d36:	f7040593          	addi	a1,s0,-144
    80004d3a:	4501                	li	a0,0
    80004d3c:	ffffd097          	auipc	ra,0xffffd
    80004d40:	28a080e7          	jalr	650(ra) # 80001fc6 <argstr>
    80004d44:	02054963          	bltz	a0,80004d76 <sys_mkdir+0x54>
    80004d48:	4681                	li	a3,0
    80004d4a:	4601                	li	a2,0
    80004d4c:	4585                	li	a1,1
    80004d4e:	f7040513          	addi	a0,s0,-144
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	7fe080e7          	jalr	2046(ra) # 80004550 <create>
    80004d5a:	cd11                	beqz	a0,80004d76 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	124080e7          	jalr	292(ra) # 80002e80 <iunlockput>
  end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	90c080e7          	jalr	-1780(ra) # 80003670 <end_op>
  return 0;
    80004d6c:	4501                	li	a0,0
}
    80004d6e:	60aa                	ld	ra,136(sp)
    80004d70:	640a                	ld	s0,128(sp)
    80004d72:	6149                	addi	sp,sp,144
    80004d74:	8082                	ret
    end_op();
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	8fa080e7          	jalr	-1798(ra) # 80003670 <end_op>
    return -1;
    80004d7e:	557d                	li	a0,-1
    80004d80:	b7fd                	j	80004d6e <sys_mkdir+0x4c>

0000000080004d82 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d82:	7135                	addi	sp,sp,-160
    80004d84:	ed06                	sd	ra,152(sp)
    80004d86:	e922                	sd	s0,144(sp)
    80004d88:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	866080e7          	jalr	-1946(ra) # 800035f0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d92:	08000613          	li	a2,128
    80004d96:	f7040593          	addi	a1,s0,-144
    80004d9a:	4501                	li	a0,0
    80004d9c:	ffffd097          	auipc	ra,0xffffd
    80004da0:	22a080e7          	jalr	554(ra) # 80001fc6 <argstr>
    80004da4:	04054a63          	bltz	a0,80004df8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004da8:	f6c40593          	addi	a1,s0,-148
    80004dac:	4505                	li	a0,1
    80004dae:	ffffd097          	auipc	ra,0xffffd
    80004db2:	1d4080e7          	jalr	468(ra) # 80001f82 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004db6:	04054163          	bltz	a0,80004df8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004dba:	f6840593          	addi	a1,s0,-152
    80004dbe:	4509                	li	a0,2
    80004dc0:	ffffd097          	auipc	ra,0xffffd
    80004dc4:	1c2080e7          	jalr	450(ra) # 80001f82 <argint>
     argint(1, &major) < 0 ||
    80004dc8:	02054863          	bltz	a0,80004df8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dcc:	f6841683          	lh	a3,-152(s0)
    80004dd0:	f6c41603          	lh	a2,-148(s0)
    80004dd4:	458d                	li	a1,3
    80004dd6:	f7040513          	addi	a0,s0,-144
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	776080e7          	jalr	1910(ra) # 80004550 <create>
     argint(2, &minor) < 0 ||
    80004de2:	c919                	beqz	a0,80004df8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	09c080e7          	jalr	156(ra) # 80002e80 <iunlockput>
  end_op();
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	884080e7          	jalr	-1916(ra) # 80003670 <end_op>
  return 0;
    80004df4:	4501                	li	a0,0
    80004df6:	a031                	j	80004e02 <sys_mknod+0x80>
    end_op();
    80004df8:	fffff097          	auipc	ra,0xfffff
    80004dfc:	878080e7          	jalr	-1928(ra) # 80003670 <end_op>
    return -1;
    80004e00:	557d                	li	a0,-1
}
    80004e02:	60ea                	ld	ra,152(sp)
    80004e04:	644a                	ld	s0,144(sp)
    80004e06:	610d                	addi	sp,sp,160
    80004e08:	8082                	ret

0000000080004e0a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e0a:	7135                	addi	sp,sp,-160
    80004e0c:	ed06                	sd	ra,152(sp)
    80004e0e:	e922                	sd	s0,144(sp)
    80004e10:	e526                	sd	s1,136(sp)
    80004e12:	e14a                	sd	s2,128(sp)
    80004e14:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e16:	ffffc097          	auipc	ra,0xffffc
    80004e1a:	058080e7          	jalr	88(ra) # 80000e6e <myproc>
    80004e1e:	892a                	mv	s2,a0
  
  begin_op();
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	7d0080e7          	jalr	2000(ra) # 800035f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e28:	08000613          	li	a2,128
    80004e2c:	f6040593          	addi	a1,s0,-160
    80004e30:	4501                	li	a0,0
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	194080e7          	jalr	404(ra) # 80001fc6 <argstr>
    80004e3a:	04054b63          	bltz	a0,80004e90 <sys_chdir+0x86>
    80004e3e:	f6040513          	addi	a0,s0,-160
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	592080e7          	jalr	1426(ra) # 800033d4 <namei>
    80004e4a:	84aa                	mv	s1,a0
    80004e4c:	c131                	beqz	a0,80004e90 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	dd0080e7          	jalr	-560(ra) # 80002c1e <ilock>
  if(ip->type != T_DIR){
    80004e56:	04449703          	lh	a4,68(s1)
    80004e5a:	4785                	li	a5,1
    80004e5c:	04f71063          	bne	a4,a5,80004e9c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e60:	8526                	mv	a0,s1
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	e7e080e7          	jalr	-386(ra) # 80002ce0 <iunlock>
  iput(p->cwd);
    80004e6a:	15093503          	ld	a0,336(s2)
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	f6a080e7          	jalr	-150(ra) # 80002dd8 <iput>
  end_op();
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	7fa080e7          	jalr	2042(ra) # 80003670 <end_op>
  p->cwd = ip;
    80004e7e:	14993823          	sd	s1,336(s2)
  return 0;
    80004e82:	4501                	li	a0,0
}
    80004e84:	60ea                	ld	ra,152(sp)
    80004e86:	644a                	ld	s0,144(sp)
    80004e88:	64aa                	ld	s1,136(sp)
    80004e8a:	690a                	ld	s2,128(sp)
    80004e8c:	610d                	addi	sp,sp,160
    80004e8e:	8082                	ret
    end_op();
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	7e0080e7          	jalr	2016(ra) # 80003670 <end_op>
    return -1;
    80004e98:	557d                	li	a0,-1
    80004e9a:	b7ed                	j	80004e84 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e9c:	8526                	mv	a0,s1
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	fe2080e7          	jalr	-30(ra) # 80002e80 <iunlockput>
    end_op();
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	7ca080e7          	jalr	1994(ra) # 80003670 <end_op>
    return -1;
    80004eae:	557d                	li	a0,-1
    80004eb0:	bfd1                	j	80004e84 <sys_chdir+0x7a>

0000000080004eb2 <sys_exec>:

uint64
sys_exec(void)
{
    80004eb2:	7145                	addi	sp,sp,-464
    80004eb4:	e786                	sd	ra,456(sp)
    80004eb6:	e3a2                	sd	s0,448(sp)
    80004eb8:	ff26                	sd	s1,440(sp)
    80004eba:	fb4a                	sd	s2,432(sp)
    80004ebc:	f74e                	sd	s3,424(sp)
    80004ebe:	f352                	sd	s4,416(sp)
    80004ec0:	ef56                	sd	s5,408(sp)
    80004ec2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ec4:	08000613          	li	a2,128
    80004ec8:	f4040593          	addi	a1,s0,-192
    80004ecc:	4501                	li	a0,0
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	0f8080e7          	jalr	248(ra) # 80001fc6 <argstr>
    return -1;
    80004ed6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ed8:	0c054a63          	bltz	a0,80004fac <sys_exec+0xfa>
    80004edc:	e3840593          	addi	a1,s0,-456
    80004ee0:	4505                	li	a0,1
    80004ee2:	ffffd097          	auipc	ra,0xffffd
    80004ee6:	0c2080e7          	jalr	194(ra) # 80001fa4 <argaddr>
    80004eea:	0c054163          	bltz	a0,80004fac <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004eee:	10000613          	li	a2,256
    80004ef2:	4581                	li	a1,0
    80004ef4:	e4040513          	addi	a0,s0,-448
    80004ef8:	ffffb097          	auipc	ra,0xffffb
    80004efc:	2a6080e7          	jalr	678(ra) # 8000019e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f00:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f04:	89a6                	mv	s3,s1
    80004f06:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f08:	02000a13          	li	s4,32
    80004f0c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f10:	00391513          	slli	a0,s2,0x3
    80004f14:	e3040593          	addi	a1,s0,-464
    80004f18:	e3843783          	ld	a5,-456(s0)
    80004f1c:	953e                	add	a0,a0,a5
    80004f1e:	ffffd097          	auipc	ra,0xffffd
    80004f22:	fca080e7          	jalr	-54(ra) # 80001ee8 <fetchaddr>
    80004f26:	02054a63          	bltz	a0,80004f5a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f2a:	e3043783          	ld	a5,-464(s0)
    80004f2e:	c3b9                	beqz	a5,80004f74 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f30:	ffffb097          	auipc	ra,0xffffb
    80004f34:	1e8080e7          	jalr	488(ra) # 80000118 <kalloc>
    80004f38:	85aa                	mv	a1,a0
    80004f3a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f3e:	cd11                	beqz	a0,80004f5a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f40:	6605                	lui	a2,0x1
    80004f42:	e3043503          	ld	a0,-464(s0)
    80004f46:	ffffd097          	auipc	ra,0xffffd
    80004f4a:	ff4080e7          	jalr	-12(ra) # 80001f3a <fetchstr>
    80004f4e:	00054663          	bltz	a0,80004f5a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f52:	0905                	addi	s2,s2,1
    80004f54:	09a1                	addi	s3,s3,8
    80004f56:	fb491be3          	bne	s2,s4,80004f0c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5a:	10048913          	addi	s2,s1,256
    80004f5e:	6088                	ld	a0,0(s1)
    80004f60:	c529                	beqz	a0,80004faa <sys_exec+0xf8>
    kfree(argv[i]);
    80004f62:	ffffb097          	auipc	ra,0xffffb
    80004f66:	0ba080e7          	jalr	186(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6a:	04a1                	addi	s1,s1,8
    80004f6c:	ff2499e3          	bne	s1,s2,80004f5e <sys_exec+0xac>
  return -1;
    80004f70:	597d                	li	s2,-1
    80004f72:	a82d                	j	80004fac <sys_exec+0xfa>
      argv[i] = 0;
    80004f74:	0a8e                	slli	s5,s5,0x3
    80004f76:	fc040793          	addi	a5,s0,-64
    80004f7a:	9abe                	add	s5,s5,a5
    80004f7c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f80:	e4040593          	addi	a1,s0,-448
    80004f84:	f4040513          	addi	a0,s0,-192
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	194080e7          	jalr	404(ra) # 8000411c <exec>
    80004f90:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f92:	10048993          	addi	s3,s1,256
    80004f96:	6088                	ld	a0,0(s1)
    80004f98:	c911                	beqz	a0,80004fac <sys_exec+0xfa>
    kfree(argv[i]);
    80004f9a:	ffffb097          	auipc	ra,0xffffb
    80004f9e:	082080e7          	jalr	130(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa2:	04a1                	addi	s1,s1,8
    80004fa4:	ff3499e3          	bne	s1,s3,80004f96 <sys_exec+0xe4>
    80004fa8:	a011                	j	80004fac <sys_exec+0xfa>
  return -1;
    80004faa:	597d                	li	s2,-1
}
    80004fac:	854a                	mv	a0,s2
    80004fae:	60be                	ld	ra,456(sp)
    80004fb0:	641e                	ld	s0,448(sp)
    80004fb2:	74fa                	ld	s1,440(sp)
    80004fb4:	795a                	ld	s2,432(sp)
    80004fb6:	79ba                	ld	s3,424(sp)
    80004fb8:	7a1a                	ld	s4,416(sp)
    80004fba:	6afa                	ld	s5,408(sp)
    80004fbc:	6179                	addi	sp,sp,464
    80004fbe:	8082                	ret

0000000080004fc0 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fc0:	7139                	addi	sp,sp,-64
    80004fc2:	fc06                	sd	ra,56(sp)
    80004fc4:	f822                	sd	s0,48(sp)
    80004fc6:	f426                	sd	s1,40(sp)
    80004fc8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	ea4080e7          	jalr	-348(ra) # 80000e6e <myproc>
    80004fd2:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fd4:	fd840593          	addi	a1,s0,-40
    80004fd8:	4501                	li	a0,0
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	fca080e7          	jalr	-54(ra) # 80001fa4 <argaddr>
    return -1;
    80004fe2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fe4:	0e054063          	bltz	a0,800050c4 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fe8:	fc840593          	addi	a1,s0,-56
    80004fec:	fd040513          	addi	a0,s0,-48
    80004ff0:	fffff097          	auipc	ra,0xfffff
    80004ff4:	dfc080e7          	jalr	-516(ra) # 80003dec <pipealloc>
    return -1;
    80004ff8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ffa:	0c054563          	bltz	a0,800050c4 <sys_pipe+0x104>
  fd0 = -1;
    80004ffe:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005002:	fd043503          	ld	a0,-48(s0)
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	508080e7          	jalr	1288(ra) # 8000450e <fdalloc>
    8000500e:	fca42223          	sw	a0,-60(s0)
    80005012:	08054c63          	bltz	a0,800050aa <sys_pipe+0xea>
    80005016:	fc843503          	ld	a0,-56(s0)
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	4f4080e7          	jalr	1268(ra) # 8000450e <fdalloc>
    80005022:	fca42023          	sw	a0,-64(s0)
    80005026:	06054863          	bltz	a0,80005096 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000502a:	4691                	li	a3,4
    8000502c:	fc440613          	addi	a2,s0,-60
    80005030:	fd843583          	ld	a1,-40(s0)
    80005034:	68a8                	ld	a0,80(s1)
    80005036:	ffffc097          	auipc	ra,0xffffc
    8000503a:	afa080e7          	jalr	-1286(ra) # 80000b30 <copyout>
    8000503e:	02054063          	bltz	a0,8000505e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005042:	4691                	li	a3,4
    80005044:	fc040613          	addi	a2,s0,-64
    80005048:	fd843583          	ld	a1,-40(s0)
    8000504c:	0591                	addi	a1,a1,4
    8000504e:	68a8                	ld	a0,80(s1)
    80005050:	ffffc097          	auipc	ra,0xffffc
    80005054:	ae0080e7          	jalr	-1312(ra) # 80000b30 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005058:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000505a:	06055563          	bgez	a0,800050c4 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000505e:	fc442783          	lw	a5,-60(s0)
    80005062:	07e9                	addi	a5,a5,26
    80005064:	078e                	slli	a5,a5,0x3
    80005066:	97a6                	add	a5,a5,s1
    80005068:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000506c:	fc042503          	lw	a0,-64(s0)
    80005070:	0569                	addi	a0,a0,26
    80005072:	050e                	slli	a0,a0,0x3
    80005074:	9526                	add	a0,a0,s1
    80005076:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000507a:	fd043503          	ld	a0,-48(s0)
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	a3e080e7          	jalr	-1474(ra) # 80003abc <fileclose>
    fileclose(wf);
    80005086:	fc843503          	ld	a0,-56(s0)
    8000508a:	fffff097          	auipc	ra,0xfffff
    8000508e:	a32080e7          	jalr	-1486(ra) # 80003abc <fileclose>
    return -1;
    80005092:	57fd                	li	a5,-1
    80005094:	a805                	j	800050c4 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005096:	fc442783          	lw	a5,-60(s0)
    8000509a:	0007c863          	bltz	a5,800050aa <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000509e:	01a78513          	addi	a0,a5,26
    800050a2:	050e                	slli	a0,a0,0x3
    800050a4:	9526                	add	a0,a0,s1
    800050a6:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050aa:	fd043503          	ld	a0,-48(s0)
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	a0e080e7          	jalr	-1522(ra) # 80003abc <fileclose>
    fileclose(wf);
    800050b6:	fc843503          	ld	a0,-56(s0)
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	a02080e7          	jalr	-1534(ra) # 80003abc <fileclose>
    return -1;
    800050c2:	57fd                	li	a5,-1
}
    800050c4:	853e                	mv	a0,a5
    800050c6:	70e2                	ld	ra,56(sp)
    800050c8:	7442                	ld	s0,48(sp)
    800050ca:	74a2                	ld	s1,40(sp)
    800050cc:	6121                	addi	sp,sp,64
    800050ce:	8082                	ret

00000000800050d0 <kernelvec>:
    800050d0:	7111                	addi	sp,sp,-256
    800050d2:	e006                	sd	ra,0(sp)
    800050d4:	e40a                	sd	sp,8(sp)
    800050d6:	e80e                	sd	gp,16(sp)
    800050d8:	ec12                	sd	tp,24(sp)
    800050da:	f016                	sd	t0,32(sp)
    800050dc:	f41a                	sd	t1,40(sp)
    800050de:	f81e                	sd	t2,48(sp)
    800050e0:	fc22                	sd	s0,56(sp)
    800050e2:	e0a6                	sd	s1,64(sp)
    800050e4:	e4aa                	sd	a0,72(sp)
    800050e6:	e8ae                	sd	a1,80(sp)
    800050e8:	ecb2                	sd	a2,88(sp)
    800050ea:	f0b6                	sd	a3,96(sp)
    800050ec:	f4ba                	sd	a4,104(sp)
    800050ee:	f8be                	sd	a5,112(sp)
    800050f0:	fcc2                	sd	a6,120(sp)
    800050f2:	e146                	sd	a7,128(sp)
    800050f4:	e54a                	sd	s2,136(sp)
    800050f6:	e94e                	sd	s3,144(sp)
    800050f8:	ed52                	sd	s4,152(sp)
    800050fa:	f156                	sd	s5,160(sp)
    800050fc:	f55a                	sd	s6,168(sp)
    800050fe:	f95e                	sd	s7,176(sp)
    80005100:	fd62                	sd	s8,184(sp)
    80005102:	e1e6                	sd	s9,192(sp)
    80005104:	e5ea                	sd	s10,200(sp)
    80005106:	e9ee                	sd	s11,208(sp)
    80005108:	edf2                	sd	t3,216(sp)
    8000510a:	f1f6                	sd	t4,224(sp)
    8000510c:	f5fa                	sd	t5,232(sp)
    8000510e:	f9fe                	sd	t6,240(sp)
    80005110:	ca5fc0ef          	jal	ra,80001db4 <kerneltrap>
    80005114:	6082                	ld	ra,0(sp)
    80005116:	6122                	ld	sp,8(sp)
    80005118:	61c2                	ld	gp,16(sp)
    8000511a:	7282                	ld	t0,32(sp)
    8000511c:	7322                	ld	t1,40(sp)
    8000511e:	73c2                	ld	t2,48(sp)
    80005120:	7462                	ld	s0,56(sp)
    80005122:	6486                	ld	s1,64(sp)
    80005124:	6526                	ld	a0,72(sp)
    80005126:	65c6                	ld	a1,80(sp)
    80005128:	6666                	ld	a2,88(sp)
    8000512a:	7686                	ld	a3,96(sp)
    8000512c:	7726                	ld	a4,104(sp)
    8000512e:	77c6                	ld	a5,112(sp)
    80005130:	7866                	ld	a6,120(sp)
    80005132:	688a                	ld	a7,128(sp)
    80005134:	692a                	ld	s2,136(sp)
    80005136:	69ca                	ld	s3,144(sp)
    80005138:	6a6a                	ld	s4,152(sp)
    8000513a:	7a8a                	ld	s5,160(sp)
    8000513c:	7b2a                	ld	s6,168(sp)
    8000513e:	7bca                	ld	s7,176(sp)
    80005140:	7c6a                	ld	s8,184(sp)
    80005142:	6c8e                	ld	s9,192(sp)
    80005144:	6d2e                	ld	s10,200(sp)
    80005146:	6dce                	ld	s11,208(sp)
    80005148:	6e6e                	ld	t3,216(sp)
    8000514a:	7e8e                	ld	t4,224(sp)
    8000514c:	7f2e                	ld	t5,232(sp)
    8000514e:	7fce                	ld	t6,240(sp)
    80005150:	6111                	addi	sp,sp,256
    80005152:	10200073          	sret
    80005156:	00000013          	nop
    8000515a:	00000013          	nop
    8000515e:	0001                	nop

0000000080005160 <timervec>:
    80005160:	34051573          	csrrw	a0,mscratch,a0
    80005164:	e10c                	sd	a1,0(a0)
    80005166:	e510                	sd	a2,8(a0)
    80005168:	e914                	sd	a3,16(a0)
    8000516a:	6d0c                	ld	a1,24(a0)
    8000516c:	7110                	ld	a2,32(a0)
    8000516e:	6194                	ld	a3,0(a1)
    80005170:	96b2                	add	a3,a3,a2
    80005172:	e194                	sd	a3,0(a1)
    80005174:	4589                	li	a1,2
    80005176:	14459073          	csrw	sip,a1
    8000517a:	6914                	ld	a3,16(a0)
    8000517c:	6510                	ld	a2,8(a0)
    8000517e:	610c                	ld	a1,0(a0)
    80005180:	34051573          	csrrw	a0,mscratch,a0
    80005184:	30200073          	mret
	...

000000008000518a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000518a:	1141                	addi	sp,sp,-16
    8000518c:	e422                	sd	s0,8(sp)
    8000518e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005190:	0c0007b7          	lui	a5,0xc000
    80005194:	4705                	li	a4,1
    80005196:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005198:	c3d8                	sw	a4,4(a5)
}
    8000519a:	6422                	ld	s0,8(sp)
    8000519c:	0141                	addi	sp,sp,16
    8000519e:	8082                	ret

00000000800051a0 <plicinithart>:

void
plicinithart(void)
{
    800051a0:	1141                	addi	sp,sp,-16
    800051a2:	e406                	sd	ra,8(sp)
    800051a4:	e022                	sd	s0,0(sp)
    800051a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	c9a080e7          	jalr	-870(ra) # 80000e42 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051b0:	0085171b          	slliw	a4,a0,0x8
    800051b4:	0c0027b7          	lui	a5,0xc002
    800051b8:	97ba                	add	a5,a5,a4
    800051ba:	40200713          	li	a4,1026
    800051be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051c2:	00d5151b          	slliw	a0,a0,0xd
    800051c6:	0c2017b7          	lui	a5,0xc201
    800051ca:	953e                	add	a0,a0,a5
    800051cc:	00052023          	sw	zero,0(a0)
}
    800051d0:	60a2                	ld	ra,8(sp)
    800051d2:	6402                	ld	s0,0(sp)
    800051d4:	0141                	addi	sp,sp,16
    800051d6:	8082                	ret

00000000800051d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051d8:	1141                	addi	sp,sp,-16
    800051da:	e406                	sd	ra,8(sp)
    800051dc:	e022                	sd	s0,0(sp)
    800051de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051e0:	ffffc097          	auipc	ra,0xffffc
    800051e4:	c62080e7          	jalr	-926(ra) # 80000e42 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051e8:	00d5179b          	slliw	a5,a0,0xd
    800051ec:	0c201537          	lui	a0,0xc201
    800051f0:	953e                	add	a0,a0,a5
  return irq;
}
    800051f2:	4148                	lw	a0,4(a0)
    800051f4:	60a2                	ld	ra,8(sp)
    800051f6:	6402                	ld	s0,0(sp)
    800051f8:	0141                	addi	sp,sp,16
    800051fa:	8082                	ret

00000000800051fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051fc:	1101                	addi	sp,sp,-32
    800051fe:	ec06                	sd	ra,24(sp)
    80005200:	e822                	sd	s0,16(sp)
    80005202:	e426                	sd	s1,8(sp)
    80005204:	1000                	addi	s0,sp,32
    80005206:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	c3a080e7          	jalr	-966(ra) # 80000e42 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005210:	00d5151b          	slliw	a0,a0,0xd
    80005214:	0c2017b7          	lui	a5,0xc201
    80005218:	97aa                	add	a5,a5,a0
    8000521a:	c3c4                	sw	s1,4(a5)
}
    8000521c:	60e2                	ld	ra,24(sp)
    8000521e:	6442                	ld	s0,16(sp)
    80005220:	64a2                	ld	s1,8(sp)
    80005222:	6105                	addi	sp,sp,32
    80005224:	8082                	ret

0000000080005226 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005226:	1141                	addi	sp,sp,-16
    80005228:	e406                	sd	ra,8(sp)
    8000522a:	e022                	sd	s0,0(sp)
    8000522c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000522e:	479d                	li	a5,7
    80005230:	06a7c963          	blt	a5,a0,800052a2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005234:	00016797          	auipc	a5,0x16
    80005238:	dcc78793          	addi	a5,a5,-564 # 8001b000 <disk>
    8000523c:	00a78733          	add	a4,a5,a0
    80005240:	6789                	lui	a5,0x2
    80005242:	97ba                	add	a5,a5,a4
    80005244:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005248:	e7ad                	bnez	a5,800052b2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000524a:	00451793          	slli	a5,a0,0x4
    8000524e:	00018717          	auipc	a4,0x18
    80005252:	db270713          	addi	a4,a4,-590 # 8001d000 <disk+0x2000>
    80005256:	6314                	ld	a3,0(a4)
    80005258:	96be                	add	a3,a3,a5
    8000525a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000525e:	6314                	ld	a3,0(a4)
    80005260:	96be                	add	a3,a3,a5
    80005262:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005266:	6314                	ld	a3,0(a4)
    80005268:	96be                	add	a3,a3,a5
    8000526a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000526e:	6318                	ld	a4,0(a4)
    80005270:	97ba                	add	a5,a5,a4
    80005272:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005276:	00016797          	auipc	a5,0x16
    8000527a:	d8a78793          	addi	a5,a5,-630 # 8001b000 <disk>
    8000527e:	97aa                	add	a5,a5,a0
    80005280:	6509                	lui	a0,0x2
    80005282:	953e                	add	a0,a0,a5
    80005284:	4785                	li	a5,1
    80005286:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000528a:	00018517          	auipc	a0,0x18
    8000528e:	d8e50513          	addi	a0,a0,-626 # 8001d018 <disk+0x2018>
    80005292:	ffffc097          	auipc	ra,0xffffc
    80005296:	438080e7          	jalr	1080(ra) # 800016ca <wakeup>
}
    8000529a:	60a2                	ld	ra,8(sp)
    8000529c:	6402                	ld	s0,0(sp)
    8000529e:	0141                	addi	sp,sp,16
    800052a0:	8082                	ret
    panic("free_desc 1");
    800052a2:	00003517          	auipc	a0,0x3
    800052a6:	61650513          	addi	a0,a0,1558 # 800088b8 <syscall_name+0x368>
    800052aa:	00001097          	auipc	ra,0x1
    800052ae:	a1e080e7          	jalr	-1506(ra) # 80005cc8 <panic>
    panic("free_desc 2");
    800052b2:	00003517          	auipc	a0,0x3
    800052b6:	61650513          	addi	a0,a0,1558 # 800088c8 <syscall_name+0x378>
    800052ba:	00001097          	auipc	ra,0x1
    800052be:	a0e080e7          	jalr	-1522(ra) # 80005cc8 <panic>

00000000800052c2 <virtio_disk_init>:
{
    800052c2:	1101                	addi	sp,sp,-32
    800052c4:	ec06                	sd	ra,24(sp)
    800052c6:	e822                	sd	s0,16(sp)
    800052c8:	e426                	sd	s1,8(sp)
    800052ca:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052cc:	00003597          	auipc	a1,0x3
    800052d0:	60c58593          	addi	a1,a1,1548 # 800088d8 <syscall_name+0x388>
    800052d4:	00018517          	auipc	a0,0x18
    800052d8:	e5450513          	addi	a0,a0,-428 # 8001d128 <disk+0x2128>
    800052dc:	00001097          	auipc	ra,0x1
    800052e0:	ea6080e7          	jalr	-346(ra) # 80006182 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052e4:	100017b7          	lui	a5,0x10001
    800052e8:	4398                	lw	a4,0(a5)
    800052ea:	2701                	sext.w	a4,a4
    800052ec:	747277b7          	lui	a5,0x74727
    800052f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052f4:	0ef71163          	bne	a4,a5,800053d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052f8:	100017b7          	lui	a5,0x10001
    800052fc:	43dc                	lw	a5,4(a5)
    800052fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005300:	4705                	li	a4,1
    80005302:	0ce79a63          	bne	a5,a4,800053d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005306:	100017b7          	lui	a5,0x10001
    8000530a:	479c                	lw	a5,8(a5)
    8000530c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000530e:	4709                	li	a4,2
    80005310:	0ce79363          	bne	a5,a4,800053d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005314:	100017b7          	lui	a5,0x10001
    80005318:	47d8                	lw	a4,12(a5)
    8000531a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000531c:	554d47b7          	lui	a5,0x554d4
    80005320:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005324:	0af71963          	bne	a4,a5,800053d6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005328:	100017b7          	lui	a5,0x10001
    8000532c:	4705                	li	a4,1
    8000532e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005330:	470d                	li	a4,3
    80005332:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005334:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005336:	c7ffe737          	lui	a4,0xc7ffe
    8000533a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000533e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005340:	2701                	sext.w	a4,a4
    80005342:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005344:	472d                	li	a4,11
    80005346:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005348:	473d                	li	a4,15
    8000534a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000534c:	6705                	lui	a4,0x1
    8000534e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005350:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005354:	5bdc                	lw	a5,52(a5)
    80005356:	2781                	sext.w	a5,a5
  if(max == 0)
    80005358:	c7d9                	beqz	a5,800053e6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000535a:	471d                	li	a4,7
    8000535c:	08f77d63          	bgeu	a4,a5,800053f6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005360:	100014b7          	lui	s1,0x10001
    80005364:	47a1                	li	a5,8
    80005366:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005368:	6609                	lui	a2,0x2
    8000536a:	4581                	li	a1,0
    8000536c:	00016517          	auipc	a0,0x16
    80005370:	c9450513          	addi	a0,a0,-876 # 8001b000 <disk>
    80005374:	ffffb097          	auipc	ra,0xffffb
    80005378:	e2a080e7          	jalr	-470(ra) # 8000019e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000537c:	00016717          	auipc	a4,0x16
    80005380:	c8470713          	addi	a4,a4,-892 # 8001b000 <disk>
    80005384:	00c75793          	srli	a5,a4,0xc
    80005388:	2781                	sext.w	a5,a5
    8000538a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000538c:	00018797          	auipc	a5,0x18
    80005390:	c7478793          	addi	a5,a5,-908 # 8001d000 <disk+0x2000>
    80005394:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005396:	00016717          	auipc	a4,0x16
    8000539a:	cea70713          	addi	a4,a4,-790 # 8001b080 <disk+0x80>
    8000539e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800053a0:	00017717          	auipc	a4,0x17
    800053a4:	c6070713          	addi	a4,a4,-928 # 8001c000 <disk+0x1000>
    800053a8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800053aa:	4705                	li	a4,1
    800053ac:	00e78c23          	sb	a4,24(a5)
    800053b0:	00e78ca3          	sb	a4,25(a5)
    800053b4:	00e78d23          	sb	a4,26(a5)
    800053b8:	00e78da3          	sb	a4,27(a5)
    800053bc:	00e78e23          	sb	a4,28(a5)
    800053c0:	00e78ea3          	sb	a4,29(a5)
    800053c4:	00e78f23          	sb	a4,30(a5)
    800053c8:	00e78fa3          	sb	a4,31(a5)
}
    800053cc:	60e2                	ld	ra,24(sp)
    800053ce:	6442                	ld	s0,16(sp)
    800053d0:	64a2                	ld	s1,8(sp)
    800053d2:	6105                	addi	sp,sp,32
    800053d4:	8082                	ret
    panic("could not find virtio disk");
    800053d6:	00003517          	auipc	a0,0x3
    800053da:	51250513          	addi	a0,a0,1298 # 800088e8 <syscall_name+0x398>
    800053de:	00001097          	auipc	ra,0x1
    800053e2:	8ea080e7          	jalr	-1814(ra) # 80005cc8 <panic>
    panic("virtio disk has no queue 0");
    800053e6:	00003517          	auipc	a0,0x3
    800053ea:	52250513          	addi	a0,a0,1314 # 80008908 <syscall_name+0x3b8>
    800053ee:	00001097          	auipc	ra,0x1
    800053f2:	8da080e7          	jalr	-1830(ra) # 80005cc8 <panic>
    panic("virtio disk max queue too short");
    800053f6:	00003517          	auipc	a0,0x3
    800053fa:	53250513          	addi	a0,a0,1330 # 80008928 <syscall_name+0x3d8>
    800053fe:	00001097          	auipc	ra,0x1
    80005402:	8ca080e7          	jalr	-1846(ra) # 80005cc8 <panic>

0000000080005406 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005406:	7159                	addi	sp,sp,-112
    80005408:	f486                	sd	ra,104(sp)
    8000540a:	f0a2                	sd	s0,96(sp)
    8000540c:	eca6                	sd	s1,88(sp)
    8000540e:	e8ca                	sd	s2,80(sp)
    80005410:	e4ce                	sd	s3,72(sp)
    80005412:	e0d2                	sd	s4,64(sp)
    80005414:	fc56                	sd	s5,56(sp)
    80005416:	f85a                	sd	s6,48(sp)
    80005418:	f45e                	sd	s7,40(sp)
    8000541a:	f062                	sd	s8,32(sp)
    8000541c:	ec66                	sd	s9,24(sp)
    8000541e:	e86a                	sd	s10,16(sp)
    80005420:	1880                	addi	s0,sp,112
    80005422:	892a                	mv	s2,a0
    80005424:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005426:	00c52c83          	lw	s9,12(a0)
    8000542a:	001c9c9b          	slliw	s9,s9,0x1
    8000542e:	1c82                	slli	s9,s9,0x20
    80005430:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005434:	00018517          	auipc	a0,0x18
    80005438:	cf450513          	addi	a0,a0,-780 # 8001d128 <disk+0x2128>
    8000543c:	00001097          	auipc	ra,0x1
    80005440:	dd6080e7          	jalr	-554(ra) # 80006212 <acquire>
  for(int i = 0; i < 3; i++){
    80005444:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005446:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005448:	00016b97          	auipc	s7,0x16
    8000544c:	bb8b8b93          	addi	s7,s7,-1096 # 8001b000 <disk>
    80005450:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005452:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005454:	8a4e                	mv	s4,s3
    80005456:	a051                	j	800054da <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005458:	00fb86b3          	add	a3,s7,a5
    8000545c:	96da                	add	a3,a3,s6
    8000545e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005462:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005464:	0207c563          	bltz	a5,8000548e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005468:	2485                	addiw	s1,s1,1
    8000546a:	0711                	addi	a4,a4,4
    8000546c:	25548063          	beq	s1,s5,800056ac <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005470:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005472:	00018697          	auipc	a3,0x18
    80005476:	ba668693          	addi	a3,a3,-1114 # 8001d018 <disk+0x2018>
    8000547a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000547c:	0006c583          	lbu	a1,0(a3)
    80005480:	fde1                	bnez	a1,80005458 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005482:	2785                	addiw	a5,a5,1
    80005484:	0685                	addi	a3,a3,1
    80005486:	ff879be3          	bne	a5,s8,8000547c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000548a:	57fd                	li	a5,-1
    8000548c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000548e:	02905a63          	blez	s1,800054c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005492:	f9042503          	lw	a0,-112(s0)
    80005496:	00000097          	auipc	ra,0x0
    8000549a:	d90080e7          	jalr	-624(ra) # 80005226 <free_desc>
      for(int j = 0; j < i; j++)
    8000549e:	4785                	li	a5,1
    800054a0:	0297d163          	bge	a5,s1,800054c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800054a4:	f9442503          	lw	a0,-108(s0)
    800054a8:	00000097          	auipc	ra,0x0
    800054ac:	d7e080e7          	jalr	-642(ra) # 80005226 <free_desc>
      for(int j = 0; j < i; j++)
    800054b0:	4789                	li	a5,2
    800054b2:	0097d863          	bge	a5,s1,800054c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800054b6:	f9842503          	lw	a0,-104(s0)
    800054ba:	00000097          	auipc	ra,0x0
    800054be:	d6c080e7          	jalr	-660(ra) # 80005226 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054c2:	00018597          	auipc	a1,0x18
    800054c6:	c6658593          	addi	a1,a1,-922 # 8001d128 <disk+0x2128>
    800054ca:	00018517          	auipc	a0,0x18
    800054ce:	b4e50513          	addi	a0,a0,-1202 # 8001d018 <disk+0x2018>
    800054d2:	ffffc097          	auipc	ra,0xffffc
    800054d6:	06c080e7          	jalr	108(ra) # 8000153e <sleep>
  for(int i = 0; i < 3; i++){
    800054da:	f9040713          	addi	a4,s0,-112
    800054de:	84ce                	mv	s1,s3
    800054e0:	bf41                	j	80005470 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054e2:	20058713          	addi	a4,a1,512
    800054e6:	00471693          	slli	a3,a4,0x4
    800054ea:	00016717          	auipc	a4,0x16
    800054ee:	b1670713          	addi	a4,a4,-1258 # 8001b000 <disk>
    800054f2:	9736                	add	a4,a4,a3
    800054f4:	4685                	li	a3,1
    800054f6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054fa:	20058713          	addi	a4,a1,512
    800054fe:	00471693          	slli	a3,a4,0x4
    80005502:	00016717          	auipc	a4,0x16
    80005506:	afe70713          	addi	a4,a4,-1282 # 8001b000 <disk>
    8000550a:	9736                	add	a4,a4,a3
    8000550c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005510:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005514:	7679                	lui	a2,0xffffe
    80005516:	963e                	add	a2,a2,a5
    80005518:	00018697          	auipc	a3,0x18
    8000551c:	ae868693          	addi	a3,a3,-1304 # 8001d000 <disk+0x2000>
    80005520:	6298                	ld	a4,0(a3)
    80005522:	9732                	add	a4,a4,a2
    80005524:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005526:	6298                	ld	a4,0(a3)
    80005528:	9732                	add	a4,a4,a2
    8000552a:	4541                	li	a0,16
    8000552c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000552e:	6298                	ld	a4,0(a3)
    80005530:	9732                	add	a4,a4,a2
    80005532:	4505                	li	a0,1
    80005534:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005538:	f9442703          	lw	a4,-108(s0)
    8000553c:	6288                	ld	a0,0(a3)
    8000553e:	962a                	add	a2,a2,a0
    80005540:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005544:	0712                	slli	a4,a4,0x4
    80005546:	6290                	ld	a2,0(a3)
    80005548:	963a                	add	a2,a2,a4
    8000554a:	05890513          	addi	a0,s2,88
    8000554e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005550:	6294                	ld	a3,0(a3)
    80005552:	96ba                	add	a3,a3,a4
    80005554:	40000613          	li	a2,1024
    80005558:	c690                	sw	a2,8(a3)
  if(write)
    8000555a:	140d0063          	beqz	s10,8000569a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000555e:	00018697          	auipc	a3,0x18
    80005562:	aa26b683          	ld	a3,-1374(a3) # 8001d000 <disk+0x2000>
    80005566:	96ba                	add	a3,a3,a4
    80005568:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000556c:	00016817          	auipc	a6,0x16
    80005570:	a9480813          	addi	a6,a6,-1388 # 8001b000 <disk>
    80005574:	00018517          	auipc	a0,0x18
    80005578:	a8c50513          	addi	a0,a0,-1396 # 8001d000 <disk+0x2000>
    8000557c:	6114                	ld	a3,0(a0)
    8000557e:	96ba                	add	a3,a3,a4
    80005580:	00c6d603          	lhu	a2,12(a3)
    80005584:	00166613          	ori	a2,a2,1
    80005588:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000558c:	f9842683          	lw	a3,-104(s0)
    80005590:	6110                	ld	a2,0(a0)
    80005592:	9732                	add	a4,a4,a2
    80005594:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005598:	20058613          	addi	a2,a1,512
    8000559c:	0612                	slli	a2,a2,0x4
    8000559e:	9642                	add	a2,a2,a6
    800055a0:	577d                	li	a4,-1
    800055a2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055a6:	00469713          	slli	a4,a3,0x4
    800055aa:	6114                	ld	a3,0(a0)
    800055ac:	96ba                	add	a3,a3,a4
    800055ae:	03078793          	addi	a5,a5,48
    800055b2:	97c2                	add	a5,a5,a6
    800055b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800055b6:	611c                	ld	a5,0(a0)
    800055b8:	97ba                	add	a5,a5,a4
    800055ba:	4685                	li	a3,1
    800055bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055be:	611c                	ld	a5,0(a0)
    800055c0:	97ba                	add	a5,a5,a4
    800055c2:	4809                	li	a6,2
    800055c4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800055c8:	611c                	ld	a5,0(a0)
    800055ca:	973e                	add	a4,a4,a5
    800055cc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055d0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800055d4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055d8:	6518                	ld	a4,8(a0)
    800055da:	00275783          	lhu	a5,2(a4)
    800055de:	8b9d                	andi	a5,a5,7
    800055e0:	0786                	slli	a5,a5,0x1
    800055e2:	97ba                	add	a5,a5,a4
    800055e4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055e8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055ec:	6518                	ld	a4,8(a0)
    800055ee:	00275783          	lhu	a5,2(a4)
    800055f2:	2785                	addiw	a5,a5,1
    800055f4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055f8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055fc:	100017b7          	lui	a5,0x10001
    80005600:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005604:	00492703          	lw	a4,4(s2)
    80005608:	4785                	li	a5,1
    8000560a:	02f71163          	bne	a4,a5,8000562c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000560e:	00018997          	auipc	s3,0x18
    80005612:	b1a98993          	addi	s3,s3,-1254 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005616:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005618:	85ce                	mv	a1,s3
    8000561a:	854a                	mv	a0,s2
    8000561c:	ffffc097          	auipc	ra,0xffffc
    80005620:	f22080e7          	jalr	-222(ra) # 8000153e <sleep>
  while(b->disk == 1) {
    80005624:	00492783          	lw	a5,4(s2)
    80005628:	fe9788e3          	beq	a5,s1,80005618 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000562c:	f9042903          	lw	s2,-112(s0)
    80005630:	20090793          	addi	a5,s2,512
    80005634:	00479713          	slli	a4,a5,0x4
    80005638:	00016797          	auipc	a5,0x16
    8000563c:	9c878793          	addi	a5,a5,-1592 # 8001b000 <disk>
    80005640:	97ba                	add	a5,a5,a4
    80005642:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005646:	00018997          	auipc	s3,0x18
    8000564a:	9ba98993          	addi	s3,s3,-1606 # 8001d000 <disk+0x2000>
    8000564e:	00491713          	slli	a4,s2,0x4
    80005652:	0009b783          	ld	a5,0(s3)
    80005656:	97ba                	add	a5,a5,a4
    80005658:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000565c:	854a                	mv	a0,s2
    8000565e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005662:	00000097          	auipc	ra,0x0
    80005666:	bc4080e7          	jalr	-1084(ra) # 80005226 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000566a:	8885                	andi	s1,s1,1
    8000566c:	f0ed                	bnez	s1,8000564e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000566e:	00018517          	auipc	a0,0x18
    80005672:	aba50513          	addi	a0,a0,-1350 # 8001d128 <disk+0x2128>
    80005676:	00001097          	auipc	ra,0x1
    8000567a:	c50080e7          	jalr	-944(ra) # 800062c6 <release>
}
    8000567e:	70a6                	ld	ra,104(sp)
    80005680:	7406                	ld	s0,96(sp)
    80005682:	64e6                	ld	s1,88(sp)
    80005684:	6946                	ld	s2,80(sp)
    80005686:	69a6                	ld	s3,72(sp)
    80005688:	6a06                	ld	s4,64(sp)
    8000568a:	7ae2                	ld	s5,56(sp)
    8000568c:	7b42                	ld	s6,48(sp)
    8000568e:	7ba2                	ld	s7,40(sp)
    80005690:	7c02                	ld	s8,32(sp)
    80005692:	6ce2                	ld	s9,24(sp)
    80005694:	6d42                	ld	s10,16(sp)
    80005696:	6165                	addi	sp,sp,112
    80005698:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000569a:	00018697          	auipc	a3,0x18
    8000569e:	9666b683          	ld	a3,-1690(a3) # 8001d000 <disk+0x2000>
    800056a2:	96ba                	add	a3,a3,a4
    800056a4:	4609                	li	a2,2
    800056a6:	00c69623          	sh	a2,12(a3)
    800056aa:	b5c9                	j	8000556c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056ac:	f9042583          	lw	a1,-112(s0)
    800056b0:	20058793          	addi	a5,a1,512
    800056b4:	0792                	slli	a5,a5,0x4
    800056b6:	00016517          	auipc	a0,0x16
    800056ba:	9f250513          	addi	a0,a0,-1550 # 8001b0a8 <disk+0xa8>
    800056be:	953e                	add	a0,a0,a5
  if(write)
    800056c0:	e20d11e3          	bnez	s10,800054e2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056c4:	20058713          	addi	a4,a1,512
    800056c8:	00471693          	slli	a3,a4,0x4
    800056cc:	00016717          	auipc	a4,0x16
    800056d0:	93470713          	addi	a4,a4,-1740 # 8001b000 <disk>
    800056d4:	9736                	add	a4,a4,a3
    800056d6:	0a072423          	sw	zero,168(a4)
    800056da:	b505                	j	800054fa <virtio_disk_rw+0xf4>

00000000800056dc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056dc:	1101                	addi	sp,sp,-32
    800056de:	ec06                	sd	ra,24(sp)
    800056e0:	e822                	sd	s0,16(sp)
    800056e2:	e426                	sd	s1,8(sp)
    800056e4:	e04a                	sd	s2,0(sp)
    800056e6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056e8:	00018517          	auipc	a0,0x18
    800056ec:	a4050513          	addi	a0,a0,-1472 # 8001d128 <disk+0x2128>
    800056f0:	00001097          	auipc	ra,0x1
    800056f4:	b22080e7          	jalr	-1246(ra) # 80006212 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056f8:	10001737          	lui	a4,0x10001
    800056fc:	533c                	lw	a5,96(a4)
    800056fe:	8b8d                	andi	a5,a5,3
    80005700:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005702:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005706:	00018797          	auipc	a5,0x18
    8000570a:	8fa78793          	addi	a5,a5,-1798 # 8001d000 <disk+0x2000>
    8000570e:	6b94                	ld	a3,16(a5)
    80005710:	0207d703          	lhu	a4,32(a5)
    80005714:	0026d783          	lhu	a5,2(a3)
    80005718:	06f70163          	beq	a4,a5,8000577a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000571c:	00016917          	auipc	s2,0x16
    80005720:	8e490913          	addi	s2,s2,-1820 # 8001b000 <disk>
    80005724:	00018497          	auipc	s1,0x18
    80005728:	8dc48493          	addi	s1,s1,-1828 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000572c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005730:	6898                	ld	a4,16(s1)
    80005732:	0204d783          	lhu	a5,32(s1)
    80005736:	8b9d                	andi	a5,a5,7
    80005738:	078e                	slli	a5,a5,0x3
    8000573a:	97ba                	add	a5,a5,a4
    8000573c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000573e:	20078713          	addi	a4,a5,512
    80005742:	0712                	slli	a4,a4,0x4
    80005744:	974a                	add	a4,a4,s2
    80005746:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000574a:	e731                	bnez	a4,80005796 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000574c:	20078793          	addi	a5,a5,512
    80005750:	0792                	slli	a5,a5,0x4
    80005752:	97ca                	add	a5,a5,s2
    80005754:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005756:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000575a:	ffffc097          	auipc	ra,0xffffc
    8000575e:	f70080e7          	jalr	-144(ra) # 800016ca <wakeup>

    disk.used_idx += 1;
    80005762:	0204d783          	lhu	a5,32(s1)
    80005766:	2785                	addiw	a5,a5,1
    80005768:	17c2                	slli	a5,a5,0x30
    8000576a:	93c1                	srli	a5,a5,0x30
    8000576c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005770:	6898                	ld	a4,16(s1)
    80005772:	00275703          	lhu	a4,2(a4)
    80005776:	faf71be3          	bne	a4,a5,8000572c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000577a:	00018517          	auipc	a0,0x18
    8000577e:	9ae50513          	addi	a0,a0,-1618 # 8001d128 <disk+0x2128>
    80005782:	00001097          	auipc	ra,0x1
    80005786:	b44080e7          	jalr	-1212(ra) # 800062c6 <release>
}
    8000578a:	60e2                	ld	ra,24(sp)
    8000578c:	6442                	ld	s0,16(sp)
    8000578e:	64a2                	ld	s1,8(sp)
    80005790:	6902                	ld	s2,0(sp)
    80005792:	6105                	addi	sp,sp,32
    80005794:	8082                	ret
      panic("virtio_disk_intr status");
    80005796:	00003517          	auipc	a0,0x3
    8000579a:	1b250513          	addi	a0,a0,434 # 80008948 <syscall_name+0x3f8>
    8000579e:	00000097          	auipc	ra,0x0
    800057a2:	52a080e7          	jalr	1322(ra) # 80005cc8 <panic>

00000000800057a6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057a6:	1141                	addi	sp,sp,-16
    800057a8:	e422                	sd	s0,8(sp)
    800057aa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057ac:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057b0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057b4:	0037979b          	slliw	a5,a5,0x3
    800057b8:	02004737          	lui	a4,0x2004
    800057bc:	97ba                	add	a5,a5,a4
    800057be:	0200c737          	lui	a4,0x200c
    800057c2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057c6:	000f4637          	lui	a2,0xf4
    800057ca:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057ce:	95b2                	add	a1,a1,a2
    800057d0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057d2:	00269713          	slli	a4,a3,0x2
    800057d6:	9736                	add	a4,a4,a3
    800057d8:	00371693          	slli	a3,a4,0x3
    800057dc:	00019717          	auipc	a4,0x19
    800057e0:	82470713          	addi	a4,a4,-2012 # 8001e000 <timer_scratch>
    800057e4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057e6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057e8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057ea:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057ee:	00000797          	auipc	a5,0x0
    800057f2:	97278793          	addi	a5,a5,-1678 # 80005160 <timervec>
    800057f6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057fa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057fe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005802:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005806:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000580a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000580e:	30479073          	csrw	mie,a5
}
    80005812:	6422                	ld	s0,8(sp)
    80005814:	0141                	addi	sp,sp,16
    80005816:	8082                	ret

0000000080005818 <start>:
{
    80005818:	1141                	addi	sp,sp,-16
    8000581a:	e406                	sd	ra,8(sp)
    8000581c:	e022                	sd	s0,0(sp)
    8000581e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005820:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005824:	7779                	lui	a4,0xffffe
    80005826:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000582a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000582c:	6705                	lui	a4,0x1
    8000582e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005832:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005834:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005838:	ffffb797          	auipc	a5,0xffffb
    8000583c:	b1478793          	addi	a5,a5,-1260 # 8000034c <main>
    80005840:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005844:	4781                	li	a5,0
    80005846:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000584a:	67c1                	lui	a5,0x10
    8000584c:	17fd                	addi	a5,a5,-1
    8000584e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005852:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005856:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000585a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000585e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005862:	57fd                	li	a5,-1
    80005864:	83a9                	srli	a5,a5,0xa
    80005866:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000586a:	47bd                	li	a5,15
    8000586c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005870:	00000097          	auipc	ra,0x0
    80005874:	f36080e7          	jalr	-202(ra) # 800057a6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005878:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000587c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000587e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005880:	30200073          	mret
}
    80005884:	60a2                	ld	ra,8(sp)
    80005886:	6402                	ld	s0,0(sp)
    80005888:	0141                	addi	sp,sp,16
    8000588a:	8082                	ret

000000008000588c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000588c:	715d                	addi	sp,sp,-80
    8000588e:	e486                	sd	ra,72(sp)
    80005890:	e0a2                	sd	s0,64(sp)
    80005892:	fc26                	sd	s1,56(sp)
    80005894:	f84a                	sd	s2,48(sp)
    80005896:	f44e                	sd	s3,40(sp)
    80005898:	f052                	sd	s4,32(sp)
    8000589a:	ec56                	sd	s5,24(sp)
    8000589c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000589e:	04c05663          	blez	a2,800058ea <consolewrite+0x5e>
    800058a2:	8a2a                	mv	s4,a0
    800058a4:	84ae                	mv	s1,a1
    800058a6:	89b2                	mv	s3,a2
    800058a8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058aa:	5afd                	li	s5,-1
    800058ac:	4685                	li	a3,1
    800058ae:	8626                	mv	a2,s1
    800058b0:	85d2                	mv	a1,s4
    800058b2:	fbf40513          	addi	a0,s0,-65
    800058b6:	ffffc097          	auipc	ra,0xffffc
    800058ba:	082080e7          	jalr	130(ra) # 80001938 <either_copyin>
    800058be:	01550c63          	beq	a0,s5,800058d6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800058c2:	fbf44503          	lbu	a0,-65(s0)
    800058c6:	00000097          	auipc	ra,0x0
    800058ca:	78e080e7          	jalr	1934(ra) # 80006054 <uartputc>
  for(i = 0; i < n; i++){
    800058ce:	2905                	addiw	s2,s2,1
    800058d0:	0485                	addi	s1,s1,1
    800058d2:	fd299de3          	bne	s3,s2,800058ac <consolewrite+0x20>
  }

  return i;
}
    800058d6:	854a                	mv	a0,s2
    800058d8:	60a6                	ld	ra,72(sp)
    800058da:	6406                	ld	s0,64(sp)
    800058dc:	74e2                	ld	s1,56(sp)
    800058de:	7942                	ld	s2,48(sp)
    800058e0:	79a2                	ld	s3,40(sp)
    800058e2:	7a02                	ld	s4,32(sp)
    800058e4:	6ae2                	ld	s5,24(sp)
    800058e6:	6161                	addi	sp,sp,80
    800058e8:	8082                	ret
  for(i = 0; i < n; i++){
    800058ea:	4901                	li	s2,0
    800058ec:	b7ed                	j	800058d6 <consolewrite+0x4a>

00000000800058ee <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058ee:	7119                	addi	sp,sp,-128
    800058f0:	fc86                	sd	ra,120(sp)
    800058f2:	f8a2                	sd	s0,112(sp)
    800058f4:	f4a6                	sd	s1,104(sp)
    800058f6:	f0ca                	sd	s2,96(sp)
    800058f8:	ecce                	sd	s3,88(sp)
    800058fa:	e8d2                	sd	s4,80(sp)
    800058fc:	e4d6                	sd	s5,72(sp)
    800058fe:	e0da                	sd	s6,64(sp)
    80005900:	fc5e                	sd	s7,56(sp)
    80005902:	f862                	sd	s8,48(sp)
    80005904:	f466                	sd	s9,40(sp)
    80005906:	f06a                	sd	s10,32(sp)
    80005908:	ec6e                	sd	s11,24(sp)
    8000590a:	0100                	addi	s0,sp,128
    8000590c:	8b2a                	mv	s6,a0
    8000590e:	8aae                	mv	s5,a1
    80005910:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005912:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005916:	00021517          	auipc	a0,0x21
    8000591a:	82a50513          	addi	a0,a0,-2006 # 80026140 <cons>
    8000591e:	00001097          	auipc	ra,0x1
    80005922:	8f4080e7          	jalr	-1804(ra) # 80006212 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005926:	00021497          	auipc	s1,0x21
    8000592a:	81a48493          	addi	s1,s1,-2022 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000592e:	89a6                	mv	s3,s1
    80005930:	00021917          	auipc	s2,0x21
    80005934:	8a890913          	addi	s2,s2,-1880 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005938:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000593a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000593c:	4da9                	li	s11,10
  while(n > 0){
    8000593e:	07405863          	blez	s4,800059ae <consoleread+0xc0>
    while(cons.r == cons.w){
    80005942:	0984a783          	lw	a5,152(s1)
    80005946:	09c4a703          	lw	a4,156(s1)
    8000594a:	02f71463          	bne	a4,a5,80005972 <consoleread+0x84>
      if(myproc()->killed){
    8000594e:	ffffb097          	auipc	ra,0xffffb
    80005952:	520080e7          	jalr	1312(ra) # 80000e6e <myproc>
    80005956:	551c                	lw	a5,40(a0)
    80005958:	e7b5                	bnez	a5,800059c4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000595a:	85ce                	mv	a1,s3
    8000595c:	854a                	mv	a0,s2
    8000595e:	ffffc097          	auipc	ra,0xffffc
    80005962:	be0080e7          	jalr	-1056(ra) # 8000153e <sleep>
    while(cons.r == cons.w){
    80005966:	0984a783          	lw	a5,152(s1)
    8000596a:	09c4a703          	lw	a4,156(s1)
    8000596e:	fef700e3          	beq	a4,a5,8000594e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005972:	0017871b          	addiw	a4,a5,1
    80005976:	08e4ac23          	sw	a4,152(s1)
    8000597a:	07f7f713          	andi	a4,a5,127
    8000597e:	9726                	add	a4,a4,s1
    80005980:	01874703          	lbu	a4,24(a4)
    80005984:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005988:	079c0663          	beq	s8,s9,800059f4 <consoleread+0x106>
    cbuf = c;
    8000598c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005990:	4685                	li	a3,1
    80005992:	f8f40613          	addi	a2,s0,-113
    80005996:	85d6                	mv	a1,s5
    80005998:	855a                	mv	a0,s6
    8000599a:	ffffc097          	auipc	ra,0xffffc
    8000599e:	f48080e7          	jalr	-184(ra) # 800018e2 <either_copyout>
    800059a2:	01a50663          	beq	a0,s10,800059ae <consoleread+0xc0>
    dst++;
    800059a6:	0a85                	addi	s5,s5,1
    --n;
    800059a8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800059aa:	f9bc1ae3          	bne	s8,s11,8000593e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059ae:	00020517          	auipc	a0,0x20
    800059b2:	79250513          	addi	a0,a0,1938 # 80026140 <cons>
    800059b6:	00001097          	auipc	ra,0x1
    800059ba:	910080e7          	jalr	-1776(ra) # 800062c6 <release>

  return target - n;
    800059be:	414b853b          	subw	a0,s7,s4
    800059c2:	a811                	j	800059d6 <consoleread+0xe8>
        release(&cons.lock);
    800059c4:	00020517          	auipc	a0,0x20
    800059c8:	77c50513          	addi	a0,a0,1916 # 80026140 <cons>
    800059cc:	00001097          	auipc	ra,0x1
    800059d0:	8fa080e7          	jalr	-1798(ra) # 800062c6 <release>
        return -1;
    800059d4:	557d                	li	a0,-1
}
    800059d6:	70e6                	ld	ra,120(sp)
    800059d8:	7446                	ld	s0,112(sp)
    800059da:	74a6                	ld	s1,104(sp)
    800059dc:	7906                	ld	s2,96(sp)
    800059de:	69e6                	ld	s3,88(sp)
    800059e0:	6a46                	ld	s4,80(sp)
    800059e2:	6aa6                	ld	s5,72(sp)
    800059e4:	6b06                	ld	s6,64(sp)
    800059e6:	7be2                	ld	s7,56(sp)
    800059e8:	7c42                	ld	s8,48(sp)
    800059ea:	7ca2                	ld	s9,40(sp)
    800059ec:	7d02                	ld	s10,32(sp)
    800059ee:	6de2                	ld	s11,24(sp)
    800059f0:	6109                	addi	sp,sp,128
    800059f2:	8082                	ret
      if(n < target){
    800059f4:	000a071b          	sext.w	a4,s4
    800059f8:	fb777be3          	bgeu	a4,s7,800059ae <consoleread+0xc0>
        cons.r--;
    800059fc:	00020717          	auipc	a4,0x20
    80005a00:	7cf72e23          	sw	a5,2012(a4) # 800261d8 <cons+0x98>
    80005a04:	b76d                	j	800059ae <consoleread+0xc0>

0000000080005a06 <consputc>:
{
    80005a06:	1141                	addi	sp,sp,-16
    80005a08:	e406                	sd	ra,8(sp)
    80005a0a:	e022                	sd	s0,0(sp)
    80005a0c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a0e:	10000793          	li	a5,256
    80005a12:	00f50a63          	beq	a0,a5,80005a26 <consputc+0x20>
    uartputc_sync(c);
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	564080e7          	jalr	1380(ra) # 80005f7a <uartputc_sync>
}
    80005a1e:	60a2                	ld	ra,8(sp)
    80005a20:	6402                	ld	s0,0(sp)
    80005a22:	0141                	addi	sp,sp,16
    80005a24:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a26:	4521                	li	a0,8
    80005a28:	00000097          	auipc	ra,0x0
    80005a2c:	552080e7          	jalr	1362(ra) # 80005f7a <uartputc_sync>
    80005a30:	02000513          	li	a0,32
    80005a34:	00000097          	auipc	ra,0x0
    80005a38:	546080e7          	jalr	1350(ra) # 80005f7a <uartputc_sync>
    80005a3c:	4521                	li	a0,8
    80005a3e:	00000097          	auipc	ra,0x0
    80005a42:	53c080e7          	jalr	1340(ra) # 80005f7a <uartputc_sync>
    80005a46:	bfe1                	j	80005a1e <consputc+0x18>

0000000080005a48 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a48:	1101                	addi	sp,sp,-32
    80005a4a:	ec06                	sd	ra,24(sp)
    80005a4c:	e822                	sd	s0,16(sp)
    80005a4e:	e426                	sd	s1,8(sp)
    80005a50:	e04a                	sd	s2,0(sp)
    80005a52:	1000                	addi	s0,sp,32
    80005a54:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a56:	00020517          	auipc	a0,0x20
    80005a5a:	6ea50513          	addi	a0,a0,1770 # 80026140 <cons>
    80005a5e:	00000097          	auipc	ra,0x0
    80005a62:	7b4080e7          	jalr	1972(ra) # 80006212 <acquire>

  switch(c){
    80005a66:	47d5                	li	a5,21
    80005a68:	0af48663          	beq	s1,a5,80005b14 <consoleintr+0xcc>
    80005a6c:	0297ca63          	blt	a5,s1,80005aa0 <consoleintr+0x58>
    80005a70:	47a1                	li	a5,8
    80005a72:	0ef48763          	beq	s1,a5,80005b60 <consoleintr+0x118>
    80005a76:	47c1                	li	a5,16
    80005a78:	10f49a63          	bne	s1,a5,80005b8c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a7c:	ffffc097          	auipc	ra,0xffffc
    80005a80:	f12080e7          	jalr	-238(ra) # 8000198e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a84:	00020517          	auipc	a0,0x20
    80005a88:	6bc50513          	addi	a0,a0,1724 # 80026140 <cons>
    80005a8c:	00001097          	auipc	ra,0x1
    80005a90:	83a080e7          	jalr	-1990(ra) # 800062c6 <release>
}
    80005a94:	60e2                	ld	ra,24(sp)
    80005a96:	6442                	ld	s0,16(sp)
    80005a98:	64a2                	ld	s1,8(sp)
    80005a9a:	6902                	ld	s2,0(sp)
    80005a9c:	6105                	addi	sp,sp,32
    80005a9e:	8082                	ret
  switch(c){
    80005aa0:	07f00793          	li	a5,127
    80005aa4:	0af48e63          	beq	s1,a5,80005b60 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005aa8:	00020717          	auipc	a4,0x20
    80005aac:	69870713          	addi	a4,a4,1688 # 80026140 <cons>
    80005ab0:	0a072783          	lw	a5,160(a4)
    80005ab4:	09872703          	lw	a4,152(a4)
    80005ab8:	9f99                	subw	a5,a5,a4
    80005aba:	07f00713          	li	a4,127
    80005abe:	fcf763e3          	bltu	a4,a5,80005a84 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005ac2:	47b5                	li	a5,13
    80005ac4:	0cf48763          	beq	s1,a5,80005b92 <consoleintr+0x14a>
      consputc(c);
    80005ac8:	8526                	mv	a0,s1
    80005aca:	00000097          	auipc	ra,0x0
    80005ace:	f3c080e7          	jalr	-196(ra) # 80005a06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ad2:	00020797          	auipc	a5,0x20
    80005ad6:	66e78793          	addi	a5,a5,1646 # 80026140 <cons>
    80005ada:	0a07a703          	lw	a4,160(a5)
    80005ade:	0017069b          	addiw	a3,a4,1
    80005ae2:	0006861b          	sext.w	a2,a3
    80005ae6:	0ad7a023          	sw	a3,160(a5)
    80005aea:	07f77713          	andi	a4,a4,127
    80005aee:	97ba                	add	a5,a5,a4
    80005af0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005af4:	47a9                	li	a5,10
    80005af6:	0cf48563          	beq	s1,a5,80005bc0 <consoleintr+0x178>
    80005afa:	4791                	li	a5,4
    80005afc:	0cf48263          	beq	s1,a5,80005bc0 <consoleintr+0x178>
    80005b00:	00020797          	auipc	a5,0x20
    80005b04:	6d87a783          	lw	a5,1752(a5) # 800261d8 <cons+0x98>
    80005b08:	0807879b          	addiw	a5,a5,128
    80005b0c:	f6f61ce3          	bne	a2,a5,80005a84 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b10:	863e                	mv	a2,a5
    80005b12:	a07d                	j	80005bc0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b14:	00020717          	auipc	a4,0x20
    80005b18:	62c70713          	addi	a4,a4,1580 # 80026140 <cons>
    80005b1c:	0a072783          	lw	a5,160(a4)
    80005b20:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b24:	00020497          	auipc	s1,0x20
    80005b28:	61c48493          	addi	s1,s1,1564 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005b2c:	4929                	li	s2,10
    80005b2e:	f4f70be3          	beq	a4,a5,80005a84 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b32:	37fd                	addiw	a5,a5,-1
    80005b34:	07f7f713          	andi	a4,a5,127
    80005b38:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b3a:	01874703          	lbu	a4,24(a4)
    80005b3e:	f52703e3          	beq	a4,s2,80005a84 <consoleintr+0x3c>
      cons.e--;
    80005b42:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b46:	10000513          	li	a0,256
    80005b4a:	00000097          	auipc	ra,0x0
    80005b4e:	ebc080e7          	jalr	-324(ra) # 80005a06 <consputc>
    while(cons.e != cons.w &&
    80005b52:	0a04a783          	lw	a5,160(s1)
    80005b56:	09c4a703          	lw	a4,156(s1)
    80005b5a:	fcf71ce3          	bne	a4,a5,80005b32 <consoleintr+0xea>
    80005b5e:	b71d                	j	80005a84 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b60:	00020717          	auipc	a4,0x20
    80005b64:	5e070713          	addi	a4,a4,1504 # 80026140 <cons>
    80005b68:	0a072783          	lw	a5,160(a4)
    80005b6c:	09c72703          	lw	a4,156(a4)
    80005b70:	f0f70ae3          	beq	a4,a5,80005a84 <consoleintr+0x3c>
      cons.e--;
    80005b74:	37fd                	addiw	a5,a5,-1
    80005b76:	00020717          	auipc	a4,0x20
    80005b7a:	66f72523          	sw	a5,1642(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b7e:	10000513          	li	a0,256
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	e84080e7          	jalr	-380(ra) # 80005a06 <consputc>
    80005b8a:	bded                	j	80005a84 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b8c:	ee048ce3          	beqz	s1,80005a84 <consoleintr+0x3c>
    80005b90:	bf21                	j	80005aa8 <consoleintr+0x60>
      consputc(c);
    80005b92:	4529                	li	a0,10
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	e72080e7          	jalr	-398(ra) # 80005a06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b9c:	00020797          	auipc	a5,0x20
    80005ba0:	5a478793          	addi	a5,a5,1444 # 80026140 <cons>
    80005ba4:	0a07a703          	lw	a4,160(a5)
    80005ba8:	0017069b          	addiw	a3,a4,1
    80005bac:	0006861b          	sext.w	a2,a3
    80005bb0:	0ad7a023          	sw	a3,160(a5)
    80005bb4:	07f77713          	andi	a4,a4,127
    80005bb8:	97ba                	add	a5,a5,a4
    80005bba:	4729                	li	a4,10
    80005bbc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bc0:	00020797          	auipc	a5,0x20
    80005bc4:	60c7ae23          	sw	a2,1564(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005bc8:	00020517          	auipc	a0,0x20
    80005bcc:	61050513          	addi	a0,a0,1552 # 800261d8 <cons+0x98>
    80005bd0:	ffffc097          	auipc	ra,0xffffc
    80005bd4:	afa080e7          	jalr	-1286(ra) # 800016ca <wakeup>
    80005bd8:	b575                	j	80005a84 <consoleintr+0x3c>

0000000080005bda <consoleinit>:

void
consoleinit(void)
{
    80005bda:	1141                	addi	sp,sp,-16
    80005bdc:	e406                	sd	ra,8(sp)
    80005bde:	e022                	sd	s0,0(sp)
    80005be0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005be2:	00003597          	auipc	a1,0x3
    80005be6:	d7e58593          	addi	a1,a1,-642 # 80008960 <syscall_name+0x410>
    80005bea:	00020517          	auipc	a0,0x20
    80005bee:	55650513          	addi	a0,a0,1366 # 80026140 <cons>
    80005bf2:	00000097          	auipc	ra,0x0
    80005bf6:	590080e7          	jalr	1424(ra) # 80006182 <initlock>

  uartinit();
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	330080e7          	jalr	816(ra) # 80005f2a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c02:	00014797          	auipc	a5,0x14
    80005c06:	cc678793          	addi	a5,a5,-826 # 800198c8 <devsw>
    80005c0a:	00000717          	auipc	a4,0x0
    80005c0e:	ce470713          	addi	a4,a4,-796 # 800058ee <consoleread>
    80005c12:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c14:	00000717          	auipc	a4,0x0
    80005c18:	c7870713          	addi	a4,a4,-904 # 8000588c <consolewrite>
    80005c1c:	ef98                	sd	a4,24(a5)
}
    80005c1e:	60a2                	ld	ra,8(sp)
    80005c20:	6402                	ld	s0,0(sp)
    80005c22:	0141                	addi	sp,sp,16
    80005c24:	8082                	ret

0000000080005c26 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c26:	7179                	addi	sp,sp,-48
    80005c28:	f406                	sd	ra,40(sp)
    80005c2a:	f022                	sd	s0,32(sp)
    80005c2c:	ec26                	sd	s1,24(sp)
    80005c2e:	e84a                	sd	s2,16(sp)
    80005c30:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c32:	c219                	beqz	a2,80005c38 <printint+0x12>
    80005c34:	08054663          	bltz	a0,80005cc0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c38:	2501                	sext.w	a0,a0
    80005c3a:	4881                	li	a7,0
    80005c3c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c40:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c42:	2581                	sext.w	a1,a1
    80005c44:	00003617          	auipc	a2,0x3
    80005c48:	d4c60613          	addi	a2,a2,-692 # 80008990 <digits>
    80005c4c:	883a                	mv	a6,a4
    80005c4e:	2705                	addiw	a4,a4,1
    80005c50:	02b577bb          	remuw	a5,a0,a1
    80005c54:	1782                	slli	a5,a5,0x20
    80005c56:	9381                	srli	a5,a5,0x20
    80005c58:	97b2                	add	a5,a5,a2
    80005c5a:	0007c783          	lbu	a5,0(a5)
    80005c5e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c62:	0005079b          	sext.w	a5,a0
    80005c66:	02b5553b          	divuw	a0,a0,a1
    80005c6a:	0685                	addi	a3,a3,1
    80005c6c:	feb7f0e3          	bgeu	a5,a1,80005c4c <printint+0x26>

  if(sign)
    80005c70:	00088b63          	beqz	a7,80005c86 <printint+0x60>
    buf[i++] = '-';
    80005c74:	fe040793          	addi	a5,s0,-32
    80005c78:	973e                	add	a4,a4,a5
    80005c7a:	02d00793          	li	a5,45
    80005c7e:	fef70823          	sb	a5,-16(a4)
    80005c82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c86:	02e05763          	blez	a4,80005cb4 <printint+0x8e>
    80005c8a:	fd040793          	addi	a5,s0,-48
    80005c8e:	00e784b3          	add	s1,a5,a4
    80005c92:	fff78913          	addi	s2,a5,-1
    80005c96:	993a                	add	s2,s2,a4
    80005c98:	377d                	addiw	a4,a4,-1
    80005c9a:	1702                	slli	a4,a4,0x20
    80005c9c:	9301                	srli	a4,a4,0x20
    80005c9e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ca2:	fff4c503          	lbu	a0,-1(s1)
    80005ca6:	00000097          	auipc	ra,0x0
    80005caa:	d60080e7          	jalr	-672(ra) # 80005a06 <consputc>
  while(--i >= 0)
    80005cae:	14fd                	addi	s1,s1,-1
    80005cb0:	ff2499e3          	bne	s1,s2,80005ca2 <printint+0x7c>
}
    80005cb4:	70a2                	ld	ra,40(sp)
    80005cb6:	7402                	ld	s0,32(sp)
    80005cb8:	64e2                	ld	s1,24(sp)
    80005cba:	6942                	ld	s2,16(sp)
    80005cbc:	6145                	addi	sp,sp,48
    80005cbe:	8082                	ret
    x = -xx;
    80005cc0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005cc4:	4885                	li	a7,1
    x = -xx;
    80005cc6:	bf9d                	j	80005c3c <printint+0x16>

0000000080005cc8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005cc8:	1101                	addi	sp,sp,-32
    80005cca:	ec06                	sd	ra,24(sp)
    80005ccc:	e822                	sd	s0,16(sp)
    80005cce:	e426                	sd	s1,8(sp)
    80005cd0:	1000                	addi	s0,sp,32
    80005cd2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cd4:	00020797          	auipc	a5,0x20
    80005cd8:	5207a623          	sw	zero,1324(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cdc:	00003517          	auipc	a0,0x3
    80005ce0:	c8c50513          	addi	a0,a0,-884 # 80008968 <syscall_name+0x418>
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	02e080e7          	jalr	46(ra) # 80005d12 <printf>
  printf(s);
    80005cec:	8526                	mv	a0,s1
    80005cee:	00000097          	auipc	ra,0x0
    80005cf2:	024080e7          	jalr	36(ra) # 80005d12 <printf>
  printf("\n");
    80005cf6:	00002517          	auipc	a0,0x2
    80005cfa:	35250513          	addi	a0,a0,850 # 80008048 <etext+0x48>
    80005cfe:	00000097          	auipc	ra,0x0
    80005d02:	014080e7          	jalr	20(ra) # 80005d12 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d06:	4785                	li	a5,1
    80005d08:	00003717          	auipc	a4,0x3
    80005d0c:	30f72a23          	sw	a5,788(a4) # 8000901c <panicked>
  for(;;)
    80005d10:	a001                	j	80005d10 <panic+0x48>

0000000080005d12 <printf>:
{
    80005d12:	7131                	addi	sp,sp,-192
    80005d14:	fc86                	sd	ra,120(sp)
    80005d16:	f8a2                	sd	s0,112(sp)
    80005d18:	f4a6                	sd	s1,104(sp)
    80005d1a:	f0ca                	sd	s2,96(sp)
    80005d1c:	ecce                	sd	s3,88(sp)
    80005d1e:	e8d2                	sd	s4,80(sp)
    80005d20:	e4d6                	sd	s5,72(sp)
    80005d22:	e0da                	sd	s6,64(sp)
    80005d24:	fc5e                	sd	s7,56(sp)
    80005d26:	f862                	sd	s8,48(sp)
    80005d28:	f466                	sd	s9,40(sp)
    80005d2a:	f06a                	sd	s10,32(sp)
    80005d2c:	ec6e                	sd	s11,24(sp)
    80005d2e:	0100                	addi	s0,sp,128
    80005d30:	8a2a                	mv	s4,a0
    80005d32:	e40c                	sd	a1,8(s0)
    80005d34:	e810                	sd	a2,16(s0)
    80005d36:	ec14                	sd	a3,24(s0)
    80005d38:	f018                	sd	a4,32(s0)
    80005d3a:	f41c                	sd	a5,40(s0)
    80005d3c:	03043823          	sd	a6,48(s0)
    80005d40:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d44:	00020d97          	auipc	s11,0x20
    80005d48:	4bcdad83          	lw	s11,1212(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d4c:	020d9b63          	bnez	s11,80005d82 <printf+0x70>
  if (fmt == 0)
    80005d50:	040a0263          	beqz	s4,80005d94 <printf+0x82>
  va_start(ap, fmt);
    80005d54:	00840793          	addi	a5,s0,8
    80005d58:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d5c:	000a4503          	lbu	a0,0(s4)
    80005d60:	16050263          	beqz	a0,80005ec4 <printf+0x1b2>
    80005d64:	4481                	li	s1,0
    if(c != '%'){
    80005d66:	02500a93          	li	s5,37
    switch(c){
    80005d6a:	07000b13          	li	s6,112
  consputc('x');
    80005d6e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d70:	00003b97          	auipc	s7,0x3
    80005d74:	c20b8b93          	addi	s7,s7,-992 # 80008990 <digits>
    switch(c){
    80005d78:	07300c93          	li	s9,115
    80005d7c:	06400c13          	li	s8,100
    80005d80:	a82d                	j	80005dba <printf+0xa8>
    acquire(&pr.lock);
    80005d82:	00020517          	auipc	a0,0x20
    80005d86:	46650513          	addi	a0,a0,1126 # 800261e8 <pr>
    80005d8a:	00000097          	auipc	ra,0x0
    80005d8e:	488080e7          	jalr	1160(ra) # 80006212 <acquire>
    80005d92:	bf7d                	j	80005d50 <printf+0x3e>
    panic("null fmt");
    80005d94:	00003517          	auipc	a0,0x3
    80005d98:	be450513          	addi	a0,a0,-1052 # 80008978 <syscall_name+0x428>
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	f2c080e7          	jalr	-212(ra) # 80005cc8 <panic>
      consputc(c);
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	c62080e7          	jalr	-926(ra) # 80005a06 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dac:	2485                	addiw	s1,s1,1
    80005dae:	009a07b3          	add	a5,s4,s1
    80005db2:	0007c503          	lbu	a0,0(a5)
    80005db6:	10050763          	beqz	a0,80005ec4 <printf+0x1b2>
    if(c != '%'){
    80005dba:	ff5515e3          	bne	a0,s5,80005da4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005dbe:	2485                	addiw	s1,s1,1
    80005dc0:	009a07b3          	add	a5,s4,s1
    80005dc4:	0007c783          	lbu	a5,0(a5)
    80005dc8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005dcc:	cfe5                	beqz	a5,80005ec4 <printf+0x1b2>
    switch(c){
    80005dce:	05678a63          	beq	a5,s6,80005e22 <printf+0x110>
    80005dd2:	02fb7663          	bgeu	s6,a5,80005dfe <printf+0xec>
    80005dd6:	09978963          	beq	a5,s9,80005e68 <printf+0x156>
    80005dda:	07800713          	li	a4,120
    80005dde:	0ce79863          	bne	a5,a4,80005eae <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005de2:	f8843783          	ld	a5,-120(s0)
    80005de6:	00878713          	addi	a4,a5,8
    80005dea:	f8e43423          	sd	a4,-120(s0)
    80005dee:	4605                	li	a2,1
    80005df0:	85ea                	mv	a1,s10
    80005df2:	4388                	lw	a0,0(a5)
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	e32080e7          	jalr	-462(ra) # 80005c26 <printint>
      break;
    80005dfc:	bf45                	j	80005dac <printf+0x9a>
    switch(c){
    80005dfe:	0b578263          	beq	a5,s5,80005ea2 <printf+0x190>
    80005e02:	0b879663          	bne	a5,s8,80005eae <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e06:	f8843783          	ld	a5,-120(s0)
    80005e0a:	00878713          	addi	a4,a5,8
    80005e0e:	f8e43423          	sd	a4,-120(s0)
    80005e12:	4605                	li	a2,1
    80005e14:	45a9                	li	a1,10
    80005e16:	4388                	lw	a0,0(a5)
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	e0e080e7          	jalr	-498(ra) # 80005c26 <printint>
      break;
    80005e20:	b771                	j	80005dac <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e22:	f8843783          	ld	a5,-120(s0)
    80005e26:	00878713          	addi	a4,a5,8
    80005e2a:	f8e43423          	sd	a4,-120(s0)
    80005e2e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e32:	03000513          	li	a0,48
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	bd0080e7          	jalr	-1072(ra) # 80005a06 <consputc>
  consputc('x');
    80005e3e:	07800513          	li	a0,120
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	bc4080e7          	jalr	-1084(ra) # 80005a06 <consputc>
    80005e4a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e4c:	03c9d793          	srli	a5,s3,0x3c
    80005e50:	97de                	add	a5,a5,s7
    80005e52:	0007c503          	lbu	a0,0(a5)
    80005e56:	00000097          	auipc	ra,0x0
    80005e5a:	bb0080e7          	jalr	-1104(ra) # 80005a06 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e5e:	0992                	slli	s3,s3,0x4
    80005e60:	397d                	addiw	s2,s2,-1
    80005e62:	fe0915e3          	bnez	s2,80005e4c <printf+0x13a>
    80005e66:	b799                	j	80005dac <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e68:	f8843783          	ld	a5,-120(s0)
    80005e6c:	00878713          	addi	a4,a5,8
    80005e70:	f8e43423          	sd	a4,-120(s0)
    80005e74:	0007b903          	ld	s2,0(a5)
    80005e78:	00090e63          	beqz	s2,80005e94 <printf+0x182>
      for(; *s; s++)
    80005e7c:	00094503          	lbu	a0,0(s2)
    80005e80:	d515                	beqz	a0,80005dac <printf+0x9a>
        consputc(*s);
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	b84080e7          	jalr	-1148(ra) # 80005a06 <consputc>
      for(; *s; s++)
    80005e8a:	0905                	addi	s2,s2,1
    80005e8c:	00094503          	lbu	a0,0(s2)
    80005e90:	f96d                	bnez	a0,80005e82 <printf+0x170>
    80005e92:	bf29                	j	80005dac <printf+0x9a>
        s = "(null)";
    80005e94:	00003917          	auipc	s2,0x3
    80005e98:	adc90913          	addi	s2,s2,-1316 # 80008970 <syscall_name+0x420>
      for(; *s; s++)
    80005e9c:	02800513          	li	a0,40
    80005ea0:	b7cd                	j	80005e82 <printf+0x170>
      consputc('%');
    80005ea2:	8556                	mv	a0,s5
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	b62080e7          	jalr	-1182(ra) # 80005a06 <consputc>
      break;
    80005eac:	b701                	j	80005dac <printf+0x9a>
      consputc('%');
    80005eae:	8556                	mv	a0,s5
    80005eb0:	00000097          	auipc	ra,0x0
    80005eb4:	b56080e7          	jalr	-1194(ra) # 80005a06 <consputc>
      consputc(c);
    80005eb8:	854a                	mv	a0,s2
    80005eba:	00000097          	auipc	ra,0x0
    80005ebe:	b4c080e7          	jalr	-1204(ra) # 80005a06 <consputc>
      break;
    80005ec2:	b5ed                	j	80005dac <printf+0x9a>
  if(locking)
    80005ec4:	020d9163          	bnez	s11,80005ee6 <printf+0x1d4>
}
    80005ec8:	70e6                	ld	ra,120(sp)
    80005eca:	7446                	ld	s0,112(sp)
    80005ecc:	74a6                	ld	s1,104(sp)
    80005ece:	7906                	ld	s2,96(sp)
    80005ed0:	69e6                	ld	s3,88(sp)
    80005ed2:	6a46                	ld	s4,80(sp)
    80005ed4:	6aa6                	ld	s5,72(sp)
    80005ed6:	6b06                	ld	s6,64(sp)
    80005ed8:	7be2                	ld	s7,56(sp)
    80005eda:	7c42                	ld	s8,48(sp)
    80005edc:	7ca2                	ld	s9,40(sp)
    80005ede:	7d02                	ld	s10,32(sp)
    80005ee0:	6de2                	ld	s11,24(sp)
    80005ee2:	6129                	addi	sp,sp,192
    80005ee4:	8082                	ret
    release(&pr.lock);
    80005ee6:	00020517          	auipc	a0,0x20
    80005eea:	30250513          	addi	a0,a0,770 # 800261e8 <pr>
    80005eee:	00000097          	auipc	ra,0x0
    80005ef2:	3d8080e7          	jalr	984(ra) # 800062c6 <release>
}
    80005ef6:	bfc9                	j	80005ec8 <printf+0x1b6>

0000000080005ef8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ef8:	1101                	addi	sp,sp,-32
    80005efa:	ec06                	sd	ra,24(sp)
    80005efc:	e822                	sd	s0,16(sp)
    80005efe:	e426                	sd	s1,8(sp)
    80005f00:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f02:	00020497          	auipc	s1,0x20
    80005f06:	2e648493          	addi	s1,s1,742 # 800261e8 <pr>
    80005f0a:	00003597          	auipc	a1,0x3
    80005f0e:	a7e58593          	addi	a1,a1,-1410 # 80008988 <syscall_name+0x438>
    80005f12:	8526                	mv	a0,s1
    80005f14:	00000097          	auipc	ra,0x0
    80005f18:	26e080e7          	jalr	622(ra) # 80006182 <initlock>
  pr.locking = 1;
    80005f1c:	4785                	li	a5,1
    80005f1e:	cc9c                	sw	a5,24(s1)
}
    80005f20:	60e2                	ld	ra,24(sp)
    80005f22:	6442                	ld	s0,16(sp)
    80005f24:	64a2                	ld	s1,8(sp)
    80005f26:	6105                	addi	sp,sp,32
    80005f28:	8082                	ret

0000000080005f2a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f2a:	1141                	addi	sp,sp,-16
    80005f2c:	e406                	sd	ra,8(sp)
    80005f2e:	e022                	sd	s0,0(sp)
    80005f30:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f32:	100007b7          	lui	a5,0x10000
    80005f36:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f3a:	f8000713          	li	a4,-128
    80005f3e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f42:	470d                	li	a4,3
    80005f44:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f48:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f4c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f50:	469d                	li	a3,7
    80005f52:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f56:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f5a:	00003597          	auipc	a1,0x3
    80005f5e:	a4e58593          	addi	a1,a1,-1458 # 800089a8 <digits+0x18>
    80005f62:	00020517          	auipc	a0,0x20
    80005f66:	2a650513          	addi	a0,a0,678 # 80026208 <uart_tx_lock>
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	218080e7          	jalr	536(ra) # 80006182 <initlock>
}
    80005f72:	60a2                	ld	ra,8(sp)
    80005f74:	6402                	ld	s0,0(sp)
    80005f76:	0141                	addi	sp,sp,16
    80005f78:	8082                	ret

0000000080005f7a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f7a:	1101                	addi	sp,sp,-32
    80005f7c:	ec06                	sd	ra,24(sp)
    80005f7e:	e822                	sd	s0,16(sp)
    80005f80:	e426                	sd	s1,8(sp)
    80005f82:	1000                	addi	s0,sp,32
    80005f84:	84aa                	mv	s1,a0
  push_off();
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	240080e7          	jalr	576(ra) # 800061c6 <push_off>

  if(panicked){
    80005f8e:	00003797          	auipc	a5,0x3
    80005f92:	08e7a783          	lw	a5,142(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f96:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f9a:	c391                	beqz	a5,80005f9e <uartputc_sync+0x24>
    for(;;)
    80005f9c:	a001                	j	80005f9c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f9e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fa2:	0ff7f793          	andi	a5,a5,255
    80005fa6:	0207f793          	andi	a5,a5,32
    80005faa:	dbf5                	beqz	a5,80005f9e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fac:	0ff4f793          	andi	a5,s1,255
    80005fb0:	10000737          	lui	a4,0x10000
    80005fb4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	2ae080e7          	jalr	686(ra) # 80006266 <pop_off>
}
    80005fc0:	60e2                	ld	ra,24(sp)
    80005fc2:	6442                	ld	s0,16(sp)
    80005fc4:	64a2                	ld	s1,8(sp)
    80005fc6:	6105                	addi	sp,sp,32
    80005fc8:	8082                	ret

0000000080005fca <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fca:	00003717          	auipc	a4,0x3
    80005fce:	05673703          	ld	a4,86(a4) # 80009020 <uart_tx_r>
    80005fd2:	00003797          	auipc	a5,0x3
    80005fd6:	0567b783          	ld	a5,86(a5) # 80009028 <uart_tx_w>
    80005fda:	06e78c63          	beq	a5,a4,80006052 <uartstart+0x88>
{
    80005fde:	7139                	addi	sp,sp,-64
    80005fe0:	fc06                	sd	ra,56(sp)
    80005fe2:	f822                	sd	s0,48(sp)
    80005fe4:	f426                	sd	s1,40(sp)
    80005fe6:	f04a                	sd	s2,32(sp)
    80005fe8:	ec4e                	sd	s3,24(sp)
    80005fea:	e852                	sd	s4,16(sp)
    80005fec:	e456                	sd	s5,8(sp)
    80005fee:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ff0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ff4:	00020a17          	auipc	s4,0x20
    80005ff8:	214a0a13          	addi	s4,s4,532 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005ffc:	00003497          	auipc	s1,0x3
    80006000:	02448493          	addi	s1,s1,36 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006004:	00003997          	auipc	s3,0x3
    80006008:	02498993          	addi	s3,s3,36 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000600c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006010:	0ff7f793          	andi	a5,a5,255
    80006014:	0207f793          	andi	a5,a5,32
    80006018:	c785                	beqz	a5,80006040 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000601a:	01f77793          	andi	a5,a4,31
    8000601e:	97d2                	add	a5,a5,s4
    80006020:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006024:	0705                	addi	a4,a4,1
    80006026:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006028:	8526                	mv	a0,s1
    8000602a:	ffffb097          	auipc	ra,0xffffb
    8000602e:	6a0080e7          	jalr	1696(ra) # 800016ca <wakeup>
    
    WriteReg(THR, c);
    80006032:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006036:	6098                	ld	a4,0(s1)
    80006038:	0009b783          	ld	a5,0(s3)
    8000603c:	fce798e3          	bne	a5,a4,8000600c <uartstart+0x42>
  }
}
    80006040:	70e2                	ld	ra,56(sp)
    80006042:	7442                	ld	s0,48(sp)
    80006044:	74a2                	ld	s1,40(sp)
    80006046:	7902                	ld	s2,32(sp)
    80006048:	69e2                	ld	s3,24(sp)
    8000604a:	6a42                	ld	s4,16(sp)
    8000604c:	6aa2                	ld	s5,8(sp)
    8000604e:	6121                	addi	sp,sp,64
    80006050:	8082                	ret
    80006052:	8082                	ret

0000000080006054 <uartputc>:
{
    80006054:	7179                	addi	sp,sp,-48
    80006056:	f406                	sd	ra,40(sp)
    80006058:	f022                	sd	s0,32(sp)
    8000605a:	ec26                	sd	s1,24(sp)
    8000605c:	e84a                	sd	s2,16(sp)
    8000605e:	e44e                	sd	s3,8(sp)
    80006060:	e052                	sd	s4,0(sp)
    80006062:	1800                	addi	s0,sp,48
    80006064:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006066:	00020517          	auipc	a0,0x20
    8000606a:	1a250513          	addi	a0,a0,418 # 80026208 <uart_tx_lock>
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	1a4080e7          	jalr	420(ra) # 80006212 <acquire>
  if(panicked){
    80006076:	00003797          	auipc	a5,0x3
    8000607a:	fa67a783          	lw	a5,-90(a5) # 8000901c <panicked>
    8000607e:	c391                	beqz	a5,80006082 <uartputc+0x2e>
    for(;;)
    80006080:	a001                	j	80006080 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006082:	00003797          	auipc	a5,0x3
    80006086:	fa67b783          	ld	a5,-90(a5) # 80009028 <uart_tx_w>
    8000608a:	00003717          	auipc	a4,0x3
    8000608e:	f9673703          	ld	a4,-106(a4) # 80009020 <uart_tx_r>
    80006092:	02070713          	addi	a4,a4,32
    80006096:	02f71b63          	bne	a4,a5,800060cc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000609a:	00020a17          	auipc	s4,0x20
    8000609e:	16ea0a13          	addi	s4,s4,366 # 80026208 <uart_tx_lock>
    800060a2:	00003497          	auipc	s1,0x3
    800060a6:	f7e48493          	addi	s1,s1,-130 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060aa:	00003917          	auipc	s2,0x3
    800060ae:	f7e90913          	addi	s2,s2,-130 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060b2:	85d2                	mv	a1,s4
    800060b4:	8526                	mv	a0,s1
    800060b6:	ffffb097          	auipc	ra,0xffffb
    800060ba:	488080e7          	jalr	1160(ra) # 8000153e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060be:	00093783          	ld	a5,0(s2)
    800060c2:	6098                	ld	a4,0(s1)
    800060c4:	02070713          	addi	a4,a4,32
    800060c8:	fef705e3          	beq	a4,a5,800060b2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060cc:	00020497          	auipc	s1,0x20
    800060d0:	13c48493          	addi	s1,s1,316 # 80026208 <uart_tx_lock>
    800060d4:	01f7f713          	andi	a4,a5,31
    800060d8:	9726                	add	a4,a4,s1
    800060da:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060de:	0785                	addi	a5,a5,1
    800060e0:	00003717          	auipc	a4,0x3
    800060e4:	f4f73423          	sd	a5,-184(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	ee2080e7          	jalr	-286(ra) # 80005fca <uartstart>
      release(&uart_tx_lock);
    800060f0:	8526                	mv	a0,s1
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	1d4080e7          	jalr	468(ra) # 800062c6 <release>
}
    800060fa:	70a2                	ld	ra,40(sp)
    800060fc:	7402                	ld	s0,32(sp)
    800060fe:	64e2                	ld	s1,24(sp)
    80006100:	6942                	ld	s2,16(sp)
    80006102:	69a2                	ld	s3,8(sp)
    80006104:	6a02                	ld	s4,0(sp)
    80006106:	6145                	addi	sp,sp,48
    80006108:	8082                	ret

000000008000610a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000610a:	1141                	addi	sp,sp,-16
    8000610c:	e422                	sd	s0,8(sp)
    8000610e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006110:	100007b7          	lui	a5,0x10000
    80006114:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006118:	8b85                	andi	a5,a5,1
    8000611a:	cb91                	beqz	a5,8000612e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000611c:	100007b7          	lui	a5,0x10000
    80006120:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006124:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006128:	6422                	ld	s0,8(sp)
    8000612a:	0141                	addi	sp,sp,16
    8000612c:	8082                	ret
    return -1;
    8000612e:	557d                	li	a0,-1
    80006130:	bfe5                	j	80006128 <uartgetc+0x1e>

0000000080006132 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006132:	1101                	addi	sp,sp,-32
    80006134:	ec06                	sd	ra,24(sp)
    80006136:	e822                	sd	s0,16(sp)
    80006138:	e426                	sd	s1,8(sp)
    8000613a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000613c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	fcc080e7          	jalr	-52(ra) # 8000610a <uartgetc>
    if(c == -1)
    80006146:	00950763          	beq	a0,s1,80006154 <uartintr+0x22>
      break;
    consoleintr(c);
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	8fe080e7          	jalr	-1794(ra) # 80005a48 <consoleintr>
  while(1){
    80006152:	b7f5                	j	8000613e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006154:	00020497          	auipc	s1,0x20
    80006158:	0b448493          	addi	s1,s1,180 # 80026208 <uart_tx_lock>
    8000615c:	8526                	mv	a0,s1
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	0b4080e7          	jalr	180(ra) # 80006212 <acquire>
  uartstart();
    80006166:	00000097          	auipc	ra,0x0
    8000616a:	e64080e7          	jalr	-412(ra) # 80005fca <uartstart>
  release(&uart_tx_lock);
    8000616e:	8526                	mv	a0,s1
    80006170:	00000097          	auipc	ra,0x0
    80006174:	156080e7          	jalr	342(ra) # 800062c6 <release>
}
    80006178:	60e2                	ld	ra,24(sp)
    8000617a:	6442                	ld	s0,16(sp)
    8000617c:	64a2                	ld	s1,8(sp)
    8000617e:	6105                	addi	sp,sp,32
    80006180:	8082                	ret

0000000080006182 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006182:	1141                	addi	sp,sp,-16
    80006184:	e422                	sd	s0,8(sp)
    80006186:	0800                	addi	s0,sp,16
  lk->name = name;
    80006188:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000618a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000618e:	00053823          	sd	zero,16(a0)
}
    80006192:	6422                	ld	s0,8(sp)
    80006194:	0141                	addi	sp,sp,16
    80006196:	8082                	ret

0000000080006198 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006198:	411c                	lw	a5,0(a0)
    8000619a:	e399                	bnez	a5,800061a0 <holding+0x8>
    8000619c:	4501                	li	a0,0
  return r;
}
    8000619e:	8082                	ret
{
    800061a0:	1101                	addi	sp,sp,-32
    800061a2:	ec06                	sd	ra,24(sp)
    800061a4:	e822                	sd	s0,16(sp)
    800061a6:	e426                	sd	s1,8(sp)
    800061a8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061aa:	6904                	ld	s1,16(a0)
    800061ac:	ffffb097          	auipc	ra,0xffffb
    800061b0:	ca6080e7          	jalr	-858(ra) # 80000e52 <mycpu>
    800061b4:	40a48533          	sub	a0,s1,a0
    800061b8:	00153513          	seqz	a0,a0
}
    800061bc:	60e2                	ld	ra,24(sp)
    800061be:	6442                	ld	s0,16(sp)
    800061c0:	64a2                	ld	s1,8(sp)
    800061c2:	6105                	addi	sp,sp,32
    800061c4:	8082                	ret

00000000800061c6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061c6:	1101                	addi	sp,sp,-32
    800061c8:	ec06                	sd	ra,24(sp)
    800061ca:	e822                	sd	s0,16(sp)
    800061cc:	e426                	sd	s1,8(sp)
    800061ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061d0:	100024f3          	csrr	s1,sstatus
    800061d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061da:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061de:	ffffb097          	auipc	ra,0xffffb
    800061e2:	c74080e7          	jalr	-908(ra) # 80000e52 <mycpu>
    800061e6:	5d3c                	lw	a5,120(a0)
    800061e8:	cf89                	beqz	a5,80006202 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ea:	ffffb097          	auipc	ra,0xffffb
    800061ee:	c68080e7          	jalr	-920(ra) # 80000e52 <mycpu>
    800061f2:	5d3c                	lw	a5,120(a0)
    800061f4:	2785                	addiw	a5,a5,1
    800061f6:	dd3c                	sw	a5,120(a0)
}
    800061f8:	60e2                	ld	ra,24(sp)
    800061fa:	6442                	ld	s0,16(sp)
    800061fc:	64a2                	ld	s1,8(sp)
    800061fe:	6105                	addi	sp,sp,32
    80006200:	8082                	ret
    mycpu()->intena = old;
    80006202:	ffffb097          	auipc	ra,0xffffb
    80006206:	c50080e7          	jalr	-944(ra) # 80000e52 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000620a:	8085                	srli	s1,s1,0x1
    8000620c:	8885                	andi	s1,s1,1
    8000620e:	dd64                	sw	s1,124(a0)
    80006210:	bfe9                	j	800061ea <push_off+0x24>

0000000080006212 <acquire>:
{
    80006212:	1101                	addi	sp,sp,-32
    80006214:	ec06                	sd	ra,24(sp)
    80006216:	e822                	sd	s0,16(sp)
    80006218:	e426                	sd	s1,8(sp)
    8000621a:	1000                	addi	s0,sp,32
    8000621c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	fa8080e7          	jalr	-88(ra) # 800061c6 <push_off>
  if(holding(lk))
    80006226:	8526                	mv	a0,s1
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	f70080e7          	jalr	-144(ra) # 80006198 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006230:	4705                	li	a4,1
  if(holding(lk))
    80006232:	e115                	bnez	a0,80006256 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006234:	87ba                	mv	a5,a4
    80006236:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000623a:	2781                	sext.w	a5,a5
    8000623c:	ffe5                	bnez	a5,80006234 <acquire+0x22>
  __sync_synchronize();
    8000623e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006242:	ffffb097          	auipc	ra,0xffffb
    80006246:	c10080e7          	jalr	-1008(ra) # 80000e52 <mycpu>
    8000624a:	e888                	sd	a0,16(s1)
}
    8000624c:	60e2                	ld	ra,24(sp)
    8000624e:	6442                	ld	s0,16(sp)
    80006250:	64a2                	ld	s1,8(sp)
    80006252:	6105                	addi	sp,sp,32
    80006254:	8082                	ret
    panic("acquire");
    80006256:	00002517          	auipc	a0,0x2
    8000625a:	75a50513          	addi	a0,a0,1882 # 800089b0 <digits+0x20>
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	a6a080e7          	jalr	-1430(ra) # 80005cc8 <panic>

0000000080006266 <pop_off>:

void
pop_off(void)
{
    80006266:	1141                	addi	sp,sp,-16
    80006268:	e406                	sd	ra,8(sp)
    8000626a:	e022                	sd	s0,0(sp)
    8000626c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	be4080e7          	jalr	-1052(ra) # 80000e52 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006276:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000627a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000627c:	e78d                	bnez	a5,800062a6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000627e:	5d3c                	lw	a5,120(a0)
    80006280:	02f05b63          	blez	a5,800062b6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006284:	37fd                	addiw	a5,a5,-1
    80006286:	0007871b          	sext.w	a4,a5
    8000628a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000628c:	eb09                	bnez	a4,8000629e <pop_off+0x38>
    8000628e:	5d7c                	lw	a5,124(a0)
    80006290:	c799                	beqz	a5,8000629e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006292:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006296:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000629a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000629e:	60a2                	ld	ra,8(sp)
    800062a0:	6402                	ld	s0,0(sp)
    800062a2:	0141                	addi	sp,sp,16
    800062a4:	8082                	ret
    panic("pop_off - interruptible");
    800062a6:	00002517          	auipc	a0,0x2
    800062aa:	71250513          	addi	a0,a0,1810 # 800089b8 <digits+0x28>
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	a1a080e7          	jalr	-1510(ra) # 80005cc8 <panic>
    panic("pop_off");
    800062b6:	00002517          	auipc	a0,0x2
    800062ba:	71a50513          	addi	a0,a0,1818 # 800089d0 <digits+0x40>
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	a0a080e7          	jalr	-1526(ra) # 80005cc8 <panic>

00000000800062c6 <release>:
{
    800062c6:	1101                	addi	sp,sp,-32
    800062c8:	ec06                	sd	ra,24(sp)
    800062ca:	e822                	sd	s0,16(sp)
    800062cc:	e426                	sd	s1,8(sp)
    800062ce:	1000                	addi	s0,sp,32
    800062d0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	ec6080e7          	jalr	-314(ra) # 80006198 <holding>
    800062da:	c115                	beqz	a0,800062fe <release+0x38>
  lk->cpu = 0;
    800062dc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062e0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062e4:	0f50000f          	fence	iorw,ow
    800062e8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062ec:	00000097          	auipc	ra,0x0
    800062f0:	f7a080e7          	jalr	-134(ra) # 80006266 <pop_off>
}
    800062f4:	60e2                	ld	ra,24(sp)
    800062f6:	6442                	ld	s0,16(sp)
    800062f8:	64a2                	ld	s1,8(sp)
    800062fa:	6105                	addi	sp,sp,32
    800062fc:	8082                	ret
    panic("release");
    800062fe:	00002517          	auipc	a0,0x2
    80006302:	6da50513          	addi	a0,a0,1754 # 800089d8 <digits+0x48>
    80006306:	00000097          	auipc	ra,0x0
    8000630a:	9c2080e7          	jalr	-1598(ra) # 80005cc8 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
