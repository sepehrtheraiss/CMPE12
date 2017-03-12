/*
 *  Sepehr Raissian
 *  sraissia
 *  CMPE 12
 *  LAB 5 part 2
 *  SECTION 1D 
 */
#include <WProgram.h>
#include <xc.h>
/* define all global symbols here */
.global main
    

.text
.set noreorder 

.ent main
main:
    /* this code blocks sets up the ability to print, do not alter it */
    ADDIU $v0,$zero,1
    LA $t0,__XC_UART
    SW $v0,0($t0)
    LA $t0,U1MODE
    LW $v0,0($t0)
    ORI $v0,$v0,0b1000
    SW $v0,0($t0)
    LA $t0,U1BRG
    ADDIU $v0,$zero,12
    SW $v0,0($t0)
    /* your code goes underneath this */

    LA $a0,HelloWorld
    JAL puts
    NOP
    
    # set buttons and switches to input
    LA $t1, TRISD	   # int32* t1= &TRISD; //load PORTE address 
    LI $t2, 0xFFFF	    
    SW $t2, 0($t1)         # *t1 = 11111111; // set switches as input
    # set LED's as output:
    LA $t1, TRISE	   # int32* t1= &TRISE; //load TRISE address 
    LI $t2, 0		   # int32 t2 = 0;
    SW $t2, 0($t1)         # *t1 = 0x0000; // set TRISE as output
    # turn leds off
    LA $t3, PORTE          # int32* t3 = &PORTE; //load PORTE address 
    SW $0, 0($t3)	   # *t3 = 4; // set TRISE to 0 to turn all LEDS off 
    LI $t6,0b10000000	   # counter 8 when to count backwards
    LI $t1, 1		   # counter 1
    LI $t4, 0b1            # first led
    # loop to turn led 1-8 on
    Loop1:
	# get users input from switches
	LW $a0,PORTD     # value of the input button 
	ANDI $a0,$a0,0b111100000000 # mask for switches bit 8-11,
	SRL $a0,$a0,8    # a0 >> 8; // shift the value of a0, 4 to right, since switches start from 8
	ANDI $a0,$a0,0b1111 # mask for only desired digits double checking
	ADD $a0,$a0,1
	JAL Calc # calculate the speed of the light
	NOP 
 	BEQ $t4,$t6,Loop2 # if t4 is 8, turn led's backward 8-1
	SW $t4,0($t3)	   # turn led[i] on, 1-8
	SLL $t4,$t4,1    # t4 << 1; // shift the value of t4 by one to get to the next led
	JAL mydelay
	NOP
	J Loop1
	NOP
    # loop to turn led 8-1 on
    Loop2:
    	# get users input from switches
	LW $a0,PORTD     # value of the input button 
	ANDI $a0,$a0,0b111100000000 # mask for switches bit 8-11,
	SRL $a0,$a0,8    # a0 >> 8; // shift the value of a0, 4 to right, since switches start from 8
	ANDI $a0,$a0,0b1111 # mask for only desired digits double checking
	ADD $a0,$a0,1
	JAL Calc # calculate the speed of the light
	NOP 
 	BEQ $t4,$t1,Loop1 # if t4 is 1, turn led's backward 1-8
	SW $t4,0($t3)	   # turn led[i] on, 8-1
	SRL $t4,$t4,1    # t4 >> 1; // shift the value of t4 by one to get to the next led
	JAL mydelay
	NOP
	J Loop2
	NOP	
Calc:
    LW $t5, speed
    MUL $t5,$t5,$a0
    JR $31
    NOP
mydelay:
    ADD $t7,$t5,$0 # copy t5 which is the calculated light speed
    Start_Loop:
	SUBU $t7,$t7,1
	BGTZ $t7,Start_Loop
	 NOP
    JR $31
     NOP
.end main
    
hmm:    J hmm
    NOP
endProgram:
    J endProgram
    NOP
.data    
HelloWorld: .asciiz "Assembly Hello World \n"
speed: .word 10000 # max light speed
    
    
