
KERNEL_ADDRESS equ 0x10000

[org 0x7c00]
[bits 16]
jmp switch_to_long

[bits 64]
long_main:
	call init_print

	mov eax, 1
	mov rbx, 5
	mov rdi, KERNEL_ADDRESS
	call ata_lba_read

	call KERNEL_ADDRESS
	jmp $

%include "io.asm"
%include "gdt64.asm"
%include "switch64.asm"
%include "print.asm"
%include "print_hex.asm"

; padding
times 510-($-$$) db 0
dw 0xaa55
