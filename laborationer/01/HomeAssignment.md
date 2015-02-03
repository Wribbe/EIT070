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
