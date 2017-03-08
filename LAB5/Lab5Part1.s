#include <WProgram.h>
#include <xc.h>
/* define all global symbols here */
#.global main
    

.text
.set noreorder 

.ent main
main:
    # set LED's as output:
    LA $t1, TRISE	   # int32* t1= &TRISE; //load TRISE address 
    LI $t2, 0		   # int32 t2 = 0;
    SW $t2, 0($t1)         # *t1 = 0x0000; // set PORTE as output
    # turn leds off
    LA $t3, PORTE          # int32* t3 = &PORTE; //load PORTE address 
    LI $t4, 0b0		   # int32 t4 = 0; 
    SW $t4, 0($t3)	   # *t3 = 4; // set TRISE to 0 to turn all LEDS off 
    
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
    # shift to the current location 
    # then put the bit in the desired led position 
    Loop:  LW $t1,PORTD     # value of the input button    
	   ANDI $t2,$t1,0b100000 # mask for button bit 5
	   SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE
	   ANDI $t2,$t1,0b1000000 # mask for button bit 6
	   SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE
	   ANDI $t2,$t1,0b10000000 # mask for button bit 7
	   SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE
	   ANDI $t2,$t1,0b100000000 # mask for button bit 8
	   SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE
	   ANDI $t2,$t1,0b1000000000 # mask for button bit 9
	   SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE
	   ANDI $t2,$t1,0b10000000000 # mask for button bit 10
	   SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE
	   ANDI $t2,$t1,0b100000000000 # mask for button bit 11
	   SRL $t2,$t2,4    # t2 >> 4; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t2; // store the value of t2 to PORTE
	   LW $t1,PORTF
	   ANDI $t2,$t1,0b10 # mask for button bit 1
	   SRL $t2,$t2,1    # t2 >> 1; // shift the value of t2, 4 to right
	   SW $t2,0($t3)    # *t3 = t1; // store the value of t2 to PORTE
	   J Loop
NOP
.end main


