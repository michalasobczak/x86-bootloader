[BITS 32]

%include "line.asm"
%include "logo.asm"
%include "point.asm"
%include "rect.asm"

mov  word [rect_x1], 100
mov  word [rect_y1], 40
mov  word [rect_x2], 220
mov  word [rect_y2], 160
;
mov  word [rect2_x1], 250
mov  word [rect2_y1], 100
mov  word [rect2_x2], 251
mov  word [rect2_y2], 101
;
;
video:
  finit
  ;
  rect  0,   0,   160, 200, 0, byte [color]
  rect  160, 0,   320, 200, 0, byte [color2] 
  logo
  ;
  rect  word [rect_x1], word [rect_y1], word [rect_x2], word [rect_y2], 0, 0
  inc   word [rect_x1]
  inc   word [rect_y1]
  dec   word [rect_x2]
  dec   word [rect_y2]
  rect  word [rect_x1], word [rect_y1], word [rect_x2], word [rect_y2], 1, 1
  ;
  rect  word [rect2_x1], word [rect2_y1], word [rect2_x2], word [rect2_y2], 0, 0
  dec   word [rect2_x1]
  dec   word [rect2_y1]
  inc   word [rect2_x2]
  inc   word [rect2_y2]
  rect  word [rect2_x1], word [rect2_y1], word [rect2_x2], word [rect2_y2], 0, 4
  ;
  line_vert  100, 10, 190, 7
  line_horz  101, 40, 300, 8
  ;
  line_up    50, 190, 160, 14
  line_down  50, 160, 190, 15
  line_horz  50, 175, 80,  4
  line_vert  65, 160, 190, 7
  ;
  draw_screen
  inc  byte [color]
  times 2 inc  byte [color2]
  ;
  check:
    cmp  word [rect_x1], 130
    ja  zeroing
    jmp  check2
  ;
  check2:
    cmp  word [rect2_x1], 230
    jb  zeroing2
    jmp  video
  ;
  zeroing:
    mov  word [rect_x1], 100
    mov  word [rect_y1], 40
    mov  word [rect_x2], 220
    mov  word [rect_y2], 160
    jmp  check2
    ;
    zeroing2
    mov  word [rect2_x1], 250
    mov  word [rect2_y1], 100
    mov  word [rect2_x2], 251
    mov  word [rect2_y2], 101
    jmp  video
  ;  
  jmp  video                    ; ?
;
;
;***********************************************************************
; DATA
;***********************************************************************
.data
;
;***********************************************************************
; point
;***********************************************************************
point_x  dw 0
point_y  dw 0
point_color  dw 0
;
;***********************************************************************
; line
;***********************************************************************
line_horz_x    dw 0
line_horz_y    dw 0
line_horz_len  dw 0
line_horz_col  dw 0
;
;***********************************************************************
; rect
;***********************************************************************
wall_x    dw 0    ; rect, X upper left corner
wall_y    dw 0    ; rect, Y upper left corner
colorize  dd 1    ; rect, colorize effect 
is_mix    dd 0    ; rect, colorize effect
rect_col  dw 0    ; rect color
;----------------
rect_x1   dw 0
rect_y1   dw 0
rect_x2   dw 0
rect_y2   dw 0
;
rect2_x1  dw 0
rect2_y1  dw 0
rect2_x2  dw 0
rect2_y2  dw 0
;
;***********************************************************************
; other
;***********************************************************************
color    dw 0
color2    dw 0
