#!/bin/sh
case "$( uname -m )" in
    i?86) mkimage="grub-mkimage32" ;;
    x86_64) mkimage="grub-mkimage64" ;;
esac

find ./boot | cpio -o -H newc > ./memdisk.cpio

modules=$(cat mods.lst) 
echo $modules

echo "using $mkimage"
./grub-mkimage/$mkimage -m memdisk.cpio -d ./x86_64-efi -p "(memdisk)/boot/grub" -c config.cfg -o grubfmx64.efi -O x86_64-efi $modules
./grub-mkimage/$mkimage -m memdisk.cpio -d ./i386-efi -p "(memdisk)/boot/grub" -c config.cfg -o grubfmia32.efi -O i386-efi $modules
rm memdisk.cpio