#!/usr/bin/env sh
git clone https://github.com/a1ive/grub2-mod.git --depth 1 -b x2
cd grub2-mod
./autogen.sh
./configure --prefix=$(pwd)/build --target=x86_64 --with-platform=efi && make install && make clean
./configure --prefix=$(pwd)/build --target=i386 --with-platform=efi && make install && make clean
./configure --prefix=$(pwd)/build --target=i386 --with-platform=pc --with-efiemu && make install && make clean
rm -r build/lib/grub/*/*.module
rm -r build/lib/grub/*/*.exec
rm -r build/lib/grub/*/*.image
rm -r build/lib/grub/*/config.h
cd ..
rm -r ../i386-pc
rm -r ../i386-efi
rm -r ../x86_64-efi
cp -r grub2-mod/build/lib/grub/* ../
rm -r grub2-mod