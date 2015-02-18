        # Laboratory Exercise 2
        # Original code by Mats Brorsson, 16 November 1998
        # Rewritten by Martin Jacobsson, 25 November 2012

#include <iregdef.h>
#include <idtcpu.h>
#include <excepthdr.h>

#define PIO_SETUP2 0xffffea2a

        .data

        # Format string for the the interrupt routine

Format: .asciiz "Cause = 0x%x, EPC = 0x%x"

        .text

        # Interrupt routine. Uses ra, a0, a1, a2, and a3.
        # It is also necessary to save v0, v1 and t0-t9
        # since they may be used by the printf routine.

        .globl introutine
        .ent introutine
        .set noreorder
        .set noat

introutine:
        subu    sp, sp, 22*4    # Allocate space, 18 regs, 4 args
        sw      AT, 4*4(sp)     # Save the registers on the stack
        sw      v0, 5*4(sp)
        sw      v1, 6*4(sp)
        sw      a0, 7*4(sp)
        sw      a1, 8*4(sp)
        sw      a2, 9*4(sp)
        sw      a3, 10*4(sp)
        sw      t0, 11*4(sp)
        sw      t1, 12*4(sp)
        sw      t2, 13*4(sp)
        sw      t3, 14*4(sp)
        sw      t4, 15*4(sp)
        sw      t5, 16*4(sp)
        sw      t6, 17*4(sp)
        sw      t7, 18*4(sp)
        sw      t8, 19*4(sp)
        sw      t9, 20*4(sp)
        sw      ra, 21*4(sp)

        # Note that 1*4(sp), 2*4(sp), and 3*4(sp) are
        # reserved for printf arguments

        .set reorder

        mfc0    k0, C0_CAUSE    # Retrieve the cause register 
        mfc0    k1, C0_EPC      # Retrieve the EPC
        la      a0, Format      # Put format string address in a0
        move    a1, k0          # Put cause in a1
        move    a2, k1          # Put EPC in a2
        jal     printf          # Call printf

        sb      zero,0x0(s0)	  # Acknowledge interrupt, (resets latch)

        .set noreorder
        lw      ra, 21*4(sp)    # Restore the registers from the stack
        lw      t9, 20*4(sp)
        lw      t8, 18*4(sp)
        lw      t7, 18*4(sp)
        lw      t6, 17*4(sp)
        lw      t5, 16*4(sp)
        lw      t4, 15*4(sp)
        lw      t3, 14*4(sp)
        lw      t2, 13*4(sp)
        lw      t1, 12*4(sp)
        lw      t0, 11*4(sp)
        lw      a3, 10*4(sp)
        lw      a2, 9*4(sp)
        lw      a1, 8*4(sp)
        lw      a0, 7*4(sp)
        lw      v1, 6*4(sp)
        lw      v0, 5*4(sp)
        lw      AT, 4*4(sp)
        addu    sp, sp, 22*4    # Return activation record

        # noreorder must be used here to force the
        # rfe-instruction to the branch-delay slot

        jr      k1              # Jump to EPC
        rfe                     # Return from exception 
                                # Restores the status register
        .set reorder
        .end introutine

        # The only purpose of the stub routine below is to call
        # the real interrupt routine. It is used because it is 
        # of fixed size and easy to copy to the interrupt start
        # address location.

        .ent intstub
        .set noreorder

intstub: 
        j       introutine
        nop

        .set reorder
        .end intstub

        .globl fix              # Start of the main program
        .ent fix

fix:  
        la      t0, intstub     # These instructions copy the stub
        la      t1, 0x80000080  # routine to address 0x80000080
        lw      t2, 0(t0)       # Read the first instruction in stub
        lw      t3, 4(t0)       # Read the second instruction
        sw      t2, 0(t1)       # Store the first instruction 
        sw      t3, 4(t1)       # Store the second instruction

        mfc0    v0, C0_SR       # Retrieve the status register
        or     v0, v0, 1        # enable interupt
        mtc0    v0, C0_SR       # Update the status register
        jr ra

        .end fix