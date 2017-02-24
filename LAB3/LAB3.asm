.ORIG x3000
		AND R0,R0,#0	; clearing the registers
		AND R7,R7,#0
		LEA R0,GMS		; load the address of GMS string
		PUTS			; outputs the string 
START_INPUT
		AND R0,R0,#0
		AND R1,R1,#0	; RESERVE FOR INPUT IN BINARY NUMBER	
		AND R2,R2,#0	; 
		AND R3,R3,#0	; 
		AND R4,R4,#0	; 
		AND R5,R5,#0
		AND R6,R6,#0	

		ST R0,INT 		; SET TO ZERO
		ST R0,DIGIT 	; SET TO ZERO
		ST R0,FLAG 		; SET TO ZERO
		LEA R0,OUT_MES	; loads R0 with the OUT_MES memory address
		PUTS			; outputs the string

INPUT_LOOP
		GETC
		OUT
		LD R1,NEWLINE	; LOAD -10
		ADD R1,R0,R1	; IF CHAR == '\n'
		BRz EXIT_INPUT_LOOP
		LD R1,X 		; LOAD -88
		ADD R1,R0,R1	; IF CHAR == 'X'
		BRz	FLAG_EXIT  	; IF CHAR == 'X'
		LD R1,NEG	 	; LOAD -45
		ADD R1,R0,R1	; IF CHAR == '-'
		BRz FLAG_NEG 	; IF CHAR == '-'
		LD R1, CHAR		; load the value of -48
		ADD R1,R0,R1	; DIGIT = CHAR - 48
		ST R1,DIGIT		; DIGIT = CHAR - 48

		;START Multiply
		LD R2,MULT_I	; load 10
		LD R3,INT 		; LOAD INT
MULTIPLY 	
		ADD R4,R4,R3    ; INT * 10
		ADD R2,R2,#-1   ; decrement I
		BRp MULTIPLY 
		;END Multiplying
		ADD R4,R4,R1	; INT = INT * 10 + DIGIT
		ST R4,INT 		; INT = INT * 10 + DIGIT
		AND R4,R4,#0	; SET TO ZERO
		BRz INPUT_LOOP
EXIT_INPUT_LOOP		
		LD R1,EXIT
		BRp END_PROGRAM ; IF EXIT == 1
		LD R1,FLAG    	; LOAD FLAG
		BRp TWO_COMP 	; IF FLAG == 1
START_MASK
		LEA R0,THANKS	; load the address of THANKS string
		PUTS			; outputs the string 
		LD R1,INT 		; LOAD INT
        LD R4,COUNT 	; 15
        LEA R2,MASK 	; load memory address of MASK
MASK_LOOP
		LDR R3,R2,#0 	; load the value of the R2(MASK)
        AND R0,R1,R3 	; R1&R3
        BRp PRINT_ONE
        BRz PRINT_ZERO
CONTINUE 
        ADD R2,R2,#1	;increment memory address of mask
        ADD R4,R4,#-1	;decrement COUNT
        BRzp MASK_LOOP
        ;LD R0,NEWLINE
        ;NOT R0,R0		; -10 -> 10
        AND R0,R0,#0
        ADD R0,R0,#10 	; '\n'
        OUT
        BRp START_INPUT
END_PROGRAM
		LEA R0,BYE		; load the address of BYE string
		PUTS			; outputs the string 
HALT

FLAG_EXIT 
		AND R1,R1,#0	; SET TO ZERO
		ADD R1,R1,#1	; SET TO 1
		ST  R1,EXIT 	; SET EXIT TO 1
		AND	R1,R1,#0 	; SET TO ZERO
		BRz	INPUT_LOOP
FLAG_NEG
		AND R1,R1,#0	; SET TO ZERO
		ADD R1,R1,#1	; SET TO 1
		ST  R1,FLAG 	; SET FLAG TO 1
		AND	R1,R1,#0 	; SET TO ZERO
		BRz	INPUT_LOOP

TWO_COMP 
		LD R1, INT 		; LOAD INT
		NOT R1,R1 		; INT=!INT
		ADD R1,R1,#1 	; INT=INT + 1
		ST R1,INT  		; INT = (!INT) + 1
		AND R1,R1,#0 	; SET TO ZERO
		BRz START_MASK	; START_MASK

PRINT_ZERO
		LD R0,ZERO
		OUT
		BRp CONTINUE
PRINT_ONE 
		LD R0,ONE
		OUT
		BRp CONTINUE

GMS     .STRINGZ "Welcome to the conversion program\n"	
OUT_MES .STRINGZ "Enter a decimal number or X to quit:\n" 
THANKS	.STRINGZ "Thanks, here it is in binary\n"
BYE		.STRINGZ "Bye. Have a great day."
INT		.FILL #0
DIGIT	.FILL #0
FLAG	.FILL #0
CHAR	.FILL #-48
NEWLINE .FILL #-10		; '\n'
EXIT	.FILL #0
ZERO	.FILL #48
ONE		.FILL #49
NEG		.FILL #-45 		; '-'
X 		.FILL #-88
COUNT	.FILL #15
MULT_I	.FILL #10		; MULT ITERATION
MASK	.FILL x8000
		.FILL x4000
		.FILL x2000
		.FILL x1000	
		.FILL x800
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