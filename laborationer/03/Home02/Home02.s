 # Written by Mats Brorsson, 16 November 1998

        # This is a simple program to illustrate the idea of
        # interrupts. The interrupt routine start address is
        # 0x80000080. Only a small stub routine that immediately
        # jumps to the real interrupt routine is stored at this
        # address. The stub routine is copied to this address
        # during the program initialization. 

#include <iregdef.h>
#include <idtcpu.h>
#include <excepthdr.h>

#define PIO_SETUP2 0xffffea2a

        .data

        # Format string for the the interrupt routine

Format: .asciiz "Cause = 0x%x, EPC = 0x%x, Interrupt I/O = 0x%x\n"

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
        lui     s0, 0xbfa0	  # Place interrupt I/O port adress in s0

        la      a0, Format      # Put format string address in a0
        move    a1, k0          # Put cause in a1
        move    a2, k1          # Put EPC in a2
        lbu     a3, 0x0(s0)	  # Read the interrupt I/O port
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

        .globl start            # Start of the main program
        .ent start

start:  lh      a0, PIO_SETUP2  # Enable button port interrupts
        andi    a0, 0xbfff
        sh      a0, PIO_SETUP2
        lui     t0, 0xbfa0	  # Place interrupt I/O port adress in t0
        sb      zero,0x0(t0)	  # Acknowledge interrupt, (resets latch)
        la      t0, intstub     # These instructions copy the stub
        la      t1, 0x80000080  # routine to address 0x80000080
        lw      t2, 0(t0)       # Read the first instruction in stub
        lw      t3, 4(t0)       # Read the second instruction
        sw      t2, 0(t1)       # Store the first instruction 
        sw      t3, 4(t1)       # Store the second instruction

        mfc0    v0, C0_SR       # Retrieve the status register
        li      v1, ~SR_BEV	  # Set the BEV bit of the status
        and     v0, v0, v1	  # register to 0 (the first exception vetor)
        ori     v0, v0, 1       # Enable user defined interrupts
        ori     v0, v0,EXT_INT3 # Enable interrupt 3 (K1, K2, timer)
        mtc0    v0, C0_SR       # Update the status register

Loop:   b       Loop            # Wait for interrupt

        .end start
