#!/usr/bin/env sh
if [ -e "grubfm*.7z" ]
then
    rm grubfm*.7z
fi
if [ -d "releases" ]
then
    rm -r releases
fi
mkdir releases
lang=zh_CN
#i=0
#for lang in zh_CN zh_TW en_US
#do
#    i=`expr $i + 1`
#    mkdir releases/${lang}
#    echo "${i}" | ./build.sh
echo "1" | ./build.sh
    if [ -e "test-cert.key" -a -e "test-cert.crt" ]
    then
        ./sign.sh
    fi
#    cp grubfm.iso releases/${lang}/
#    cp grubfm*.efi releases/${lang}/
#    cp loadfm releases/${lang}/
#done
cp grubfm.iso releases/
cp grubfm*.efi releases/
cp loadfm releases/
mkdir releases/secureboot
cp -r secureboot/*.efi releases/secureboot/
if [ -e "test-cert.cer" ]
then
    cp test-cert.cer releases/secureboot/
fi
cd releases
7z a ../grubfm-${lang}.7z *
cd ..
rm -r releases
