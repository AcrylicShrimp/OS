[org 0x7c00]

; KERNEL_ADDRESS equ 0x1000

%include "gdt64.asm"
%include "switch64.asm"

[bits 64]
long_main:
	; call KERNEL_ADDRESS

	; Blank out the screen to a blue color.
	mov edi, 0xB8000
	mov rcx, 500                      ; Since we are clearing uint64_t over here, we put the count as Count/4.
	mov rax, 0x1F201F201F201F20       ; Set the value to set the screen to: Blue background, white foreground, blank spaces.
	rep stosq                         ; Clear the entire screen. 
 
	; Display "Hello World!"
	mov edi, 0x00b8000              
 
	mov rax, 0x1F6C1F6C1F651F48    
	mov [edi],rax
 
	mov rax, 0x1F6F1F571F201F6F
	mov [edi + 8], rax
 
	mov rax, 0x1F211F641F6C1F72
	mov [edi + 16], rax

	jmp $

; padding
times 510-($-$$) db 0
dw 0xaa55
