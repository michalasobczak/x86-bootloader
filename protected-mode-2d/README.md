# x86-bootloader-protected-mode

This is legacy NASM assembly code from 2005 entering x86 protected mode and drawing some 2D graphics. 4555 bytes long. Found 4 more recent versions but need to assess whether it will be useful to commit those changes here. Version 11 commited.

## Runtime

Having ```Bochs``` installed, just click on ```bochsrc.bxrc``` file to run the program.


## GDT

Global descriptor table is as follows:

```
gdt:                   ; Address for the GDT

gdt_null:              ; Null Segment
  dd  0
  dd  0

gdt_code:              ; Code segment, read/execute, nonconforming
  dw  0FFFFh
  dw  0
  db  0
  db  10011010b
  db  11001111b
  db  0

gdt_data:              ; Data segment, read/write, expand down
  dw  0FFFFh
  dw  0
  db  0
  db  10010010b
  db  11001111b
  db  0
  
gdt_end:               ; Used to calculate the size of the GDT

gdt_desc:              ; The GDT descriptor
  dw  gdt_end - gdt - 1      
                       ; Limit (size)
  dd  gdt              ; Address of the GDT
```

## MMX instructions
Using supplemental instruction set introduced by Intel in 1996. Below please find quad words operations example:

```
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
```

## Entering protected mode

In order to switch from real mode there is need to run few things starting from 16 bit mode and reading from the disk drive:

```
[BITS 16]               ; We need 16-bit intructions for Real mode
[ORG 0x7C00]            ; The BIOS loads the boot sector into memory location 0x7C00
;
reset_drive:
  mov  ah, 0            ; RESET-command
  int   13h             ; Call interrupt 13h
  or  ah, ah            ; Check for error code
  jnz  reset_drive      ; Try again if ah != 0
  ;
  mov  ax, 0
  mov  es, ax
  mov  bx, 0x1000       ; Destination address = 0000:1000
  ;
                        ; video mode
  mov  ah, 0
  mov  al, 13h          ; mode 13h, 320x200
  int   10h
  ;
  mov  ah, 02h          ; READ SECTOR-command
  mov  al, 10           ; Number of sectors to read = 1
  mov  ch, 0            ; Cylinder = 0
  mov  cl, 02h          ; Sector = 2
  mov  dh, 0            ; Head = 0
  mov  dl, 0
  int  13h              ; Call interrupt 13h
  or  ah, ah            ; Check for error code
  jnz  reset_drive      ; Try again if ah != 0
  ;
  cli                   ; Disable interrupts, we want to be alone
  ;
  xor  ax, ax
  mov  ds, ax           ; Set DS-register to 0 - used by lgdt
  ;
  lgdt  [gdt_desc]      ; Load the GDT descriptor
  ;
  mov  eax, cr0         ; Copy the contents of CR0 into EAX
  or  eax, 1            ; Set bit 0
  mov  cr0, eax         ; Copy the contents of EAX into CR0
  ;
  jmp  08h:clear_pipe   ; Jump to code segment, offset clear_pipe
;
; 
[BITS 32]               ; We now need 32-bit instructions
clear_pipe:
  mov  ax, 10h          ; Save data segment identifyer
  mov  ds, ax           ; Move a valid data segment into the data segment register
  mov  ss, ax           ; Move a valid data segment into the stack segment register
  mov  esp, 090000h     ; Move the stack pointer to 090000h
  ;
  ;
  jmp  08h:01000h       ; Jump to section 08h (code), offset 01000h
  ;
```
