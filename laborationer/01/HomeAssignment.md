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

* **add** - add (with overflow) 
  * Adds two registers and stores the result in a register.
* **addi** - Add immediate (with overflow)
  * Adds a register and a sign-extended immediate value and stores the result in a register.
* **addiu** - Add immediate unsigned (no overflow)
  * Adds a register and a sign-extended immediate value and stores the result in a register. 

>Sign extension is the operation, in computer arithmetic, of increasing the
>number of bits of a binary number while preserving the number's sign
>(positive/negative) and value. This is done by appending digits to the most
>significant side of the number, following a procedure dependent on the
>particular signed number representation used.
[Wikipedia.](https://en.wikipedia.org/wiki/Sign_extension)

