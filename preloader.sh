#!/usr/bin/env sh
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
echo -n "checking for sbsigntool ... "
if [ -e "$(which sbsign)" ]
then
    echo "ok"
else
    echo "not found\nPlease install sbsigntool."
    exit
fi

if [ -d "build" ]
then
	rm -r build
fi
mkdir build

echo "x86_64-efi"
cd build
echo "sbpolicy -i" > config.cfg
echo "chainloader -b /efi/boot/grubfmx64.efi" >> config.cfg
cd ..
$mkimage -v -d ./grub/x86_64-efi -p "/efi/boot" -c build/config.cfg -o grubx64.efi -O x86_64-efi \
chain exfat fat iso9660 minicmd ntfs part_gpt part_msdos sbpolicy udf
sbsign --key test-cert.key --cert test-cert.crt grubx64.efi
mv grubx64.efi.signed grubx64.efi

echo "i386-efi"
cd build
echo "sbpolicy -i" > config.cfg
echo "chainloader -b /efi/boot/grubfmia32.efi" >> config.cfg
cd ..
$mkimage -v -d ./grub/i386-efi -p "/efi/boot" -c build/config.cfg -o grubia32.efi -O i386-efi \
chain exfat fat iso9660 minicmd ntfs part_gpt part_msdos sbpolicy udf
sbsign --key test-cert.key --cert test-cert.crt grubia32.efi
mv grubia32.efi.signed grubia32.efi

rm  -r build
