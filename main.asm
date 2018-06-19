; **************************
;  Initialization
; **************************
[bits 16]
[org 0x7c00]

; **************************
;  Main
; **************************
mov si, HelloString
; call PrintString
call EnterVideoMode
jmp $

; **************************
;  Procedures
; **************************
PrintSingleCharacter:
  mov ah, 0x0e
  mov bh, 0x00
  mov bl, 0x07
  int 0x10
  ret

PrintString:
  NextCharacter:	
    mov al, [si]
    inc si
    or al, al
    jz ExitFunction
    call PrintSingleCharacter
    jmp NextCharacter

EnterVideoMode:
  mov ax, 0x13 
  int 0x10
  WhileTrue:
    nop
    jmp WhileTrue
  ;call ExitVideoMode

ExitVideoMode:
  mov ax,0003h 
  int 10h
  
ExitFunction:
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