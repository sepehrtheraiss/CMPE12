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
AND R0,R0,0
AND R1,R1,0
AND R2,R2,0
AND R3,R3,0
AND R4,R4,0
AND R5,R5,0
AND R6,R6,0
AND R7,R7,0
ST R1,CIPHER
ST R1,DIGIT
	LEA R0,OPTIONS
	PUTS
GET_INPUT
	GETC
	OUT
	LD R1,LF	    ; '\n'
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
	LD R0,CIPH_ADDRESS
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

D_E  ; DECRYPT and Encrypt
	AND R6,R6,0			; REINIT
	AND R5,R5,0			; REINIT
	AND R4,R4,0			; REINIT
	AND R3,R3,0			; REINIT
	AND R2,R2,0			; REINIT 
	AND R1,R1,0			; REINIT
	LD R2,ARR_ADDRESS
	LD R3,ARR_ADDRESS 
	LD R4,DE_ARRAY
	ADD R3,R3,R4  	    ; ARRAY[200]
	LD R1,FLAG
	BRn EXIT_PROGRAM	; if flag = -1
	BRz GET_D_STRING	; if flag = 0
	BRp GET_E_STRING	; if flag = 1

EXIT_PROGRAM AND R6,R6,0 ; compiler complains
	LD R0,GG
	PUTS
HALT
	GG .FILL GOODBYE
	ARR_ADDRESS .FILL ARRAY
	EN_ADDRESS .FILL EN_MESSAGE
	DE_ADDRESS .FILL DE_MESSAGE
	CIPH_ADDRESS .FILL CIPHER_KEY 
	STR_ADDRESS  .FILL STR_MESSAGE   

GET_E_STRING
	LD R0,STR_ADDRESS
	PUTS
CON_E	GETC
	OUT
	STR R0,R2,0 	; ARRAY[i] = char
	JSR DECRYPT_CHAR 
	ADD R2,R2,1 	; ARRAY++
	LD R1,LF		; R1 = '\n'
	ADD R1,R0,R1 	; if char == '\n'
	BRp CON_E	; IF LF EXIT else get input
	AND R0,R0,0
	STR R0,R2,0     ; ARRAY[i]='\0'
	STR R0,R3,0  	; ARRAY[200] = '\0'
	JSR PRINT_STUFF
	LD R0,A
	BRnzp START_PROGRAM
GET_D_STRING 
		LEA R0,STR_MESSAGE
	PUTS
CON_D	GETC
	OUT
	STR R0,R3,0 	; ARRAY[200] = char
	JSR ENCRYPT_CHAR 
	ADD R3,R3,1 	; ARRAY++
	LD R1,LF		; R1 = '\n'
	ADD R1,R0,R1 	; if char == '\n'
	BRp CON_D	; IF LF EXIT else get input
	AND R0,R0,0
	STR R0,R2,0     ; ARRAY[i]='\0'
	STR R0,R3,0  	; ARRAY[200] = '\0'
	JSR PRINT_STUFF
	LD R0,A
	BRnzp START_PROGRAM

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
	ST R0,VAR_A
	ST R1,VAR_B
	ST R5,VAR_C
	LD R5,A 			; 65
	NOT R5,R5
	ADD R5,R5,1			; -65
	ADD R1,R0,R5		; char - 65
	BRn NO_CRYPTION 	; char - 65 < 0 
	LD R5,Z				; 90 
	NOT R0,R0 			
	ADD R0,R0,1			; -char
	ADD R1,R5,R0		; 90 - char
	BRn GREATER_THAN_Z 	; 90 - char < 0 
D_CHAR	LD R0,VAR_A
	LD R5,CIPHER
	NOT R5,R5           ; CIPHER * -1
	ADD R5,R5,1	 		; CIPHER * -1
	ADD R0,R0,R5 	    ; char - cipher
	STR R0,R3,0    		; ARRAY[200+i] = char - cipher
RESUME_D	
	ADD R3,R3,1			; ARRAY[200]++
	LD R0,VAR_A
	LD R1,VAR_B
	LD R5,VAR_C
	RET
