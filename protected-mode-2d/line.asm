%ifndef  LINE_ASM
%define  LINE_ASM

%macro line_horz 4
  pusha
  mov  ax, %1
  mov  bx, %2
  mov  cx, %3
  mov  dh, %4
  ;
  mov  word [line_horz_x], ax
  mov  word [line_horz_y], bx
  mov  word [line_horz_len], cx
  mov  byte [line_horz_col], dh
  ;
  %%draw:
    point  word[line_horz_x],word[line_horz_y],byte[line_horz_col]
    inc  word [line_horz_x]
    mov  ax, word [line_horz_len]
    cmp  word [line_horz_x], ax
    jb  %%draw
    ja  %%end  
  %%end:
    popa
%endmacro

%macro line_vert 4
  pusha
  mov  ax, %1
  mov  bx, %2
  mov  cx, %3
  mov  dh, %4
  ;
  mov  word [line_horz_x], ax
  mov  word [line_horz_y], bx
  mov  word [line_horz_len], cx
  mov  byte [line_horz_col], dh
  ;
  %%draw:
    point  word[line_horz_x],word[line_horz_y],byte[line_horz_col]
    inc  word [line_horz_y]
    mov  ax, word [line_horz_len]
    cmp  word [line_horz_y], ax
    jb  %%draw
    ja  %%end  
  %%end:
    popa
%endmacro

%macro line_up 4
  pusha
  mov  ax, %1
  mov  bx, %2
  mov  cx, %3
  mov  dh, %4
  ;
  mov  word [line_horz_x], ax
  mov  word [line_horz_y], bx
  mov  word [line_horz_len], cx
  mov  byte [line_horz_col], dh
  ;
  %%draw:
    point  word[line_horz_x],word[line_horz_y],byte[line_horz_col]
    inc  word [line_horz_x]
    dec  word [line_horz_y]
    mov  ax, word [line_horz_len]
    cmp  word [line_horz_y], ax
    jne  %%draw
    je  %%end
  ;
  %%end:
    popa
%endmacro

%macro line_down 4
  pusha
  mov  ax, %1
  mov  bx, %2
  mov  cx, %3
  mov  dh, %4
  ;
  mov  word [line_horz_x], ax
  mov  word [line_horz_y], bx
  mov  word [line_horz_len], cx
  mov  byte [line_horz_col], dh
  ;
  %%draw:
    point  word[line_horz_x],word[line_horz_y],byte[line_horz_col]
    inc  word [line_horz_x]
    inc  word [line_horz_y]
    mov  ax, word [line_horz_len]
    cmp  word [line_horz_y], ax
    jne  %%draw
    je  %%end
  ;
  %%end:
    popa
%endmacro


%endif
