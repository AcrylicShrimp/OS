[bits 64]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; the color byte for each character

init_print:
    mov rsi, VIDEO_MEMORY
    ret

print:
    push rax
    push rbx

; keep this in mind:
; while (string[i] != 0) { print string[i]; i++ }

; the comparison for string end (null byte)
start:
    mov al, [rbx] ; 'rbx' is the base address for the string
    mov ah, WHITE_ON_BLACK

    cmp al, 0
    je done

    mov [rsi], ax
    add rbx, 1
    add rsi, 2

    jmp start

done:
    pop rbx
    pop rax
    ret