ENCRYPT_CHAR
	ST R0,VAR_A
	ST R7,VAR_B
	LD R5,A 			; 65
	NOT R5,R5
	ADD R5,R5,1			; -65
	ADD R1,R0,R5		; char - 65
	BRn NO_CRYPTION 	; char - 65 < 0 
E_CHAR	LD R0,VAR_A
	LD R4,CIPHER 		; CIPHER
	ADD R0,R0,R4 		; CHAR + CIPHER
	;OUT
RESUME_E		; Check for overflow
	STR R0,R2,0			; ARRAY[i] = CHAR + CIPHER
	ADD R2,R2,1 		; ARRAY[i]++
	LD R0,VAR_A
	LD R7,VAR_B
	RET
NO_CRYPTION  ; doesnt need cryptioning 
	LD R0,VAR_A
	LD R5,FLAG
	BRp ADD_TO_DECRYPTED ; flag = 1
	BRz ADD_TO_ENCRYPTED ; flag = 0
GREATER_THAN_Z
	NOT R0,R0
	ADD R0,R0,1 		; + char
	LD R5,a				; 97
	NOT R5,R5 			
	ADD R5,R5,1			; -97
	ADD R1,R0,R5		; char - 97
	BRn NO_CRYPTION  	; char - 97 < 0
	LD R5,z				; 122
	NOT R0,R0 			
	ADD R0,R0,1			; -char
	ADD R1,R0,R5		; 122 - char
	BRn NO_CRYPTION  	; 122 - char < 0
	LD R5,FLAG
	BRz E_CHAR;encrypt
	BRp D_CHAR; decrypt
ADD_TO_DECRYPTED
	STR R0,R3,0
	BRnzp RESUME_D
ADD_TO_ENCRYPTED
	STR R0,R2,0
	BRnzp RESUME_E	
PRINT_STUFF
	ST R7,VAR_B	
	ST R0,VAR_A
	LD R0,FLAG
	BRz P_H_E 	; print here encrypted 
	LEA R0,HERE_D   ; print here decrypted 
	PUTS
C_P_STUFF AND R6,R6,0
	LD R0,EN_ADDRESS  
	PUTS
	LD R0,ARR_ADDRESS
	PUTS
	LD R0, DE_ADDRESS 
	PUTS
	LD R4,DE_ARRAY ; value 200
	LD R0,ARR_ADDRESS ;ARRAY[200]
	ADD R0,R0,R4	;ARRAY[200]
	PUTS
	LD R0,VAR_A
	LD R7,VAR_B
	RET
P_H_E 
	LEA R0, HERE_E 
	PUTS
	BRnzp C_P_STUFF 	; continue print stuff
FLAG      	.FILL 0
A 	  	.FILL 65
Z 			.FILL 90
a 			.FILL 97
z 			.FILL 122
D 			.FILL -68
E 			.FILL -69
LF			.FILL -10
X 			.FILL -88
ZERO 		.FILL -48
CIPHER  	.FILL 0
DIGIT 		.FILL 0
DE_ARRAY 	.FILL 200
VAR_A		.FILL 0
VAR_B		.FILL 0
VAR_C  		.FILL 0		
GREETING	.STRINGZ "Hello, welcome to my Caesar Cipher program\n"
OPTIONS		.STRINGZ "Do you want to (E)ncrypt or (D)ecrypt or e(X)it?\n"
CIPHER_KEY 	.STRINGZ "What is the cipher (1-25)?\n"
STR_MESSAGE     .STRINGZ "What is the string(up to 200 characters)?\n"
HERE_D		.STRINGZ "Here is your string and the decrypted result\n"
HERE_E 		.STRINGZ "Here is your string and the encrypted result\n"
GOODBYE 	.STRINGZ "Goodbye\n"
EN_MESSAGE 	.STRINGZ "<Encrypted> "
DE_MESSAGE 	.STRINGZ "<Decrypted> "
ARRAY 		.BLKW 400
.END
