; r12 := key
; r11 
; r10 := working message word pointer
; r9  := encrpytion jump table ADDRESS
; r8  := decryption jump table ADDRESS
; r7  := case register for jump table


		THUMB
        AREA    |.text|, CODE, ALIGN=2
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
		ADR		r9, encrpyt_JumpTable
		LDR		r9, [r9]
		ADR		r8, decrypt_JumpTable
		LDR		r8, [r8]

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

encrpyt_loop
		LDR		r0, [r10], #4	; load a word
		CMP		r0, #0
		BEQ		decrpyt			
		
		;Not equal (still within the loop)
		BL		load_case
		LDR		pc, [r9, r7, LSL #2]
		
encrpyt_store
		PUSH	{r0}
		B		encrpyt_loop

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

decrpyt
		ADD		r10, sp, #12
		MOV		r0, #0
		PUSH	{r0}			; push null terminator
		
decrpyt_loop
		LDR		r0, [r10], #-4
		CMP		r0, #0
		BEQ		validate

		; NE -> Still in the loop
		BL		load_case
		LDR		pc, [r8, r7, LSL #2]

decrpyt_store
		PUSH 	{r0}
		B		decrpyt_loop
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

validate
		POP		{r0, r1, r2, r3}
		ADR		r10, message
word_0
		LDR		r4, [r10], #4
		CMP		r3, r4
		BNE		stop

word_1
		LDR		r4, [r10], #4
		CMP		r2, r4
		BNE		stop

word_2
		LDR		r4, [r10], #4
		CMP		r1, r4
		BNE		stop	

word_3
		LDR		r4, [r10]
		CMP		r0, r4
		BNE		stop

stop	B		.

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
		B		encrpyt_store
		
case_0_reverse
		ROR		r0, r0, #27
		B		decrpyt_store

case_1 ; 1000 - inf
		ROR		r0, r0, #18 
		B		encrpyt_store
		
case_1_reverse
		ROR		r0, r0, #14
		B		decrpyt_store

case_2 ; -1000 - 0
		ROR		r0, r0, #3
		B		encrpyt_store
		
case_2_reverse
		ROR		r0, r0, #29
		B		decrpyt_store

case_3 ; 0 - -1000
		ROR		r0, r0, #21
		B		encrpyt_store
		
case_3_reverse
		ROR		r0, r0, #11
		B		decrpyt_store
		
		ALIGN
		END