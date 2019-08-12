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
echo "4. Turkish"
echo "5. German"
echo "6. Vietnamese"
read -p "Please make a choice: " choice
case "$choice" in
    2)
        echo "zh_TW"
        msgfmt grub/locale/zh_TW.po -o build/boot/grub/locale/zh_TW.mo
        msgfmt lang/zh_TW/fm.po -o build/boot/grub/locale/fm/zh_TW.mo
        cp lang/zh_TW/lang.sh build/boot/grub/
        ;;
    3)
        echo "en_US"
        ;;
    4)
        echo "tr_TR"
        msgfmt grub/locale/tr_TR.po -o build/boot/grub/locale/tr_TR.mo
        msgfmt lang/tr_TR/fm.po -o build/boot/grub/locale/fm/tr_TR.mo
        cp lang/tr_TR/lang.sh build/boot/grub/
        ;;
    5)
        echo "de_DE"
        msgfmt grub/locale/de_DE.po -o build/boot/grub/locale/de_DE.mo
        msgfmt lang/de_DE/fm.po -o build/boot/grub/locale/fm/de_DE.mo
        cp lang/de_DE/lang.sh build/boot/grub/
        ;;
    6)
        echo "vi_VN"
        msgfmt grub/locale/vi_VN.po -o build/boot/grub/locale/vi_VN.mo
        msgfmt lang/de_DE/fm.po -o build/boot/grub/locale/fm/vi_VN.mo
        cp lang/vi_VN/lang.sh build/boot/grub/
        ;;
    *)
        echo "zh_CN"
        msgfmt grub/locale/zh_CN.po -o build/boot/grub/locale/zh_CN.mo
        msgfmt lang/zh_CN/fm.po -o build/boot/grub/locale/fm/zh_CN.mo
        cp lang/zh_CN/lang.sh build/boot/grub/
        ;;
esac

echo "x86_64-efi"
mkdir build/boot/grub/x86_64-efi
for modules in $(cat arch/x64/optional.lst)
do
    echo "copying ${modules}.mod"
    cp grub/x86_64-efi/${modules}.mod build/boot/grub/x86_64-efi/
done
cp arch/x64/*.efi build/boot/grub
cp arch/x64/*.gz build/boot/grub
cd build
find ./boot | cpio -o -H newc > ./memdisk.cpio
cd ..
rm -r build/boot/grub/x86_64-efi
rm build/boot/grub/*.efi
rm build/boot/grub/*.gz
modules=$(cat arch/x64/builtin.lst)
$mkimage -m ./build/memdisk.cpio -d ./grub/x86_64-efi -p "(memdisk)/boot/grub" -c arch/x64/config.cfg -o grubfmx64.efi -O x86_64-efi $modules

echo "i386-efi"
mkdir build/boot/grub/i386-efi
for modules in $(cat arch/ia32/optional.lst)
do
    echo "copying ${modules}.mod"
    cp grub/i386-efi/${modules}.mod build/boot/grub/i386-efi/
done
cp arch/ia32/*.efi build/boot/grub
cp arch/ia32/*.gz build/boot/grub
cd build
find ./boot | cpio -o -H newc > ./memdisk.cpio
cd ..
rm -r build/boot/grub/i386-efi
rm build/boot/grub/*.efi
rm build/boot/grub/*.gz
modules=$(cat arch/ia32/builtin.lst)
$mkimage -m ./build/memdisk.cpio -d ./grub/i386-efi -p "(memdisk)/boot/grub" -c arch/ia32/config.cfg -o grubfmia32.efi -O i386-efi $modules
rm build/memdisk.cpio

echo "i386-pc"
builtin=$(cat arch/legacy/builtin.lst) 
mkdir build/boot/grub/i386-pc
modlist="$(cat arch/legacy/insmod.lst) $(cat arch/legacy/optional.lst)"
for modules in $modlist
do
    echo "copying ${modules}.mod"
    cp grub/i386-pc/${modules}.mod build/boot/grub/i386-pc/
done
cp arch/legacy/insmod.lst build/boot/grub/
cp arch/legacy/grub.exe build/boot/grub/
cp arch/legacy/duet64.iso build/boot/grub/
cp arch/legacy/memdisk build/boot/grub/
cp arch/legacy/ipxe.lkrn build/boot/grub/
cd build
find ./boot | cpio -o -H newc | gzip -9 > ./fm.loop
cd ..
rm -r build/boot
$mkimage -d ./grub/i386-pc -m arch/legacy/null.cpio -p "(fm)/boot/grub" -c arch/legacy/config.cfg -o ./build/core.img -O i386-pc $builtin
cat grub/i386-pc/cdboot.img build/core.img > build/fmldr
rm build/core.img
cp arch/legacy/MAP build/
if [ -e "legacy/ntboot/NTBOOT.MOD/NTBOOT.NT6" -o -e "legacy/ntboot/NTBOOT.MOD/NTBOOT.PE1" ]
then
    cp -r arch/legacy/ntboot/* build/
fi
if [ -e "legacy/wimboot" ]
then
    cp arch/legacy/wimboot build/
fi
if [ -e "legacy/vbootldr" ]
then
    cp arch/legacy/vbootldr build/
fi
if [ -e "legacy/install.gz" ]
then
    cp arch/legacy/install.gz build/
fi
$geniso -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm.iso build
rm -r build
