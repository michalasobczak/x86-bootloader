nasm main.asm -f bin -o boot.bin
dd if=boot.bin of=disk.img conv=notrunc