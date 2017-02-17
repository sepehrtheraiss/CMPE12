.ORIG x3000
			AND R0,R0,#0	;clearing the registers
			AND R1,R1,#0	; Storing the mult value 	
			AND R2,R2,#0	; -48 and to continue the loop
			AND R3,R3,#0	; Loop counter
			AND R4,R4,#0	; to temp store Var_A 
			AND R5,R5,#0
			AND R6,R6,#0	
			AND R7,R7,#0
			LEA R0,GMS		; load the address of GMS string
	PUTS					; outputs the string 
	LEA R0, OUT_MES			; loads R0 with the OUT_MES memory address
	PUTS					; outputs the string
	
		;INPUT
LOOP	GETC			; gets users input
		OUT				; outpts users input
		LD R2, NEGATIVE		; load -45 
		ADD R2,R0,R2	; to figure out our input
		BRz	FLAG_IT		; if zero then input is '-'  so flag it
		BRn      DONE		; if '\n' exit
		LD R2, CHAR		; load the value of -48
		ADD R0,R0,R2	; input number - 48 to the actual number in binary
;		OUT
		; Multiply
			LD R3,I	  		;load 10
MULTIPLY 	ADD R1,R1,R0                    ;input * 10
			ADD R3,R3,#-1           ;decrement I
			BRp MULTIPLY 
		; END Multiplying
			LD  R4,VAR_A 	; temp store the value of VAR_A
			ADD R1,R4,R1	; ADD the multiplied value to VAR_A(input*10 + digit)
			ST R1,VAR_A	; Store back to VAR_A
		BRzp LOOP		; if 0-9 continue getting users input
DONE
            LD R2, FLAG ;check for  flag
            BRp     TWOS_Complement
OUTPUT
            LD R1, VAR_A; load VAR_A value
            LD R4, M_I ; 16
            LEA R2,MASK; load memory address of MASK

MASK_LOOP               
            LDR R3,R2,#0;load the value of the R2(MASK)

            AND R0,R1,R3 ; R1&R3
            BRp PRINT_ONE
            BRz PRINT_ZERO
CONTINUE
            ADD R2,R2,#1;increment memory address of mask
            ADD R4,R4,#-1;decrement 16
            BRp MASK_LOOP
            

HALT
FLAG_IT AND R0,R0,#0
ADD R6,R0,#1
ST R6,FLAG ; setting flag to 1
AND R6,R6,#0 ;set back to zero
BRz LOOP       ; start getting users input

TWOS_Complement LD R1, VAR_A;load VAR_A
NOT R1,R1;not VAR_A
ADD R1,R1,#1
ST R1,VAR_A;sotre it back to VAR_A
AND R1,R1,#0;set R1 to zero
BRnzp OUTPUT;and do mask

PRINT_ONE LD R0,ONE
OUT
CONTINUE

PRINT_ZERO LD R0,ZERO
OUT
CONTINUE

ONE     .FILL #49 ; 1
ZERO    .FILL #48 ; 0
FLAG	.FILL #0
VAR_A	.FILL #0; to store users input after multipying by 10
I		.FILL #10	
GMS .STRINGZ "Welcome to the conversion program\n"	;Greeting message
OUT_MES .STRINGZ "Enter a decimal number or X to quit:\n" ; Output message
CHAR	.FILL #-48	; 0 in ascii
NEGATIVE		.FILL #-45  ;'-' in ascii, when sub with '-' we get zero, 0-9 positive number, '\n' we get negative
int		.FILL #0	   
M_I             .FILL #16; MASK Iteration
MASK	        .FILL x8000
		.FILL x4000
		.FILL x2000
		.FILL x1000	
		.FILL x0800
		.FILL x400
		.FILL x200
		.FILL x100
		.FILL x80
		.FILL x40
		.FILL x20
		.FILL x10
		.FILL x8
		.FILL x4
		.FILL x2
		.FILL x1
.END
