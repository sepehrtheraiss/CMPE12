/*
 *  Sepehr Raissian
 *  CMPE 12
 *  LAB 5 part 1
 *  SECTION 1D 
 */
#include <WProgram.h>
#include <xc.h>
/* define all global symbols here */
#.global main
    

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
    
    # set LED's as output:
    LA $t1, TRISE	   # int32* t1= &TRISE; //load TRISE address 
    LI $t2, 0		   # int32 t2 = 0;
    SW $t2, 0($t1)         # *t1 = 0x0000; // set PORTE as output
    # turn leds off
    LA $t3, PORTE          # int32* t3 = &PORTE; //load PORTE address 
    LI $t4, 0b0		   # int32 t4 = 0; 
    SW $t4, 0($t3)	   # *t3 = 4; // set PORTE to 0 to turn all LEDS off 
    
    # BUTTON
    # set Button 1 as input:
    LA $t1,TRISF	   # int32* t1= &TRISF; //load TRISF address 
    LI $t2,0b10		   # bit 1
    SW $t2,0($t1)	   # set bit 1 as input
    # set buttons and switches to input
    LA $t1, TRISD	   # int32* t1= &TRISD; //load PORTE address 
    LI $t2, 0xFFFF	   # int32 t2 = 0xFFF
    SW $t2, 0($t1)         # *t1 = 11111111; // set buttons and switches as input
    
    # get buttons input state
    # mask to check only for desired inputs 
    # shift to the current location of led
    # then put the bit in the desired led position 
    Loop:  LW $t1,PORTD     # value of the input button    
	   ANDI $t2,$t1,0b100000 # mask for button bit 5, if 0 does nothing
	   # SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE, LED 5 ON 
	   ANDI $t2,$t1,0b1000000 # mask for button bit 6, if 0 does nothing
	   # SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE, LED 6 ON 
	   ANDI $t2,$t1,0b10000000 # mask for button bit 7
	   # SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE, LED 7 ON 
	   ANDI $t2,$t1,0b100000000 # mask for button bit 8
	   SRL $t2,$t2,8    # t2 >> 8; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE, LED 8 ON 
	   ANDI $t2,$t1,0b1000000000 # mask for button bit 9
	   SRL $t2,$t2,8    # t2 >> 8; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE, LED 1 ON 
	   ANDI $t2,$t1,0b10000000000 # mask for button bit 10
	   SRL $t2,$t2,8    # t2 >> 8; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE, LED 2 ON 
	   ANDI $t2,$t1,0b100000000000 # mask for button bit 11
	   SRL $t2,$t2,8    # t2 >> 8; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE, LED 3 ON 
	   LW $t1,PORTF
	   ANDI $t2,$t1,0b10 # mask for button bit 1    
	   SLL $t2,$t2,3    # t2 << 3; // shift the value of t2, 3 to right
	   SW $t2,0($t3)    # *t3 = t1; // store the value of t2 to PORTE to turn led 4 on
	   J Loop
NOP
.end main
hmm:    J hmm
    NOP
endProgram:
    J endProgram
    NOP
.data    
HelloWorld: .asciiz "Assembly Hello World \n"


