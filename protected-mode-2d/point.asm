%ifndef POINT_ASM
%define POINT_ASM

%macro point 3
  mov  esi, 010000h
  mov  ax, %1                ; move X coord into ax
  mov  word [point_x], ax    ; move ax into point_x
  mov  ax, %2                ; move Y coord into ax  
  mov  word [point_y], ax    ; move ax into point_y
  ;
  imul  ax, 320              ; multiply eax and 320
  mov  word [point_y], ax    ; move eax into point_y
  ;
  add  si, word [point_x]    ; add point_x to bx
  add  si, word [point_y]    ; add point_y to bx
  ;
  mov  ah, %3
  mov  [ds:esi],  ah         ; move color number into ds:ebx
  ;
  xor  eax, eax              ; zeroing eax
%endmacro

%macro draw_screen 0
  mov     esi, 010000h
  mov     edi, 0A0000h
  mov     cx, 1000    
  ;
  %%copy_loop: 
    movq  mm0, [esi]
    movq  mm1, [esi+8]
    movq  mm2, [esi+16]
    movq  mm3, [esi+24]
    movq  mm4, [esi+32]
    movq  mm5, [esi+40]
    movq  mm6, [esi+48]
    movq  mm7, [esi+56]
    ;
    movq  [edi],    mm0
    movq  [edi+8],  mm1
    movq  [edi+16], mm2
    movq  [edi+24], mm3
    movq  [edi+32], mm4
    movq  [edi+40], mm5
    movq  [edi+48], mm6
    movq  [edi+56], mm7
    ;
    add  esi, 64
    add  edi, 64
    loop    %%copy_loop
%endmacro


%endif
