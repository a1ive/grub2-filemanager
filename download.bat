@echo off
bin\wget.exe -O legacy/ntboot/NTBOOT.MOD/NTBOOT.NT6 https://github.com/a1ive/NTBOOT/raw/master/NTBOOT.NT6
bin\wget.exe -O legacy/ntboot/NTBOOT.MOD/NTBOOT.PE1 https://github.com/a1ive/NTBOOT/raw/master/NTBOOT.PE1
bin\wget.exe -O legacy/wimboot https://github.com/a1ive/NTBOOT/raw/master/wimboot
bin\wget.exe -O bin/oscdimg.exe https://github.com/a1ive/NTBOOT/raw/master/oscdimg.exe

set tempfilename=g4dtemp.log
bin\wget.exe -O %tempfilename%  http://grub4dos.chenall.net >nul
for /f "tokens=2,3 delims=/" %%a in ('type "%tempfilename%" ^| findstr /i "<h1.*.7z" ^| find /n /v "" ^| find "[1]"') do (
        set "name=%%b"
        set "url=http://dl.grub4dos.chenall.net/%%b.7z"
)
bin\wget.exe -O grub4dos.7z %url% >nul
del %tempfilename%
bin\7z.exe e -olegacy -aoa grub4dos.7z grub4dos-0.4.6a/grldr grub4dos-0.4.6a/grub.exe grub4dos0.4.6a/grldr_cd.bin
del grub4dos.7z