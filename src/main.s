; r12 := key
; r11 := recieved word
; r10
; r9
; r8
; r7  := case register for jump table

		THUMB
        AREA    |.text|, CODE, READONLY, ALIGN=2
        EXPORT  Start
			


key		DCD		0x37A2B89E
message	DCD		0x

Start
		ADR		r12, key
		LDR		r12, [r12]
		ADR		r11, message
		LDR		r11, message

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encrpyt

decrypt

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
JumpTable
		DCD		case_0
		DCD		case_1
		DCD		case_2
		DCD		case_3
		
load_case
		MOVS	r0, r12
		MOVPL

case_0

case_1

case_2

case_3
		
		ALIGN
		END