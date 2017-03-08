#include <WProgram.h>
#include <xc.h>
/* define all global symbols here */
.global main
    

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
    LI $t5, 0b0		   # int32 t4 = 0; 
    SW $t5, 0($t3)	   # *t3 = 4; // set TRISE to 0 to turn all LEDS off 
    LI $t6,0b10000000
    LI $t4, 0b1
    # loop to turn led 1-8 on
    Loop:
 	#BEQ $t4,$t6,Set_Counter_to_1 
	SW $t4,0($t3)	   # turn led[i] on
	JAL Waste_Time
	SW $t5,0($t3)	   # turn led[i] off
	JAL Waste_Time
	J Loop
	
    
NOP
Set_Counter_to_1:
    LI $t4,1
    J Loop
Waste_Time:
    LI $t7,65535
    MUL $t7,$t7,$t7
    Start_Loop:
	SUBU $t7,$t7,1
	BGTZ $t7,Start_Loop
    J $31
.end main


