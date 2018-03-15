@echo off
if exist build (
	rd /s /q build
	)
md build
copy legacy\grldr build\grldr
bin\grubmenu.exe import build\grldr legacy\menu.lst
bin\gzip.exe -9 grubfm.iso
move grubfm.iso.gz build\fmkern.gz
cd /d %~dp0
set intdir=%~dp0\build
set BIOS_BIN=%~dp0\legacy\grldr_cd.bin
set output=%~dp0\grubfm.iso
set CD_label=grubfm
bin\oscdimg.exe -d -h -m -o -n -l%CD_label% -bootdata:1#p00,e,b%BIOS_BIN% %intdir% %output%
echo Done !
