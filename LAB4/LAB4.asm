.ORIG X3000

AND R0,R0,0
AND R1,R1,0
AND R2,R2,0
AND R3,R3,0
AND R4,R4,0
AND R5,R5,0
AND R6,R6,0
AND R7,R7,0

	LEA R0,GREETING
	PUTS

START_PROGRAM
	LEA R0,OPTIONS
	PUTS
GET_INPUT
	GETC
	OUT
	LD R1,LF	; '\n'
	ADD R1,R0,R1
	BRz GET_CIPHER	; if char == LF
	LD R1,D
	ADD R1,R0,R1
	BRz FLAG_D 		; if char == D
	LD R1,E
	ADD R1,R0,R1
	BRz FLAG_E 		; if char == E
	LD R1,X
	ADD R1,R0,R1
	BRz FLAG_X 		; if char == X
	BRnp GET_INPUT	;if user entered some other letters, loop back
GET_CIPHER
	LD R1,FLAG
	BRn EXIT_PROGRAM ; if flag = -1: exit
	LEA R0,CIPHER_KEY
	PUTS
CIPHER_INPUT
	GETC
	OUT
	LD R1,LF
	ADD R1,R0,R1
	BRz D_E 		; if char == '\n'
	LD R1,ZERO 		; R1 = 48 
	ADD R1,R0,R1	; R1 = char -48
	ST R1,DIGIT 	; digit = char - 48
	;Start mulitplication
	ADD R4,R4,10	; COUNTER
	LD R2,CIPHER

MULT_LOOP
	ADD R3,R3,R2	; CIPHER*10
	ADD R4,R4,-1	; R4 -= 1
	BRp MULT_LOOP 	
	ADD R3,R1,R3 	; Cipher = Cipher * 10 + digit
	ST R3,CIPHER 	; Cipher = Cipher * 10 + digit
	AND R3,R3,0 	; reset to zero
	BRnzp CIPHER_INPUT

D_E 
	AND R4,R4,0			; REINIT
	AND R3,R3,0			; REINIT
	AND R2,R2,0			; REINIT 
	AND R1,R1,0			; REINIT
	LEA R2,ARRAY 		; ARRAY[I]
	LEA R3,ARRAY 	    ; ARRAY[I+200]
	LD R4,DE_ARRAY
	ADD R3,R3,R4  ; ARRAY[200]
	LD R1,FLAG
	BRn EXIT_PROGRAM	; if flag = -1
	BRz GET_D_STRING	; if flag = 0
	BRp GET_E_STRING	; if flag = 1

EXIT_PROGRAM
	LEA R0,ARRAY
	PUTS
	LD R0,LF
	NOT R0,R0
	ADD R0,R0,1
	OUT
	LD R4,DE_ARRAY
	ADD R0,R0,R4
	PUTS
	LD R0,LF
	NOT R0,R0
	ADD R0,R0,1
	OUT

HALT

GET_E_STRING
	GETC
	OUT
	STR R0,R2,0 	; ARRAY[i] = char
	JSR DECRYPT_CHAR 
	ADD R2,R2,1 	; ARRAY++
	LD R1,LF		; R1 = '\n'
	ADD R1,R0,R1 	; if char == '\n'
	BRp GET_E_STRING; IF LF EXIT else get input
	AND R0,R0,0
	STR R0,R2,0     ; ARRAY[i]='\0'
	STR R0,R3,0  	; ARRAY[200+I] = '\0'
	BRz EXIT_PROGRAM
GET_D_STRING
	GETC
	OUT
	STR R0,R2,0 	; ARRAY[i] = char
	BR EXIT_PROGRAM
FLAG_D
	ADD R1,R1,1
	ST R1,FLAG
	AND R1,R1,0
	BRz GET_INPUT
FLAG_E	
	ADD R1,R1,0
	ST R1,FLAG
	AND R1,R1,0
	BRz GET_INPUT
FLAG_X
	ADD R1,R1,-1
	ST R1,FLAG
	AND R1,R1,0
	BRz GET_INPUT
DECRYPT_CHAR
	LD R4,CIPHER
	NOT R4,R4           ; CIPHER * -1
	Add R4,R4,1
	ADD R0,R0,R4 	    ; ARRAY[I]CHAR - CIPHER
	OUT
	STR R4,R3,0    		; 
	ADD R3,R3,1			; ARRAY[200]++
	RET


GREETING	.STRINGZ "Hello, welcome to my Caesar Cipher program\n"
OPTIONS		.STRINGZ "Do you want to (E)ncrypt or (D)ecrypt or e(X)it?\n"
CIPHER_KEY 	.STRINGZ "What is the cipher (1-25)?\n"
FLAG        .FILL 0
D 			.FILL -68
E 			.FILL -69
LF			.FILL -10
X 			.FILL -88
ZERO 		.FILL -48
CIPHER  	.FILL 0
DIGIT 		.FILL 0
DE_ARRAY 	.FILL 200
ARRAY 		.BLKW 400

.END