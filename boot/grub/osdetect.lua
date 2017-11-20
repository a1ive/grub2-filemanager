#!lua
-- Grub2-FileManager
-- Copyright (C) 2017  A1ive.
--
-- Copyright (C) 2009  Free Software Foundation, Inc.
--
-- Grub2-FileManager is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Grub2-FileManager is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Grub2-FileManager.  If not, see <http://www.gnu.org/licenses/>.

function get_ntver (windev)
	local file = nil
	sysver="Windows NT"
	local dlltable = {
		windev .. "/Windows/System32/Version.dll",
		windev .. "/Windows/System32/version.dll",
		windev .. "/Windows/system32/Version.dll",
		windev .. "/Windows/system32/version.dll",
		windev .. "/windows/System32/Version.dll",
		windev .. "/windows/System32/version.dll",
		windev .. "/windows/system32/Version.dll",
		windev .. "/windows/system32/version.dll"
	}
	for i=1,8 do
		dll = dlltable[i]
		if (grub.file_exist (dll)) then
			file = grub.file_open (dll)
			print ("DLL File : " .. dll)
			break
		end
	end
	if (file == nil) then
		if grub.file_exist (windev .. "ntldr") then
			sysver = "Windows NT Loader"
		else
			sysver = "Windows Boot Manager"
		end
		return sysver
	end
	offset = 0x1000
	length = 0x001c
	buf = ""
	while (buf ~= "P.r.o.d.u.c.t.V.e.r.s.i.o.n.")
	do
		offset = offset + 1
		buf = grub.hexdump (file, offset, length)

	end
	offset = offset + length + 2
	print ("OFFSET : " .. offset)
	buf = ""
	for i=0,6,2 do
		buf = buf .. grub.hexdump (file, offset + i, 1)
	end
	print ("RAW : " .. buf)
	if (buf == "5.0.") then
		sysver = "Windows 2000"
	elseif (buf == "5.1.") then
		sysver = "Windows XP"
	elseif (buf == "5.2.") then
		sysver = "Windows Server 2003"
	elseif (buf == "6.0.") then
		sysver = "Windows Server 2008"
	elseif (buf == "6.1.") then
		sysver = "Windows 7"
	elseif (buf == "6.2.") then
		sysver = "Windows 8"
	elseif (buf == "6.3.") then
		sysver = "Windows 8.1"
	elseif (buf == "10.0") then
		sysver = "Windows 10"
	else
		sysver = "Windows NT"
	end
	print ("Version : " .. sysver)
	return sysver
end

function enum_device (device, fs)
	if string.match (device, "^hd[%d]+,[%w]+") == nil then
		return 0
	end
	curdrv = "(" .. device .. ")"
	if arch == "efi" then
		efifile = "/efi/microsoft/boot/bootmgfw.efi"
		if grub.file_exist (curdrv .. efifile) then
			icon = "wim"
			command = "root=" .. device .. "; chainloader " .. efifile
			grub.setenv ("device", device)
			name = grub.gettext ("Boot Windows on ${device}")
			grub.add_icon_menu (icon, command ,name)
		end
		if platform == "x86_64" then
			efifile = "/efi/boot/bootx64.efi"
		else
			efifile = "/efi/boot/bootia32.efi"
		end
		if grub.file_exist (curdrv .. efifile) then
			icon = "uefi"
			command = "root=" .. device .. "; chainloader " .. efifile
			name = grub.gettext ("Chainload " .. device)
			grub.add_icon_menu (icon, command ,name)
		end
		efifile = "/System/Library/CoreServices/boot.efi"
		if grub.file_exist (curdrv .. efifile) then
			icon = "macOS"
			command = "root=" .. device .. "; chainloader " .. efifile
			grub.setenv ("device", device)
			name = grub.gettext ("Boot macOS on ${device}")
			grub.add_icon_menu (icon, command ,name)
		end
	elseif grub.file_exist (curdrv .. "/bootmgr") then
		sysver = get_ntver (curdrv)
		icon = "nt6"
		command = "root=" .. device .. "; drivemap -s (hd0) " .. curdrv .. "; " .. 
		 "ntldr /bootmgr"
		name = grub.gettext ("Boot " .. sysver .. " on " .. device)
		grub.add_icon_menu (icon, command, name)
	elseif grub.file_exist (curdrv .. "/ntldr") then
		sysver = get_ntver (curdrv)
		icon = "nt5"
		command = "root=" .. device .. "; drivemap -s (hd0) " .. curdrv .. "; " .. 
		 "ntldr /ntldr"
		name = grub.gettext ("Boot " .. sysver .. " on " .. device)
		grub.add_icon_menu (icon, command, name)
	else
		grub.run ("probe --set=bootable -b " .. device)
		if grub.getenv ("bootable") == "bootable" then
			icon = "img"
			command = "root=" .. device .. "; drivemap -s (hd0) " .. curdrv .. "; " .. 
			 "chainloader --force --bpb +1"
			name = grub.gettext ("Chainload " .. device)
			grub.add_icon_menu (icon, command, name)
		end
	end
end

arch = grub.getenv ("grub_cpu")
platform = grub.getenv ("grub_platform")
grub.enum_device (enum_device)

icon = "go-previous"
command = "configfile $prefix/clean.sh"
name = grub.gettext ("Back")
grub.add_icon_menu (icon, command, name)
