; **************************
;  Initialization
; **************************
[bits 16]
[org 0x7c00]

; **************************
;  Main
; **************************
mov si, HelloString
call PrintString
jmp $

; **************************
;  Procedures
; **************************
PrintCharacter:
  mov ah, 0x0e
  mov bh, 0x00
  mov bl, 0x07
  int 0x10
  ret

PrintString:
  next_character:	
    mov al, [si]
    inc si
    or al, al
    jz exit_function
    call PrintCharacter
    jmp next_character

exit_function:
  ret

; **************************
;  Data
; **************************
HelloString db 'Hello, world!', 0

; **************************
;  Ending
; **************************
TIMES 510 - ($ - $$) db 0
DW 0xAA55