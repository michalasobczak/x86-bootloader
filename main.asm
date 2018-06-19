; **************************
;  Initialization
; **************************
[bits 16]
[org 0x7C00] ; 31744d

; **************************
;  Main
; **************************
;mov si, HelloString
;call PrintString
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

%macro PutPixelAt 3
  mov bx, %2
  imul bx,320
  add bx, %1
  mov di, bx
  mov al, %3 
  mov [es:di], al
%endmacro
    
EnterVideoMode:
  mov ax, 0x0013 
  int 0x0010
  mov ax, 0xA000 ; 40960d
  mov es, ax
Draw:
    f: PutPixelAt 100,100,0x0f
    jmp Draw

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
