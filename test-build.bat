@echo off
if exist build (
	rd /s /q build
	)
md build
copy arch\legacy\grldr build\grldr
bin\grubmenu.exe import build\grldr arch\legacy\menu.lst
bin\gzip.exe -9 grubfm.iso
move grubfm.iso.gz build\fmkern.gz
cd /d %~dp0
set intdir=%~dp0\build
set BIOS_BIN=%~dp0\arch\legacy\grldr_cd.bin
rem set EFI_BIN=%~dp0\efiboot.img
set output=%~dp0\grubfm.iso
rem set output_efi=%~dp0\grubfm_all.iso
set CD_label=grubfm
bin\oscdimg.exe -d -h -m -o -n -l%CD_label% -bootdata:1#p00,e,b%BIOS_BIN% %intdir% %output%
rem bin\mformat.exe -C -h 4 -t 90 -s 36 -i efiboot.img
rem bin\mmd.exe -i efiboot.img efi
rem bin\mmd.exe -i efiboot.img efi/boot
rem bin\mcopy.exe -i efiboot.img grubfmx64.efi ::efi/boot
rem bin\mcopy.exe -i efiboot.img grubfmia32.efi ::efi/boot
rem bin\mren.exe -i efiboot.img efi/boot/grubfmx64.efi efi/boot/bootx64.efi
rem bin\mren.exe -i efiboot.img efi/boot/grubfmia32.efi efi/boot/bootia32.efi
rem bin\oscdimg.exe -d -h -m -o -n -l%CD_label% -bootdata:2#p00,e,b%BIOS_BIN%#pEF,e,b%EFI_BIN% %intdir% %output_efi%
rd /s /q build
rem del efiboot.img
echo Done !
