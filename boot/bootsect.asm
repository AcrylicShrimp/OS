[org 0x7c00]
KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl ; Remember that the BIOS sets us the boot drive in 'dl' on boot
    mov bp, 0x9000
    mov sp, bp

    call load_kernel ; read the kernel from disk
    call switch_to_pm ; disable interrupts, load GDT,  etc. Finally jumps to 'BEGIN_PM'
    jmp $ ; Never executed

%include "disk.asm"
%include "gdt.asm"
%include "gdt64.asm"
%include "print.asm"
%include "print_hex.asm"
%include "print32.asm"
%include "switch32.asm"
%include "switch64.asm"

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET ; Read from disk and store in 0x1000
    mov dh, 16
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    call switch_to_long

[bits 64]
BEGIN_LONG:
    call KERNEL_OFFSET ; Give control to the kernel
    jmp $ ; Stay here when the kernel returns control to us (if ever)

BOOT_DRIVE db 0 ; It is a good idea to store it in memory because 'dl' may get overwritten

; padding
times 510-($-$$) db 0
dw 0xaa55
