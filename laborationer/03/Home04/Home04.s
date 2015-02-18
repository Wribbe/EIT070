# Laboratory Exercise 3, Home Assignment 4
        # Written by Georg Fischer, 16 November 1998

#include <iregdef.h>
#include <idtcpu.h>
#include <excepthdr.h>

#define SWITCHES 0xbf900000
#define LEDS     0xbf900000
#define BUTTONS  0xbfa00000

		.data
		
		TextA: .asciiz "This is the interrupt!\n"

		.text
        .globl start
        .ent start

start:  sub     sp, sp, 4       # Reserve new stack space
        sw      ra, 0(sp)       # Save return address
        


        jal     init_ext_int    # Initialize interrupts
        la      a0, IntHand     # Install our own interrupt routine
        jal     install_normal_int
        li      a0, EXT_INT3    # Enable interrupt 3 (K1, K2, timer)
        jal     enable_int      # Enable external timer interrupts

Loop:   jal     Comp            # Perform heavy computations
        b       Loop            # Repeat loop

                                # Standard program ending
        lw      ra, 0(sp)       # Restore return address
        addi    sp, sp, 4       # Dealloacte stack space
        j       _exit           # Jump to exit routine

        .end start

        .ent IntHand
IntHand:
        ### Add code for interrupt handler here! ###

	#	move r23, ra
		la a0, TextA
		jal printf  
		mfc0 	v0, C0_CAUSE
		andi r23, v0, EXT_INT3
		nop
		
	#	move ra, r23

        .end IntHand

        .ent Comp

Comp:   li      t0, 0xffffff    # Initialize counter value
Delay:  sub     t0, t0, 1       # Decrease counter by 1
        bne     t0, r0, Delay   # Test if ready
        jr      ra              # Return to polling loop

        .end Comp