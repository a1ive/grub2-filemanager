@echo off
if exist build (
	rd /s /q build
	)
md build

echo common files
cd /d %~dp0
xcopy /s /e /y /i boot build\boot
cls
echo Language
echo 1. Simplified Chinese
echo 2. Traditional Chinese
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
goto build
:tw
echo zh_TW
bin\msgfmt.exe grub\locale\zh_TW.po -o build\boot\grub\locale\zh_TW.mo
bin\msgfmt.exe lang\zh_TW\fm.po -o build\boot\grub\locale\fm\zh_TW.mo
copy lang\zh_TW\lang.sh build\boot\grub\
goto build
:en
echo en_US
goto build

:build
echo i386-efi
copy arch\ia32\CrScreenshotDxe.efi build\boot\grub
copy arch\x64\Shell.efi build\boot\grub
cd build
%~dp0\bin\find.exe ./boot | %~dp0\bin\cpio.exe -o -H newc > ./memdisk.cpio
cd ..
del build\boot\grub\*.efi
set /p modules= < arch\ia32\builtin.lst
bin\grub-mkimage.exe -m build\memdisk.cpio -d grub\i386-efi -p (memdisk)/boot/grub -c arch\ia32\config.cfg -o grubfmia32.efi -O i386-efi %modules%

echo x86_64-efi
copy arch\x64\CrScreenshotDxe.efi build\boot\grub
copy arch\x64\Shell.efi build\boot\grub
cd build
%~dp0\bin\find.exe ./boot | %~dp0\bin\cpio.exe -o -H newc > ./memdisk.cpio
cd ..
del build\boot\grub\*.efi
set /p modules= < arch\x64\builtin.lst
bin\grub-mkimage.exe -m build\memdisk.cpio -d grub\x86_64-efi -p (memdisk)/boot/grub -c arch\x64\config.cfg -o grubfmx64.efi -O x86_64-efi %modules%
del build\memdisk.cpio

echo i386-pc
set /p builtin= < arch\legacy\builtin.lst
md build\boot\grub\i386-pc
set /p modlist= < arch\legacy\insmod.lst
:CPMOD
for /f "tokens=1,*" %%a in ("%modlist%") do (
	copy grub\i386-pc\%%a.mod build\boot\grub\i386-pc\
	set modlist=%%b
	goto CPMOD
)
copy arch\legacy\insmod.lst build\boot\grub\
copy arch\legacy\grub.exe build\boot\grub\
copy arch\legacy\duet64.iso build\boot\grub\
copy arch\legacy\memdisk build\boot\grub\
copy arch\legacy\ipxe.lkrn build\boot\grub\
cd build
%~dp0\bin\find.exe ./boot | %~dp0\bin\cpio.exe -o -H newc | %~dp0\bin\gzip.exe -9 > ./fm.loop
cd ..
rd /s /q build\boot
bin\grub-mkimage.exe -d grub\i386-pc -m arch\legacy\null.cpio -p (fm)/boot/grub -c arch\legacy\config.cfg -o build\core.img -O i386-pc %builtin%
copy /B grub\i386-pc\cdboot.img + build\core.img build\fmldr
del /q build\core.img
copy arch\legacy\MAP build\
if exist arch\legacy\ntboot\NTBOOT.MOD\NTBOOT.NT6 (
	goto NTBOOT
	)
if exist arch\legacy\ntboot\NTBOOT.MOD\NTBOOT.PE1 (
	goto NTBOOT
	)
goto NONTBOOT
:NTBOOT 
xcopy /I /E arch\legacy\ntboot build\
:NONTBOOT
if exist arch\legacy\wimboot (
	copy arch\legacy\wimboot build\
	)
if exist arch\legacy\vbootldr (
	copy arch\legacy\vbootldr build\
	)
bin\mkisofs.exe -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm.iso build
rd /s /q build
