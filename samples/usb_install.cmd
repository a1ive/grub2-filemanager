:: install script for grub2-filemanager
:: Copyright (C) 2020  mephistooo2.
::
:: This program is free software: you can redistribute it and/or modify
:: it under the terms of the GNU General Public License as published by
:: the Free Software Foundation, either version 3 of the License, or
:: (at your option) any later version.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License
:: along with This program.  If not, see <http://www.gnu.org/licenses/>.
@echo off
mode con:cols=72 lines=30
pushd "%~dp0"
if not "%~1"=="5" reg query HKEY_USERS\S-1-5-20 >nul 2>&1 || (
	echo ADMINISTRATIVE RIGHTS ARE ACTIVATED....
	echo Set UAC = CreateObject^("Shell.Application"^) >> "%temp%\admin.vbs" 
	echo UAC.ShellExecute "%~fs0", "%~1", "", "runas", 1 >> "%temp%\admin.vbs"
	"%temp%\admin.vbs"
	del /f /q "%temp%\admin.vbs"
	exit /b
)
setlocal enableextensions disabledelayedexpansion
title Grub2 File Manager USB Install - mephistooo2 ^| TNCTR.com
:ask
	call :showDiskTable
	set /p "   diskNumber=Type the disk number to install Grub2 File Manager: "

	(   echo select disk %diskNumber%
		echo list disk
	) | diskpart | findstr /b /c:"*" >nul || (
		echo(	
		echo WRONG CHOICE
		timeout /t 2 > nul
		echo(
		cls
		goto :ask
	)
	
		call :MsgBox "Make sure to select the right disk to install Grub2 File Manager.  Do you want to continue?"  "VBYesNo+VBQuestion" "WARNING"
	if errorlevel 7 (
		exit
	) else if errorlevel 6 (
		call :format
	)

	exit /b

:MsgBox prompt type title
	setlocal enableextensions
	set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
	>"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
	set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
	endlocal & exit /b %exitCode%	
:format
	set "scriptFile=%temp%\%~nx0.%random%%random%%random%.tmp"
	> "%scriptFile%" (
		echo SELECT DISK %diskNumber%
		echo CLEAN
		echo CREATE PARTITION PRIMARY SIZE=40
		echo FORMAT QUICK FS=FAT32 LABEL="EFI_BOOT"
		echo ACTIVE
		echo ASSIGN LETTER="V"
		echo.
		echo CREATE PARTITION PRIMARY
		echo FORMAT QUICK FS=NTFS LABEL="USB"
		echo ASSIGN LETTER="W"
	)

	type "%scriptFile%" > nul
	echo.
	echo	 Formatting the disc...
	diskpart /s "%scriptFile%" > nul
	del /q "%scriptFile%" > nul
	echo(
	echo	 Copying Grub2 File Manager files...
	xcopy /s /h USB V:\ > nul
	echo.
	echo	 Installing MBR...
	bootsect /nt60 V: /force /mbr > nul
	echo.
	echo	 OK
	echo.
	echo	 Press any key for exit...
	Pause >nul 2>&1
	exit
	echo(

:showDiskTable
	echo.
	echo	 Secure Boot Grub2 File Manager USB Install
	echo.
	echo	 WARNING : MAKE SURE YOU CHOOSE THE RIGHT DISK !!!
	echo.
	echo ======================================================
	echo list disk | diskpart | findstr /b /c:" "
	echo ======================================================
	echo(
	goto :eof
