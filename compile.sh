./clean.sh

mkdir build
mkdir -p build/boot
mkdir -p build/cpu
mkdir -p build/driver
mkdir -p build/kernel

nasm -i boot -f bin boot/boot.asm -o build/boot/boot.bin
nasm -i boot -f bin boot/padding.asm -o build/boot/padding.bin
nasm -i boot -f elf64 boot/kernel_entry.asm -o build/boot/kernel_entry.o
# nasm -i boot -f elf64 cpu/interrupt.asm -o build/cpu/interrupt.o

# x86_64-elf-gcc -ffreestanding -c cpu/idt.c -o build/cpu/idt.o
# x86_64-elf-gcc -ffreestanding -c cpu/isr.c -o build/cpu/isr.o
# x86_64-elf-gcc -ffreestanding -c cpu/timer.c -o build/cpu/timer.o
# x86_64-elf-gcc -ffreestanding -c driver/keyboard.c -o build/driver/keyboard.o
x86_64-elf-gcc -ffreestanding -c driver/port.c -o build/driver/port.o
x86_64-elf-gcc -ffreestanding -c driver/screen.c -o build/driver/screen.o
x86_64-elf-gcc -ffreestanding -c kernel/kernel.c -o build/kernel/kernel.o
x86_64-elf-gcc -ffreestanding -c kernel/util.c -o build/kernel/util.o

x86_64-elf-ld -o build/kernel/kernel.bin -Ttext 0x10000 --oformat binary \
	build/boot/kernel_entry.o \
	build/driver/port.o \
	build/driver/screen.o \
	build/kernel/kernel.o \
	build/kernel/util.o
# 	build/cpu/interrupt.o \
# 	build/cpu/idt.o \
# 	build/cpu/isr.o \
# 	build/cpu/timer.o \
# 	build/driver/keyboard.o \

cat build/boot/boot.bin >> build/os-image.bin
cat build/kernel/kernel.bin >> build/os-image.bin
cat build/boot/padding.bin >> build/os-image.bin
