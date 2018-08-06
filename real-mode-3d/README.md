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
```
dd if=boot.bin of=disk.img conv=notrunc
```

```bochsrc.bxrc``` states that we are going to boot from floppy drive A. 

```
megs: 32
floppya: 1_44=disk.img, status=inserted
boot: a
log: bochsout.txt
mouse: enabled=0
cpu: ips=15000000
clock: sync=both
```

Execute this file to run emulator.

## Environment

The program enters video mode 13h thru 10h BIOS interrupt (real mode). Starting from segment 40960d it uses ```es``` register with destination index (```di```) to put directly pixel bytes via ```al``` (acumulator low) register. Single pixel can be draw using ```PutPixelAt``` macro. There is also macro for line drawing called ```LineFromTo```. Line drawing utilizes Bresenham's algorithm. 


## Rendering
Will try to apply ortographic 3D projection similar to this one taken from C64/C development.

## Objectives

Create bootloader based program targeting x86 architecture computer.
