#include <Iregdef.h>

.set noreorder

.text
.globl start
.ent start



start:
li r24, 0xbfc00058 # no chars
li r23, 61

jal getchar
nop
nop
nop
#beq v0, zero, load_stored
nop
b load_new

.end start

load_stored:
add a0, zero, r23
b print

load_new:
add a0, zero, v0
b print

print:
jal putchar
b start

#li a0, 'A'
#jal putchar
#getchar
#la	a0, string1
#jal gets
#la  a0, string1
#jal	puts
