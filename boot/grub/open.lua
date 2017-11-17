#!lua
-- Grub2-FileManager
-- Copyright (C) 2017  A1ive.
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

function div1024 (file_size, unit)
	part_int = file_size / 1024
	part_f1 = 10 * ( file_size % 1024 ) / 1024
	part_f2 =  10 * ( file_size % 1024 ) % 1024
	part_f2 = 10 * ( part_f2 % 1024 ) / 1024
	str = part_int .. "." .. part_f1 .. part_f2 .. unit
	return part_int, str
end

function get_size (file)
	if (file == nil) then
		return 1
	else
		file_data = grub.file_open (file)
		file_size = grub.file_getsize (file_data)
		str = file_size .. "B"
		for i,unit in ipairs ({"KiB", "MiB", "GiB", "TiB"}) do
			if (file_size < 1024) or (unit == "TiB") then
				break;
			else
				file_size, str = div1024 (file_size, unit)
			end
		end
	end
	return (str)
end

function tog4dpath (file, device, device_type)
	if (device_type == "1") then
		devnum = string.match (device, "^hd%d+,%a*(%d+)$")
		devnum = devnum - 1
		g4d_file = "(" .. string.match (device, "^(hd%d+,)%a*%d+$") .. devnum .. ")" .. string.match (file, "^%([%w,]+%)(.*)$")
	elseif (device_type == "2") then
		g4d_file = file
	else
		print ("not on a real device")
		g4d_file = "(rd)+1"
	end
	print ("grub4dos file path : " .. g4d_file)
end

function open (file, file_type, device, device_type, arch, platform)
-- common
	icon = "go-previous"
	command = "action=genlst; path=" .. path .. "; hidden_menu=1; export action; export path; export hidden_menu; configfile $prefix/clean.sh"
	name = "Back"
	grub.add_icon_menu (icon, command, name)
-- 
	if file_type == "iso" then
		if device_type ~= "3" then
			grub.run ("loopback loop " .. file)
			icon = "iso"
			command = "action=genlst; path=(loop); export action; export path; configfile $prefix/clean.sh"
			name = "Mount ISO"
			grub.add_icon_menu (icon, command, name)
			if grub.file_exist ("(loop)/boot/grub/loopback.cfg") then
				icon = "iso"
				command = "set iso_path=" .. file .."; export iso_path; root=loop; set theme=${prefix}/themes/slack/extern.txt; configfile /boot/grub/loopback.cfg"
				name = "Boot ISO (Loopback)"
				grub.add_icon_menu (icon, command, name)
			end
		end
		if platform == "pc" then
			-- memdisk iso
			icon = "iso"
			command = "linux16 $prefix/memdisk iso raw; enable_progress_indicator=1; initrd16 " .. file
			name = "Boot ISO (memdisk)"
			grub.add_icon_menu (icon, command, name)
			-- grub4dos map iso
		--	icon = "iso"
		--	tog4dpath (file, device, device_type)
		--	command = "linux $prefix/grub.exe --config-file=(cd)/MAP nomem cd " .. g4d_file
		--	if g4d_file == "(rd)+1" then
		--		command = command .. "; enable_progress_indicator=1; initrd " .. file
		--	end
		--	name = "Boot ISO (GRUB4DOS)"
		--	grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "wim" then
		if platform == "pc" then
			-- wimboot
			icon = "wim"
			command = "enable_progress_indicator=1; loopback wimboot /wimboot; linux16 (wimboot)/wimboot gui; initrd16 newc:bootmgr:(wimboot)/bootmgr newc:bcd:(wimboot)/bcd newc:boot.sdi:(wimboot)/boot.sdi newc:boot.wim:" .. file
			name = "Boot NT6.x WIM (wimboot)"
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "fba" then
		if device_type ~= "3" then
			icon = "img"
			command = "loopback ud " .. file .. "; action=genlst; path=(ud); export action; export path; configfile $prefix/clean.sh"
			name = "Mount Image"
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "img" then
		if device_type ~= "3" then
			icon = "img"
			command = "loopback ud " .. file .. "; action=genlst; path=; export action; export path; configfile $prefix/clean.sh"
			name = "Mount Image"
			grub.add_icon_menu (icon, command, name)
		end
		if platform == "pc" then
			-- memdisk floppy
			icon = "img"
			command = "linux16 $prefix/memdisk floppy raw; enable_progress_indicator=1; initrd16 " .. file
			name = "Boot Floppy Image (memdisk)"
			grub.add_icon_menu (icon, command, name)
			-- memdisk harddisk
			icon = "img"
			command = "linux16 $prefix/memdisk harddisk raw; enable_progress_indicator=1; initrd16 " .. file
			name = "Boot Hard Drive Image (memdisk)"
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "ipxe" then
		if platform == "pc" then
			-- ipxe
			icon = "net"
			command = "linux16 $prefix/ipxe.lkrn; initrd16 " .. file
			name = "Open As iPXE Script"
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "efi" then
		if platform == "efi" then
			-- efi
			icon = "uefi"
			command = "chainloader " .. file
			name = "Open As EFI"
			grub.add_icon_menu (icon, command, name)
		end
	end


-- common
	file_size = get_size (file)
	icon = "info"
	command = "echo File Path : " .. file .. "; echo File Size : " .. file_size .. "; "
	command = command .. "enable_progress_indicator=1; echo CRC32 : ; crc32 " .. file .. "; enable_progress_indicator=0; "
	command = command .. "echo hexdump; hexdump " .. file .. "; echo -n Press [ESC] to continue...; getkey"
	name = grub.gettext ("File Info")
	grub.add_icon_menu (icon, command, name)
end

encoding = grub.getenv ("encoding")
if (encoding == nil) then
	encoding = "utf8"
end
path = grub.getenv ("path")
file = grub.getenv ("file")
file_type = grub.getenv ("file_type")
arch = grub.getenv ("grub_cpu")
platform = grub.getenv ("grub_platform")
device = string.match (file, "^%(([%w,]+)%)/.*$")
if string.match (device, "^hd[%d]+,[%w]+") ~= nil then
-- (hdx,y)
	device_type = "1"
elseif string.match (device, "^[hcf]d[%d]*") ~= nil then
-- (hdx) (cdx) (fdx) (cd)
	device_type = "2"
else
-- (loop) (memdisk) (tar) (proc) etc.
	device_type = "3"
end
open (file, file_type, device, device_type, arch, platform)