%ifndef SOUND_ASM
%define SOUND_ASM 

%macro wait 1
  times %1 HLT
%endmacro

%macro beep 1
  mov  bx, %1
  ;
  mov  al, 0B6h
  out  43h, al
  ;
  mov  al, bl
  out  42h, al
  ;
  mov  al, bh
  out  42h, al
  ;
  in  al, 61h
  or  al, 11b
  out  61h, al
  ;
  wait 1
  ;
  in  al, 61h
  and  al, 11111100b
  out  61h, al
%endmacro
  

%endif
