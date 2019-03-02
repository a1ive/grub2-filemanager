#!/usr/bin/env sh
if [ -e "grubfm*.7z" ]
then
    rm grubfm*.7z
fi

i=0
for lang in zh_CN zh_TW en_US tr_TR
do
    if [ -d "releases" ]
    then
        rm -r releases
    fi
    mkdir releases
    i=`expr $i + 1`
    echo "${i}" | ./build.sh
    if [ -e "test-cert.key" -a -e "test-cert.crt" ]
    then
        ./sign.sh
    fi
    cp grubfm.iso releases/
    cp grubfm*.efi releases/
    cp loadfm releases/
    mkdir releases/secureboot
    cp -r secureboot/*.efi releases/secureboot/
    cp -r secureboot/*.cer releases/secureboot/
    cd releases
    7z a ../grubfm-${lang}.7z *
    cd ..
    rm -r releases
done
