; r12 := key
; r11 
; r10 := working message word pointer
; r9
; r8
; r7  := case register for jump table


		THUMB
        AREA    |.text|, CODE, READONLY, ALIGN=2
        EXPORT  Start
			


key		DCD		0x37A2B89E		;
message	DCD		0x4D696368 		; Mich
		DCD		0x61656C5F 		; ael_
		DCD		0x4E65776D 		; Newm
		DCD		0x616E3A29 		; an:)
		DCD		0x0				; termination word

Start
		ADR		r12, key
		LDR		r12, [r12]
		ADR		r10, message	; load the message address pointer
		
encrpyt_loop
		LDR		r11, [r10], #4		; load a word
		CMP		r11, #0
		BEQ		.				; TODO -> branch to decrpyt
		
		;Not equal (still within the loop)
		BL		load_case
		
		
chose_encryption_case
		;BL		load_case
		;ADR		encrpyt_JumpTable
		;LDR

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encrpyt

decrypt

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
encrpyt_JumpTable
		DCD		case_0
		DCD		case_1
		DCD		case_2
		DCD		case_3
			
decrypt_JumpTable
		DCD		case_0_reverse
		DCD		case_1_reverse
		DCD		case_2_reverse
		DCD		case_3_reverse
		
load_case
		MOV		r7, #0
		BPL		positive_case
		BMI		negative_case

positive_case
		CMP		r0, #1000
		MOVLT	r7, #0
		MOVGE	r7, #1
		BX		lr

negative_case
		CMP		r0, #-1000
		MOVGT	r7, #2
		MOVLE	r7, #3
		BX		lr


case_0 ; 0 - 1000
		ROR		r0, r0, #5
		BX		lr
		
case_0_reverse
		ROR		r0, r0, #27
		BX		lr

case_1 ; 1000 - inf
		ROR		r0, r0, #18 
		BX		lr
		
case_1_reverse
		ROR		r0, r0, #14
		BX		lr

case_2 ; -1000 - 0
		ROR		r0, r0, #3
		BX		lr
		
case_2_reverse
		ROR		r0, r0, #29
		BX		lr

case_3 ; 0 - -1000
		ROR		r0, r0, #21
		BX		lr
		
case_3_reverse
		ROR		r0, r0, #11
		BX		lr
		
		ALIGN
		END