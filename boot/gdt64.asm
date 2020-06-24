;
; GDT definition for Long Mode
;
; See https://www.amd.com/system/files/TechDocs/24593.pdf
;

GDT64:
	.NULLSEG: equ $ - GDT64     ; Null-Segment Descriptor
	    dq 0

	.CODESEG: equ $ - GDT64     ; Code-Segment Descriptor
	    dw 0                        ; segment limit[15:0]
	    dw 0                        ; base address[15:0]
	    db 0                        ; base address[23:16]
	    db 10011010b                ; A,R,C,1,1,DPL,P
	    db 10101111b                ; segment limit[19:16],AVL,L,D,G
	    db 0                        ; base address[31:24]

	.DATASEG: equ $ - GDT64     ; Data-Segment Descriptor
	    dw 0                        ; segment limit[15:0]
	    dw 0                        ; base address[15:0]
	    db 0                        ; base address[23:16]
	    db 10010010b                ; A,W,E,0,1,DPL,P
	    db 00000000b                ; segment limit[19:16],AVL,-,D/B,G
	    db 0                        ; base address[31:24]

	.POINTER:                   ; GDTR
	    dw $ - GDT64 - 1            ; limit             2 bytes
	    dq GDT64                    ; base address      8 bytes
		