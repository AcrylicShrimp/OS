; receiving the data in 'dx'
; For the examples we'll assume that we're called with dx=0x1234
print_hex:
    push rax
    push rbx
    push rcx

    mov rcx, 0 ; our index variable

; Strategy: get the last char of 'dx', then convert to ASCII
; Numeric ASCII values: '0' (ASCII 0x30) to '9' (0x39), so just add 0x30 to byte N.
; For alphabetic characters A-F: 'A' (ASCII 0x41) to 'F' (0x46) we'll add 0x40
; Then, move the ASCII byte to the correct position on the resulting string
hex_loop:
    cmp rcx, 2 ; loop 4 times
    je end
    
    ; 1. convert last char of 'dx' to ascii
    mov rax, rdx ; we will use 'ax' as our working register
    and rax, 0x000f ; 0x1234 -> 0x0004 by masking first three to zeros
    add al, 0x30 ; add 0x30 to N to convert it to ASCII "N"
    cmp al, 0x39 ; if > 9, add extra 8 to represent 'A' to 'F'
    jle step2
    add al, 7 ; 'A' is ASCII 65 instead of 58, so 65-58=7

step2:
    ; 2. get the correct position of the string to place our ASCII char
    ; bx <- base address + string length - index of char
    mov rbx, HEX_OUT + 1 ; base + length
    sub rbx, rcx  ; our index variable
    mov [rbx], al ; copy the ASCII char on 'al' to the position pointed by 'bx'
    ror rdx, 4 ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

    ; increment index and loop
    add rcx, 1
    jmp hex_loop

end:
    ; prepare the parameter and call the function
    ; remember that print receives parameters in 'bx'
    mov rbx, HEX_OUT
    call print

    pop rcx
    pop rbx
    pop rax
    ret

HEX_OUT:
    db '00',0 ; reserve memory for our new string
	