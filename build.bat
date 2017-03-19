find ./boot | cpio.exe -o -H newc > ./memdisk.cpio

set /p modules= < mods.lst
echo %modules%

echo build x86_64-efi
grub-mkimage\grub-mkimage.exe -m memdisk.cpio -d x86_64-efi -p (memdisk)/boot/grub -c config.cfg -o grubfmx64.efi -O x86_64-efi %modules%
echo build i386-efi
grub-mkimage\grub-mkimage.exe -m memdisk.cpio -d i386-efi -p (memdisk)/boot/grub -c config.cfg -o grubfmia32.efi -O i386-efi %modules%
del memdisk.cpio