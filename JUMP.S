	AREA 	ArithGate, CODE	; name this block of code
	ENTRY					; mark the first instruction to call
main	
	MOV		r0, #2			; set up three parameters
	MOV		r1, #'a'
	MOV		r2, #'!'
	BL		rotfunc		; call the function
	B		.		; terminate

rotfunc					; label the function 
					; argument
	ADR		r3, JumpTable	; Load address of the jump table
	LDR		pc,[r3,r0,LSL #2] ; Jump to appropriate routine

JumpTable
	DCD		subCase1
	DCD		subCase2
	DCD		subCase3
	DCD		DoSub
	DCD		DoRsb

subCase1
	MOV		r0, r1			; Operation 0, >4
	BX		lr
subCase2
	MOV		r0, r2			; Operation 1
	BX		lr
subCase3
	MOV		r0, r1, ROR #12		; Operation 2
	BX		lr
DoSub
	SUB		r0, r1, r2		; Operation 3
	BX		lr
DoRsb
	RSB		r0, r1, r2		; Operation 4
	BX		lr

	END						; mark the end of this file
