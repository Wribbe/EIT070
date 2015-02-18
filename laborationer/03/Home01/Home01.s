
        # Laboratory Exercise 3, Home Assignment 1
        # Written by Jan Eric Larsson, 5 November 1998

#include <iregdef.h>

        .data
        .align 2
        .globl Test

Test:   .word 1             # This is a vector
        .word 3             # named Test with 
        .word 5             # 10 elements
        .word 7
        .word 9
        .word 8
        .word 6
        .word 4
        .word 2
        .word 0

TextA:  .asciiz "Lab 3, Home Assigment 1\n"
TextB:  .asciiz "The max is %d\n"
TextC:  .asciiz "Done\n"
TextD:	.asciiz "The current value in Test is %d.\n"
TextE:	.asciiz "Swapped %d with %d as new Max.\n"

        .text
        .align 2
        .globl FindMax
        .ent FindMax

FindMax:
        subu    sp, sp, 8   # Reserve a new 8 byte stack frame
        sw      s0, 0(sp)   # Save value of s0 on the stack
        sw      s1, 4(sp)   # Save value of s1 on the stack

        ### Add code to find maximum value element here! ###
        
        
        la 		s0, Test	# Load address of Test[0] int s0.
        li      s1, 0		# s1 stores current maxValue, intialize it to 0.
        li		t0, 10		# t0 is the counter used to traverse the Test array, set to 10.
        move 	r23, ra		# Save ra in register 23, the jal printf call will mangle the old one.
        
        loop:
        subu t0, t0, 1			# Subtract 1 from the t0 counter.
        	la a0, TextD		# Load format string for printing current value output.
        	lw t1, 0(s0)		# Load current Test[i] to register t1.
        	add a1, t1, 0 		# Copy the value in t1 to a1 for printing.
        	jal printf			# Print the current value of Test[i].
        	addu s0, s0, 4		# Advance the s0 pointer to the next Array element, Test[current+4].
        	bgt t1, s1, swapMax # Swap t1 --> s1 if t1 > s1.
        	nop
        bne t0, zero, loop		# Continue loop while t0 != 0.
        nop
        j continue				# Skip swapMax and head straight to continue.
        nop
                
        swapMax:
        move t3, s1		# Save old s1 value to t3.
       	move s1,t1		# Replace current maxValue with new maxValue.		
       	move a1, s1		# Load current maxValue at s1 as first parameter for printing.
       	move a2, t3		# Load previous maxValue at t3 as second parameter for printing.
       	la a0, TextE	# Load format string for printing.
       	jal printf		# Print which values are swapped.
        j loop			# Return to the loop.
        nop
		
		continue:
		move v0, s1		# The main program prints from v0, move current maxValue from s1 to v0.
        move ra, r23	# Resoter ra from register 23.
        ###

        lw      s1, 4(sp)   # Restore old value of s1
        lw      s0, 0(sp)   # Restore old value of s0
        addu    sp, sp, 8   # Pop the stack frame
        jr      ra          # Jump back to calling routine

        .end FindMax

        .text
        .align 2
        .globl start
        .ent start

start:  subu    sp, sp, 32  # Reserve a new 32 byte stack frame
        sw      ra, 20(sp)  # Save old value of return address
        sw      fp, 16(sp)  # Save old value of frame pointer
        addu    fp, sp, 28  # Set up new frame pointer

        la      a0, TextA   # Load address to welcome text
        jal     printf      # Call printf to print welcome text

        la      a0, Test    # Load address to vector
        jal     FindMax     # Call FindMax subroutine

        la      a0, TextB   # Load address to result text
        move    a1, v0      # Move result to second register
        jal     printf      # Call printf to print result text

        la      a0, TextC   # Load address to goodbye text
        jal     printf      # Call printf to print goodbye text

        lw      fp, 16(sp)  # Restore old frame pointer
        lw      ra, 20(sp)  # Restore old return address
        addu    sp, sp, 32  # Pop stack frame
        j       _exit       # Jump to exit routine

        .end start
