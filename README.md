# x86-bootloader

## Runtime

Run with ```Bochs``` emulator or real hardware. Get ```NASM``` assembler. In case of Windows machine, get ```dd for Windows```. Put all three utilities to ```PATH``` environment variable. 

In order to generate binary from assembly source:
```
 nasm main.asm -f bin -o boot.bin
```

Assuming we want to run it as a floppy disk we need to create the image first:
```
dd if=/dev/zero of=disk.img bs=1024 count=1440
```

It will be zero-filled, so then put generated binary into this file:
```dd if=boot.bin of=disk.img conv=notrun```

```bochsrc.bxrc``` states that we are going to boot from floppy drive A.


## Objectives

Create bootloader based program targeting x86 architecture computer. Start in real mode.
