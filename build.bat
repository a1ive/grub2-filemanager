rd /s /q build
md build

@echo i386-pc
cd /d %~dp0
xcopy /s /e /y /i boot build\boot
set /p builtin= < legacy\builtin.lst
md build\boot\grub\i386-pc
set /p modlist= < legacy\insmod.lst
:CPMOD
for /f "tokens=1,*" %%a in ("%modlist%") do (
	copy i386-pc\%%a.mod build\boot\grub\i386-pc\
	set modlist=%%b
	goto CPMOD
)
md build\boot\grub\tools
copy legacy\memdisk build\boot\grub\tools\
cd build
%~dp0\find ./boot | %~dp0\cpio -o -H newc > ./fm.loop
cd ..
rd /s /q build\boot
grub-mkimage\grub-mkimage.exe -d i386-pc -p (memdisk)/boot/grub -c legacy\legacy.cfg -o build\core.img -O i386-pc %builtin%
copy /B i386-pc\cdboot.img + build\core.img build\fmldr
del /q build\core.img
mkisofs -R -hide-joliet boot.catalog -b fmldr -no-emul-boot -allow-lowercase -boot-load-size 4 -boot-info-table -o grubfm.iso build
del build\fmldr
del build\fm.loop

@echo efi common files
find ./boot | cpio.exe -o -H newc > ./build/memdisk.cpio
set /p modules= < mods.lst

@echo i386-efi
grub-mkimage\grub-mkimage.exe -m build\memdisk.cpio -d i386-efi -p (memdisk)/boot/grub -c config32.cfg -o grubfmia32.efi -O i386-efi %modules%

@echo x86_64-efi
grub-mkimage\grub-mkimage.exe -m build\memdisk.cpio -d x86_64-efi -p (memdisk)/boot/grub -c config64.cfg -o grubfmx64.efi -O x86_64-efi %modules%
del build\memdisk.cpio