
%define PAGE_PRESENT    (1 << 0)
%define PAGE_WRITE      (1 << 1)

ALIGN 4
IDT:
    .LENGTH		dw 0
    .BASE       dd 0

[bits 16]
switch_to_long:
	; Erase 16KiB to zero
	push di                           ; REP STOSD alters DI.
	mov ecx, 0x1000
	xor eax, eax
	cld
	rep stosd
	pop di

	; Build the Page Map Level 4.
	; es:di points to the Page Map Level 4 table.
	lea eax, [es:di + 0x1000]         	; Put the address of the Page Directory Pointer Table in to EAX.
	or eax, PAGE_PRESENT | PAGE_WRITE 	; Or EAX with the flags - present flag, writable flag.
	mov [es:di], eax                  	; Store the value of EAX as the first PML4E.

	; Build the Page Directory Pointer Table.
	lea eax, [es:di + 0x2000]         	; Put the address of the Page Directory in to EAX.
	or eax, PAGE_PRESENT | PAGE_WRITE 	; Or EAX with the flags - present flag, writable flag.
	mov [es:di + 0x1000], eax         	; Store the value of EAX as the first PDPTE.

	; Build the Page Directory.
	lea eax, [es:di + 0x3000]         	; Put the address of the Page Table in to EAX.
	or eax, PAGE_PRESENT | PAGE_WRITE 	; Or EAX with the flags - present flag, writeable flag.
	mov [es:di + 0x2000], eax         	; Store to value of EAX as the first PDE.
 
	push di                           	; Save DI for the time being.
	lea di, [di + 0x3000]             	; Point DI to the page table.
	mov eax, PAGE_PRESENT | PAGE_WRITE	; Move the flags into EAX - and point it to 0x0000.

	; Build the Page Table.
	.loop_page_table:
		mov [es:di], eax
		add eax, 0x1000
		add di, 8
		cmp eax, 0x200000             ; If we did all 2MiB, end.
		jb .loop_page_table
 
	pop di                            ; Restore DI.
 
	; Disable IRQs
	mov al, 0xFF                      ; Out 0xFF to 0xA1 and 0x21 to disable all IRQs.
	out 0xA1, al
	out 0x21, al
 
	nop
	nop
 
	lidt [IDT]                        ; Load a zero length IDT so that any NMI causes a triple fault.
 
	; Enter long mode.
	mov eax, 10100000b                ; Set the PAE and PGE bit.
	mov cr4, eax
 
	mov edx, edi                      ; Point CR3 at the PML4.
	mov cr3, edx
 
	mov ecx, 0xC0000080               ; Read from the EFER MSR. 
	rdmsr    
 
	or eax, 0x00000100                ; Set the LME bit.
	wrmsr
 
	mov ebx, cr0                      ; Activate long mode -
	or ebx,0x80000001                 ; - by enabling paging and protection simultaneously.
	mov cr0, ebx
 
	lgdt [GDT64.POINTER]              ; Load GDT64.POINTER.
 
	jmp GDT64.CODESEG:init_long  ; Load CS with 64 bit segment and flush the instruction cache

[bits 64]
init_long:
	mov ax, 0
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	jmp long_main
	