; **************************
;  Initialization
; **************************
[bits 16]
[org 0x7C00] ; 31744d

; **************************
;  Main
; **************************
call EnterVideoMode
;jmp $

; **************************
;  Procedures
; **************************
PrintSingleCharacter:
  mov ah, 0x000E
  mov bh, 0x0000
  mov bl, 0x0007
  int 0x0010
  ret

%macro PutPixelAt 3
  mov bx, %2
  imul bx,320
  add bx, %1
  mov di, bx
  mov al, %3 
  mov [es:di], al
%endmacro
 
%macro LineFromTo 4
  mov [vx0], word %1
  mov [vy0], word %2
  mov [vx1], word %3
  mov [vy1], word %4
  mov ax, [vx1]                       ; dx = x1 - x0
  sub ax, [vx0]
  mov [vdx], ax     
  mov ax, [vy1]                       ; dy = y1 - y0
  sub ax, [vy0]
  mov [vdy], ax     
  mov ax, [vdy]                       ; d = 2*dy - dx
  imul ax, 2
  sub ax, [vdx]
  mov [vd], ax      
  mov ax, [vy0]                       ; y = y0
  mov [vy], ax      
  mov ax, [vx0]                       ; x = x0
  mov [vx], ax      
  %%.Each:                              ; (x0..x1).each do |x|        
    %%.f: PutPixelAt [vx],[vy],0x0f        
    %%.IfInEach:
    cmp word [vd], 0                  ; if d > 0
    jg  %%.True
    jle %%.AfterIf
    %%.True:          
      mov ax, [vy]                    ; y = y + 1z
      inc ax
      mov [vy], ax          
      mov ax, [vdx]                   ; d = d - 2*dx
      add ax, [vdx]
      sub [vd], ax
      jmp %%.AfterIf
    %%.AfterIf:          
      mov ax, [vdy]                   ; d = d + 2*dy
      add ax, [vdy]
      add [vd], ax          
      mov ax, [vx]                    ; x = x + 1 
      inc ax
      mov [vx], ax          
      mov ax, [vx]                    ; Each
      cmp ax, [vx1]          
      jle %%.Each
%endmacro 

%macro Project3DInto2D 3 
  mov word [x3], %1
  mov word [y3], %2
  mov word [z3], %3
  mov ax, [z3] ; int d = az/30;
  mov cx, 30   ; ?
  div cx       ; ?
  mov [d], ax
  mov ax, [z3] ; int d2 = az/20;
  mov cx, 20   ; ?
  div cx       ; ?
  mov [d2], ax
  mov ax, [x3] ; int bx = (ax*1) + d;
  add ax, [d]
  mov [x2], ax
  mov ax, [y3] ; int by = (ay*1) + d2 - 150;
  add ax, [d2]
  sub ax, 150
  mov [y2], ax
%endmacro 
 
EnterVideoMode:
  mov ax, 0x0013 
  int 0x0010
  mov ax, 0xA000 ; 40960d
  mov es, ax
  .Draw:
    LineFromTo 10,10, 135,20
    Project3DInto2D -100+250,-100+40,100+1500
    .Tst1: PutPixelAt [x2],[y2],0x0f
    jmp .Draw
          
;ExitVideoMode:
;  mov ax,0x0003 
;  int 0x0010

; **************************
;  Data
; **************************
vdx: dw 0x0000
vdy: dw 0x0000
vd:  dw 0x0000
vx:  dw 0x0000
vy:  dw 0x0000
vx0: dw 0
vy0: dw 0
vx1: dw 5
vy1: dw 5
;
x3:  dw 0
y3:  dw 0
z3:  dw 0
x2:  dw 0
y2:  dw 0  
;
vertices: db -100,-100,100, -100,100,100, -100,-100,-100, -100,100,-100, 100,-100,100,100,100,100,100,-100,-100,100,100,-100
faces___: db 2,4,3,1,4,8,7,3,8,6,5,7,6,2,1,5,1,3,7,5,6,8,4,2
model2d_: times 16 db 0
;
d:   dw 0
d2:  dw 0
;
; **************************
;  Ending
; **************************
times 510 - ($ - $$) db 0 ; zero-fill
dw 0xAA55 ; boot signature
