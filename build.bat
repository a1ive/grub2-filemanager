@echo off
if exist build (
	rd /s /q build
	)
md build

echo common files
cd /d %~dp0
xcopy /s /e /y /i boot build\boot

chcp 65001 > nul && echo Language / 语言 / 語言 && echo 1. Simplified Chinese / 简体中文 && echo 2. Traditional Chinese / 正體中文
echo 3. English (United States)
echo Please make a choice: 
set /p id=
if "%id%" == "1" goto cn
if "%id%" == "2" goto tw
if "%id%" == "3" goto en
:cn
echo zh_CN
bin\msgfmt.exe grub\locale\zh_CN.po -o build\boot\grub\locale\zh_CN.mo
bin\msgfmt.exe lang\zh_CN\fm.po -o build\boot\grub\locale\fm\zh_CN.mo
copy lang\zh_CN\lang.sh build\boot\grub\
copy lang\zh_CN\hex.txt build\boot\grub\themes\slack\
copy lang\zh_CN\text.txt build\boot\grub\themes\slack\
copy lang\zh_CN\theme.txt build\boot\grub\themes\slack\
goto build
:tw
echo zh_TW
bin\msgfmt.exe grub\locale\zh_TW.po -o build\boot\grub\locale\zh_TW.mo
bin\msgfmt.exe lang\zh_TW\fm.po -o build\boot\grub\locale\fm\zh_TW.mo
copy lang\zh_TW\lang.sh build\boot\grub\
copy lang\zh_TW\hex.txt build\boot\grub\themes\slack\
copy lang\zh_TW\text.txt build\boot\grub\themes\slack\
copy lang\zh_TW\theme.txt build\boot\grub\themes\slack\
goto build
:en
echo en_US
goto build

:build
echo efi common files
cd build
%~dp0\bin\find.exe ./boot | %~dp0\bin\cpio.exe -o -H newc > ./memdisk.cpio
cd ..
set /p modules= < efi\builtin.lst

echo i386-efi
bin\grub-mkimage.exe -m build\memdisk.cpio -d grub\i386-efi -p (memdisk)/boot/grub -c efi\config.cfg -o grubfmia32.efi -O i386-efi %modules%

echo x86_64-efi
bin\grub-mkimage.exe -m build\memdisk.cpio -d grub\x86_64-efi -p (memdisk)/boot/grub -c efi\config.cfg -o grubfmx64.efi -O x86_64-efi %modules%
del build\memdisk.cpio

echo i386-pc
set /p builtin= < legacy\builtin.lst
md build\boot\grub\i386-pc
set /p modlist= < legacy\insmod.lst
:CPMOD
for /f "tokens=1,*" %%a in ("%modlist%") do (
	copy grub\i386-pc\%%a.mod build\boot\grub\i386-pc\
	set modlist=%%b
	goto CPMOD
)
copy legacy\insmod.lst build\boot\grub\
copy legacy\grub.exe build\boot\grub\
copy legacy\memdisk build\boot\grub\
copy legacy\ipxe.lkrn build\boot\grub\
cd build
%~dp0\bin\find.exe ./boot | %~dp0\bin\cpio.exe -o -H newc | %~dp0\bin\gzip.exe -9 > ./fm.loop
cd ..
rd /s /q build\boot
bin\grub-mkimage.exe -d grub\i386-pc -p (memdisk)/boot/grub -c legacy\config.cfg -o build\core.img -O i386-pc %builtin%
copy /B grub\i386-pc\cdboot.img + build\core.img build\fmldr
del /q build\core.img
copy legacy\MAP build\
if exist legacy\ntboot\NTBOOT.MOD\NTBOOT.NT6 (
	goto NTBOOT
	)
if exist legacy\ntboot\NTBOOT.MOD\NTBOOT.PE1 (
	goto NTBOOT
	)
goto NONTBOOT
:NTBOOT 
xcopy /I /E legacy\ntboot build\
echo WARNING: Non-GPL module^(s^) enabled!
:NONTBOOT
if exist legacy\wimboot (
	copy legacy\wimboot build\
	)
bin\mkisofs.exe -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm.iso build
rd /s /q build
