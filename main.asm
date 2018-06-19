; **************************
;  Initialization
; **************************
[bits 16]
[org 0x7C00]

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
  mov ah, 0x000E
  mov bh, 0x0000
  mov bl, 0x0007
  int 0x0010
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
  mov ax, 0x0013 
  int 0x0010
  Draw:
    ; segment
    mov ax, 0xA000 ; 40960d
    mov es, ax
    ; offset 0
    xor di, di
    ; 
    mov ax, 0x0F ; white 
    mov cx, 0x7D00 ; 32000d
    rep stosb
    ;
    mov ax, 0x04 ; red 
    mov cx, 0x7D00 ; 32000d
    rep stosb
  Control:
    nop
    jmp Control
  ;call ExitVideoMode

ExitVideoMode:
  mov ax,0x0003 
  int 0x0010
  
ExitFunction:
  ret

; **************************
;  Data
; **************************
HelloString db 'Hello, world!', 0

; **************************
;  Ending
; **************************
TIMES 510 - ($ - $$) db 0 ; zero-fill
DW 0xAA55 ; boot signature