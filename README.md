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

```
#
# Bresenham's line algorithm
#   integer only
#   IBM 1962
#
def print_line_from_to(x0,y0, x1,y1)
  dx = x1 - x0
  dy = y1 - y0
  d = 2*dy - dx
  y = y0

  (x0..x1).each do |x|
    puts "#{x} x #{y}" 
    if d > 0
       y = y + 1
       d = d - 2*dx
    end
    d = d + 2*dy
  end
end

# Calculate x,y coordinates
print_line_from_to(0,0, 20,10)
```

## Rendering
Will try to apply ortographic 3D projection similar to this one taken from C64/C development:

```
/* *********************** */
/* ortographic_projection  */
/* *********************** */
void ortographic_projection(unsigned char * rx, unsigned char * ry, int ax,int ay,int az, int sx,int sz, int cx,int cz) {  
  int d = az/30;
  int d2 = az/20;
  int bx = (ax*1) + d;
  int by = (ay*1) + d2 - 150;
  
  sx,sz,cx,cz=0;
  
  *rx = bx;
  *ry = by;
} /* ortographic_projection */
```

## Objectives

Create bootloader based program targeting x86 architecture computer.
