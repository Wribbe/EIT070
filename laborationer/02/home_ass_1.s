#include <iregdef.h>

li r1, 0xbfa00000
li r3, 0x10000000 			# value for button up.
li r4, 0x11000000 			# value for button down.

wait:
	lw r2, (r1) 			# update button value.
	beq r2, r3, wait 		# branch if button is up.
	nop
	beq r2, zero, wait 		# branch if button never been pressed.	
	nop

	pressed:
		lw r2, (r1)		# update button value.
		beq r2, r4, pressed 	# branch if button is down.
		nop
