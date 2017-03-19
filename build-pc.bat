cd /d %~dp0
set /p builtin= < legacy\builtin.lst

rd /s /q build
md build
xcopy /s /e /y /i boot build\boot
md build\boot\grub\i386-pc
set /p modlist= < legacy\insmod.lst
:CPMOD
for /f "tokens=1,*" %%a in ("%modlist%") do (
	copy i386-pc\%%a.mod build\boot\grub\i386-pc\
	set modlist=%%b
	goto CPMOD
)

md build\boot\grub\tools
copy legacy\grub.exe build\boot\grub\tools\
copy legacy\memdisk build\boot\grub\tools\
copy legacy\wimboot build\boot\grub\tools\

cd build
%~dp0\find ./boot | %~dp0\cpio -o -H newc > ./fm.loop
cd ..
rd /s /q build\boot

grub-mkimage\grub-mkimage.exe -d i386-pc -p (memdisk)/boot/grub -c legacy\legacy.cfg -o build\core.img -O i386-pc %builtin%

copy /B i386-pc\cdboot.img + build\core.img build\fmldr
del /q build\core.img
mkisofs -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm.iso build