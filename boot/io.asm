
[bits 64]
; ==========
;  Reads ATA LBA disk
;  eax: LBA of the sector to read
;  bl: Number of the sectors to read
;  rdi: The address of buffer to be written
; ==========
ata_lba_read:
	pushfq
               and rax, 0x0FFFFFFF
               push rax
               push rbx
               push rcx
               push rdx
               push rdi
 
               mov r8, rax         ; Save LBA in r8
 
               mov dx, 0x1F6      ; Port to send drive and bit 24 - 27 of LBA
               shr eax, 24          ; Get bit 24 - 27 in al
               or al, 11100000b     ; Set bit 6 in al for LBA mode
               out dx, al
 
               mov dx, 0x1F2      ; Port to send number of sectors
               mov al, bl           ; Get number of sectors from CL
               out dx, al
 
               mov dx, 0x1F3       ; Port to send bit 0 - 7 of LBA
               mov eax, r8d         ; Get LBA from R8D
               out dx, al
 
               mov dx, 0x1F4       ; Port to send bit 8 - 15 of LBA
               mov eax, r8d         ; Get LBA from R8D
               shr eax, 8           ; Get bit 8 - 15 in AL
               out dx, al
 
 
               mov dx, 0x1F5       ; Port to send bit 16 - 23 of LBA
               mov eax, r8d         ; Get LBA from R8D
               shr eax, 16          ; Get bit 16 - 23 in AL
               out dx, al
 
               mov dx, 0x1F7       ; Command port
               mov al, 0x20         ; Read with retry.
               out dx, al

.loop_read:
			   mov dx, 0x1F7
			   in al, dx
			   in al, dx
			   in al, dx
			   in al, dx
.still_going:  
			   in al, dx
               test al, 1 << 3      ; the sector buffer requires servicing.
               jz .still_going      ; until the sector buffer is ready.

               mov dx, 0x1F0       ; Data port, in and out
               mov rcx, 256         ; to read 256 words = 1 sector, RCX is counter for INSW
               rep insw             ; in to [RDI]

			   sub bl, 1			; loop until all sectors read
			   cmp bl, 0
			   jnz .loop_read
 
               pop rdi
               pop rdx
               pop rcx
               pop rbx
               pop rax
               popfq
               ret
