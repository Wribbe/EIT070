**Home Assignment 1** - Study the small assembly program on the next page and explain how it works.

```
# Laboratory Exercise 1, Home Assignment 1
# Written by Jan Eric Larsson, 27 October 1998


          .set noreorder      # Avoid reordering instructions
          .text               # Start generating instructions
          .globl start        # The label should be globally known
          .ent start          # The label marks an entry point


  start:  addi  $8, $0, 0x1   # Load the value 1 to register 8
          addi  $9, $0, 0x1   # Load the value 1 to register 9
          add   $10, $8, $9   # Add the values in registers 8 and 9


          .end start          # Marks the end of the program
```

[Mips reference.](http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html)

* **add** - add (with overflow).
  * Adds two registers and stores the result in a register.
* **addi** - Add immediate (with overflow).
  * Adds a register and a sign-extended immediate value and stores the result in a register.

>Sign extension is the operation, in computer arithmetic, of increasing the
>number of bits of a binary number while preserving the number's sign
>(positive/negative) and value. This is done by appending digits to the most
>significant side of the number, following a procedure dependent on the
>particular signed number representation used.
[Wikipedia.](https://en.wikipedia.org/wiki/Sign_extension)

**Answer:** The program first loads 1 into register 8 and 9 by using the instruction
`addi` by not providing a immediate value (zero). Then it adds the values of 
register 8 and 9 and stores it in register 10, which equals 2.


**Home Assignment 2** - Translate this program to hexadecimal machine instructions, using the literature.

```
# Laboratory Exercise 1, Home Assignment 2
# Written by Jan Eric Larsson, 27 October 1998

        .set noreorder
        .text
        .globl start
        .ent start

start:  lui  $9, 0xbf90      # Load upper half of port address
                              # Lower half is filled with zeros
repeat: lbu     $8, 0x0($9)   # Read from the input port
        nop                   # Needed after load
        sb      $8, 0x0($9)   # Write to the output port
        beq     $0, $0,repeat # Repeat the read and write cycle
        nop                   # Needed after branch
        addi    $8, $0, 0     # Clear the register

        .end start            # Marks the end of the program
```

**Answer:**

```
0F 00 09 bf 90
24 08 09 00 00 
00 00 00 00 00
28 08 09 00 00
04 00 00 ADDRESS OF LBU INTS.
00 00 00 00 00
08 00 00 00 00
```
