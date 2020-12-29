#!/usr/bin/env sh
echo -n "checking for gettext ... "
if [ -e "$(which msgfmt)" ]
then
    echo "ok"
else
    echo "not found\nPlease install gettext."
    exit
fi
echo -n "checking for xorriso ... "
if [ -e "$(which xorriso)" ]
then
    echo "ok"
else
    echo "not found\nPlease install xorriso."
    exit
fi
#echo -n "checking for grub ... "
#if [ -e "$(which grub-mkimage)" ]
#then
#    echo "ok"
#else
#    echo "not found\nPlease install grub."
#    exit
#fi
echo -n "checking for mtools ... "
if [ -e "$(which mtools)" ]
then
    echo "ok"
else
    echo "not found\nPlease install mtools."
    exit
fi

if [ -d "build" ]
then
    rm -r build
fi
mkdir build

echo "common files"
cp -r boot build/

cp grub/locale/*.mo build/boot/grubfm/locale/
cd lang
for po in */fm.po; do
  msgfmt ${po} -o ../build/boot/grubfm/locale/fm/${po%/*}.mo
done
cd ..

echo "Language"
echo "1. Simplified Chinese"
echo "2. Traditional Chinese"
echo "3. English (United States)"
echo "4. Turkish"
echo "5. German"
echo "6. Vietnamese"
echo "7. Russian"
echo "8. Hebrew"
echo "9. Spanish"
echo "10. Polish"
echo "11. Ukrainian"
echo "12. French"
echo "13. Danish"
echo "14. Portuguese (Brazil)"
echo "15. Arabic"
echo "16. Korean"
echo "17. Hungarian"
read -p "Please make a choice: " choice
case "$choice" in
    2)
        echo "zh_TW"
        cp lang/zh_TW/lang.sh build/boot/grubfm/
        ;;
    3)
        echo "en_US"
        ;;
    4)
        echo "tr_TR"
        cp lang/tr_TR/lang.sh build/boot/grubfm/
        ;;
    5)
        echo "de_DE"
        cp lang/de_DE/lang.sh build/boot/grubfm/
        ;;
    6)
        echo "vi_VN"
        cp lang/vi_VN/lang.sh build/boot/grubfm/
        ;;
    7)
        echo "ru_RU"
        cp lang/ru_RU/lang.sh build/boot/grubfm/
        ;;
    8)
        echo "he_IL"
        cp lang/he_IL/lang.sh build/boot/grubfm/
        ;;
    9)
        echo "es_ES"
        cp lang/es_ES/lang.sh build/boot/grubfm/
        ;;
    10)
        echo "pl_PL"
        cp lang/pl_PL/lang.sh build/boot/grubfm/
        ;;
    11)
        echo "uk_UA"
        cp lang/uk_UA/lang.sh build/boot/grubfm/
        ;;
    12)
        echo "fr_FR"
        cp lang/fr_FR/lang.sh build/boot/grubfm/
        ;;
    13)
        echo "da_DK"
        cp lang/da_DK/lang.sh build/boot/grubfm/
        ;;
    14)
        echo "pt_BR"
        cp lang/pt_BR/lang.sh build/boot/grubfm/
        ;;
    15)
        echo "ar_SA"
        cp lang/ar_SA/lang.sh build/boot/grubfm/
        ;;
    16)
        echo "ko_KR"
        cp lang/ko_KR/lang.sh build/boot/grubfm/
        ;;
    17)
        echo "hu_HU"
        cp lang/hu_HU/lang.sh build/boot/grubfm/
        ;;
    *)
        echo "zh_CN"
        cp lang/zh_CN/lang.sh build/boot/grubfm/
        ;;
esac

echo "x86_64-efi"
mkdir build/boot/grubfm/x86_64-efi
for modules in $(cat arch/x64/optional.lst)
do
    echo "copying ${modules}.mod"
    cp grub/x86_64-efi/${modules}.mod build/boot/grubfm/x86_64-efi/
done
# cp arch/x64/*.efi build/boot/grubfm
cp arch/x64/*.xz build/boot/grubfm
cd build
find ./boot | cpio -o -H newc | xz -9 -e > ./memdisk.xz
cd ..
rm -r build/boot/grubfm/x86_64-efi
# rm build/boot/grubfm/*.efi
rm build/boot/grubfm/*.xz
modules=$(cat arch/x64/builtin.lst)
./grub/grub-mkimage -m ./build/memdisk.xz -d ./grub/x86_64-efi -p "(memdisk)/boot/grubfm" -c arch/x64/config.cfg -o grubfmx64.efi -O x86_64-efi $modules
rm build/memdisk.xz

echo "i386-efi"
mkdir build/boot/grubfm/i386-efi
for modules in $(cat arch/ia32/optional.lst)
do
    echo "copying ${modules}.mod"
    cp grub/i386-efi/${modules}.mod build/boot/grubfm/i386-efi/
done
# cp arch/ia32/*.efi build/boot/grubfm
cp arch/ia32/*.xz build/boot/grubfm
cd build
find ./boot | cpio -o -H newc | xz -9 -e > ./memdisk.xz
cd ..
rm -r build/boot/grubfm/i386-efi
# rm build/boot/grubfm/*.efi
rm build/boot/grubfm/*.xz
modules=$(cat arch/ia32/builtin.lst)
./grub/grub-mkimage -m ./build/memdisk.xz -d ./grub/i386-efi -p "(memdisk)/boot/grubfm" -c arch/ia32/config.cfg -o grubfmia32.efi -O i386-efi $modules
rm build/memdisk.xz

echo "arm64-efi"
mkdir build/boot/grubfm/arm64-efi
for modules in $(cat arch/aa64/optional.lst)
do
    echo "copying ${modules}.mod"
    cp grub/arm64-efi/${modules}.mod build/boot/grubfm/arm64-efi/
done
# cp arch/aa64/*.efi build/boot/grubfm
cp arch/aa64/*.xz build/boot/grubfm
cd build
find ./boot | cpio -o -H newc | xz -9 -e > ./memdisk.xz
cd ..
rm -r build/boot/grubfm/arm64-efi
# rm build/boot/grubfm/*.efi
rm build/boot/grubfm/*.xz
modules=$(cat arch/aa64/builtin.lst)
./grub/grub-mkimage -m ./build/memdisk.xz -d ./grub/arm64-efi -p "(memdisk)/boot/grubfm" -c arch/aa64/config.cfg -o grubfmaa64.efi -O arm64-efi $modules
rm build/memdisk.xz

echo "i386-multiboot"
mkdir build/boot/grubfm/i386-multiboot
for modules in $(cat arch/multiboot/optional.lst)
do
    echo "copying ${modules}.mod"
    cp grub/i386-multiboot/${modules}.mod build/boot/grubfm/i386-multiboot/
done
cp arch/multiboot/*.xz build/boot/grubfm/
cp arch/multiboot/memdisk build/boot/grubfm/
cp arch/multiboot/grub.exe build/boot/grubfm/
cd build
find ./boot | cpio -o -H newc | xz -9 -e > ./memdisk.xz
cd ..
rm -r build/boot/grubfm/i386-multiboot
rm build/boot/grubfm/*.xz
rm build/boot/grubfm/memdisk
rm build/boot/grubfm/grub.exe
modules=$(cat arch/multiboot/builtin.lst)
./grub/grub-mkimage -m ./build/memdisk.xz -d ./grub/i386-multiboot -p "(memdisk)/boot/grubfm" -c arch/multiboot/config.cfg -o grubfm.elf -O i386-multiboot $modules
rm build/memdisk.xz

echo "i386-pc"
builtin=$(cat arch/legacy/builtin.lst)
mkdir build/boot/grubfm/i386-pc
modlist="$(cat arch/legacy/insmod.lst) $(cat arch/legacy/optional.lst)"
for modules in $modlist
do
    echo "copying ${modules}.mod"
    cp grub/i386-pc/${modules}.mod build/boot/grubfm/i386-pc/
done
cp arch/legacy/insmod.lst build/boot/grubfm/
cp arch/multiboot/*.xz build/boot/grubfm/
cp arch/multiboot/memdisk build/boot/grubfm/
cp arch/multiboot/grub.exe build/boot/grubfm/
cd build
find ./boot | cpio -o -H newc | xz -9 -e > ./fm.loop
cd ..
rm -r build/boot
./grub/grub-mkimage -d ./grub/i386-pc -p "(memdisk)/boot/grubfm" -c arch/legacy/config.cfg -o ./build/core.img -O i386-pc $builtin
cat grub/i386-pc/cdboot.img build/core.img > build/fmldr
rm build/core.img
touch build/ventoy.dat
xorriso -as mkisofs -l -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm_pc.iso build
rm build/fmldr
rm build/fm.loop

echo "i386-pc preloader"
builtin=$(cat arch/legacy/preloader.lst)
./grub/grub-mkimage -d ./grub/i386-pc -p "(cd)/boot/grub" -c arch/legacy/preloader.cfg -o ./build/core.img -O i386-pc $builtin
cat grub/i386-pc/cdboot.img build/core.img > build/fmldr
rm build/core.img
cp grubfm.elf build/
touch build/ventoy.dat
xorriso -as mkisofs -l -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm.iso build

dd if=/dev/zero of=build/efi.img bs=1M count=16
mkfs.vfat build/efi.img
mmd -i build/efi.img ::EFI
mmd -i build/efi.img ::EFI/BOOT
mcopy -i build/efi.img grubfmx64.efi ::EFI/BOOT/BOOTX64.EFI
mcopy -i build/efi.img grubfmia32.efi ::EFI/BOOT/BOOTIA32.EFI
xorriso -as mkisofs -l -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e efi.img -no-emul-boot -o grubfm_multiarch.iso build

rm -r build
