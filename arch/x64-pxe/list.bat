@echo off

cd /d "%~dp0"
set TEST_OPT=1
del /q dir.txt

chcp 936
::utf8:chcp 65001

setlocal enabledelayedexpansion
:::::::::for /r %%i in (*.iso *.img *.vhd *.ima *.ipxe *.efi *.wim) do (

for /f %%i in ('dir /s /b /o:n *.iso *.img *.vhd *.ima *.ipxe *.efi *.gz *.wim *.lst^|Findstr /v "i386-pc Archive"') do (
set s=%%i
set s=!s:%~dp0=!
echo !s!) >>temp.txt
)


for /f "tokens=*" %%i in (temp.txt) do (
    if "%%i"=="" (echo.) else (set "line=%%i" & call :chg)
)>>dir.txt
del /q temp.txt
 
:chg
set "line=!line:\=/!"

echo !line!
goto :eof


exit