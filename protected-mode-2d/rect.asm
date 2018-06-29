%ifndef RECT_ASM
%define RECT_ASM

%macro rect 6
  ; 1 = X upper left corner
  ; 2 = Y upper left corner
  ; 3 = X bottom right corner
  ; 4 = Y bottom right corner
  ; 5 = if colorize?
  ; 6 = if not colorize, then what color
  mov  ax, %1
  mov  bx, %2
  mov  cx, %5
  ;
  mov  word [wall_x], ax
  mov  word [wall_y], bx
  mov  word [is_mix], cx
  ;
  %%column:  
    cmp  word [is_mix], 1
    je  %%color_mix
    jne  %%color_normal
  ;
  %%color_mix:
    point   word [wall_x], word [wall_y], byte [colorize]
    jmp  %%color_mix_next
  ;
  %%color_normal:
    mov  dh, %6
    mov  byte [rect_col], dh
    point  word [wall_x], word [wall_y], byte [rect_col]
  ;
  %%color_mix_next:
    inc  byte [colorize]
    cmp  byte [colorize], 11
    je  %%zero_color
    jne  %%next
  ;
  %%next:
    inc  word [wall_y]
    mov  ax, word [wall_y]
    cmp  ax, %4
    je  %%next_column
    jne  %%column
  ;
  %%next_column:
    mov  ax, %2
    mov  word [wall_y], ax
    inc  word [wall_x]
    mov  cx, %3
    cmp  word [wall_x], cx
    je  %%end_of_rect
    jne  %%column
  ;
  %%zero_color:
    mov  byte [colorize], 0
    jmp  %%column
  ;
  %%end_of_rect:
  ;
%endmacro


%endif
