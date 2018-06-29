#!/bin/sh
set +e

nasm -o bootsector.bin -f bin bootsector.asm
nasm -o main.bin -f bin main.asm	
wine merge.exe bootsector.bin main.bin mas.img
cp mas.img /usr/share/bochs/mas/
cd /usr/share/bochs/mas/
bochs -f bochsrc.txt
