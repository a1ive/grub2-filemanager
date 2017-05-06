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
if [ -d "build" ]
then
	rm -r build
fi
mkdir build

echo "i386-pc"
builtin=$(cat legacy/builtin.lst) 
cp -r boot build/
mkdir build/boot/grub/i386-pc
for modules in $(cat legacy/insmod.lst)
do
	echo "copying ${modules}.mod"
	cp i386-pc/${modules}.mod build/boot/grub/i386-pc/
done
mkdir build/boot/grub/tools
cp legacy/memdisk build/boot/grub/tools/
cp legacy/grub.exe build/boot/grub/tools/
cd build
find ./boot | cpio -o -H newc > ./fm.loop
cd ..
rm -r build/boot
$mkimage -d ./i386-pc -p "(memdisk)/boot/grub" -c ./legacy/legacy.cfg -o ./build/core.img -O i386-pc $builtin
cat i386-pc/cdboot.img build/core.img > build/fmldr
rm build/core.img
geniso=$(which genisoimage)
if [ -e "$geniso" ]
then
	echo "found genisoimage : $geniso"
else
	geniso=$(which mkisofs)
fi
$geniso -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm.iso build

echo "efi common files"
find ./boot | cpio -o -H newc > ./build/memdisk.cpio
modules=$(cat mods.lst) 

echo "x86_64-efi"
$mkimage -m ./build/memdisk.cpio -d ./x86_64-efi -p "(memdisk)/boot/grub" -c config.cfg -o grubfmx64.efi -O x86_64-efi $modules

echo "i386-efi"
$mkimage -m ./build/memdisk.cpio -d ./i386-efi -p "(memdisk)/boot/grub" -c config.cfg -o grubfmia32.efi -O i386-efi $modules
rm build/*