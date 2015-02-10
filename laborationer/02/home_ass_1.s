#include <iregdef.h>


        .set noreorder
        .text
        .globl start
        .ent start

start:  
		li r24, 0xbfa00000
		li r25, 0x10000000 			# value for button up.
		li r26, 0x11000000 			# value for button down.

        jal     fix
        nop
        jal     wait        # Wait for button click
        nop
        lui     s0, 0xbf90  # Load switch port address
        lb      s1, 0x0(s0) # Read first number from switches
        nop
        jal     wait        # Wait for button click
        nop
        lb      s2, 0x0(s0) # Read second number from switches
        nop
        add     s3, s1, s2  # Perform an arithmetic operation
        sb      s3, 0x0(s0) # Write the result to LEDs
        b       start       # Repeat all over again
        nop

        ### Add code for wait subroutine here! ###
        
wait:
		lw r27, (r24) 			# update button value.
		beq r27, r25, wait 		# branch if button is up.
		nop
		beq r27, zero, wait 	# branch if button never been pressed.	
		nop

		pressed:
		lw r27, (r24)			# update button value.
		beq r27, r26, pressed 	# branch if button is down.
		nop

        .end start


