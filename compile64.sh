./clean.sh

mkdir build
mkdir -p build/boot

nasm -i boot -f bin boot/boot.asm -o build/boot/boot.bin
nasm -i boot -f bin boot/padding.asm -o build/boot/padding.bin

cat build/boot/boot.bin >> build/os-image.bin
cat build/boot/padding.bin >> build/os-image.bin
