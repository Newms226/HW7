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
message	DCD		0x0

Start
		ADR		r12, key
		LDR		r12, [r12]
		ADR		r11, message
		LDR		r11, message
		BL		load_case

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
		MOV		r7, #0
		MOVS	r0, r12
		BPL		positive_case
		BMI		negative_case

positive_case
		CMP		r0, #1000
		MOVLT	r7, #0
		MOVGE	r7, #1
		BEX		lr

negative_case
		CMP		r0, #-1000
		MOVGT	r7, #2
		MOVLE	r7, #3
		BEX		lr


case_0 ; 0 - 1000
		ROR		r0, r0, #5
		BEX		lr
		
case_0_reverse
		ROR		r0, r0, #27
		BEX		lr

case_1 ; 1000 - inf

case_2 ; -1000 - 0

case_3 ; 0 - -1000
		
		ALIGN
		END