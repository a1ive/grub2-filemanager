#!/usr/bin/env sh
mkimage=$(which grub-mkimage)
if [ -e "$mkimage" ]
then
	echo "found grub-mkimage : $mkimage"
else
	case "$( uname -m )" in
	    i?86) mkimage="./grub-mkimage/grub-mkimage32" ;;
	    x86_64) mkimage="./grub-mkimage/grub-mkimage64" ;;
	esac
fi

find ./boot | cpio -o -H newc > ./memdisk.cpio

modules=$(cat mods.lst) 
echo $modules

$mkimage -m memdisk.cpio -d ./x86_64-efi -p "(memdisk)/boot/grub" -c config.cfg -o grubfmx64.efi -O x86_64-efi $modules
$mkimage -m memdisk.cpio -d ./i386-efi -p "(memdisk)/boot/grub" -c config.cfg -o grubfmia32.efi -O i386-efi $modules
rm memdisk.cpio