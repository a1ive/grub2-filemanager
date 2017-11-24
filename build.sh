#!/usr/bin/env sh
echo -n "checking for gettext ... "
if [ -e "$(which msgfmt)" ]
then
	echo "ok"
else
	echo "not found\nPlease install gettext."
	exit
fi
echo -n "checking for mkisofs ... "
if [ -e "$(which mkisofs)" ]
then
	echo "ok"
	geniso=$(which mkisofs)
else
	echo -n "not found\nchecking for genisoimage ... "
	if [ -e "$(which genisoimage)" ]
	then
		echo "ok"
		geniso=$(which genisoimage)
	else
		echo "not found\nPlease install mkisofs or genisoimage."
		exit
	fi
fi
echo -n "checking for grub ... "
if [ -e "$(which grub-mkimage)" ]
then
	mkimage=grub-mkimage
	echo "ok"
else
	echo "not found"
	case "$( uname -m )" in
		i?86) mkimage="./bin/grub-mkimage32"
		;;
		x86_64) mkimage="./bin/grub-mkimage64"
		;;
	esac
fi

if [ -d "build" ]
then
	rm -r build
fi
mkdir build

echo "common files"
cp -r boot build/

echo "Language / 语言 / 語言"
echo "1. Simplified Chinese / 简体中文"
echo "2. Traditional Chinese / 正體中文"
echo "3. English (United States)"
read -p "Please make a choice: " choice
case "$choice" in
	2)
		echo "zh_TW"
		msgfmt grub/locale/zh_TW.po -o build/boot/grub/locale/zh_TW.mo
		msgfmt lang/zh_TW/fm.po -o build/boot/grub/locale/fm/zh_TW.mo
		cp lang/zh_TW/lang.sh build/boot/grub/
		cp lang/zh_TW/hex.txt build/boot/grub/themes/slack/
		cp lang/zh_TW/text.txt build/boot/grub/themes/slack/
		cp lang/zh_TW/theme.txt build/boot/grub/themes/slack/
		;;
	3)
		echo "en_US"
		;;
	*)
		echo "zh_CN"
		msgfmt grub/locale/zh_CN.po -o build/boot/grub/locale/zh_CN.mo
		msgfmt lang/zh_CN/fm.po -o build/boot/grub/locale/fm/zh_CN.mo
		cp lang/zh_CN/lang.sh build/boot/grub/
		cp lang/zh_CN/hex.txt build/boot/grub/themes/slack/
		cp lang/zh_CN/text.txt build/boot/grub/themes/slack/
		cp lang/zh_CN/theme.txt build/boot/grub/themes/slack/
		;;
esac

msgfmt grub/locale/zh_CN.po -o build/boot/grub/locale/zh_CN.mo

echo "efi common files"
cd build
find ./boot | cpio -o -H newc > ./memdisk.cpio
cd ..
modules=$(cat efi/builtin.lst) 

echo "x86_64-efi"
$mkimage -m ./build/memdisk.cpio -d ./grub/x86_64-efi -p "(memdisk)/boot/grub" -c efi/config.cfg -o grubfmx64.efi -O x86_64-efi $modules

echo "i386-efi"
$mkimage -m ./build/memdisk.cpio -d ./grub/i386-efi -p "(memdisk)/boot/grub" -c efi/config.cfg -o grubfmia32.efi -O i386-efi $modules
rm build/memdisk.cpio

echo "i386-pc"
builtin=$(cat legacy/builtin.lst) 
mkdir build/boot/grub/i386-pc
for modules in $(cat legacy/insmod.lst)
do
	echo "copying ${modules}.mod"
	cp grub/i386-pc/${modules}.mod build/boot/grub/i386-pc/
done
cp legacy/grub.exe build/boot/grub/
cp legacy/memdisk build/boot/grub/
cp legacy/ipxe.lkrn build/boot/grub/
cd build
find ./boot | cpio -o -H newc | gzip -9 > ./fm.loop
cd ..
rm -r build/boot
$mkimage -d ./grub/i386-pc -p "(memdisk)/boot/grub" -c ./legacy/config.cfg -o ./build/core.img -O i386-pc $builtin
cat grub/i386-pc/cdboot.img build/core.img > build/fmldr
rm build/core.img
cp legacy/MAP build/
if [ -e "legacy/ntboot/NTBOOT.MOD/NTBOOT.NT6" -o -e "legacy/ntboot/NTBOOT.MOD/NTBOOT.PE1" ]
then
	cp -r legacy/ntboot/* build/
	echo "WARNING: Non-GPL module(s) enabled!"
fi
if [ -e "legacy/wimboot" ]
then
	cp legacy/wimboot build/
fi
$geniso -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm.iso build
rm  -r build