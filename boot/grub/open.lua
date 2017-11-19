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

function isoboot (iso_path, iso_label, iso_uuid, dev_uuid)
	print ("ISO " .. iso_path)
	if iso_label == nil then
		iso_label = ""
	end
	print ("ISO LABEL " .. iso_label)
	if iso_uuid == nil then
		iso_uuid = ""
	end
	print ("ISO UUID " .. iso_uuid)
	if dev_uuid == nil then
		dev_uuid = ""
	end
	print ("DEVICE UUID " .. dev_uuid)
	if grub.file_exist ("(loop)/boot/grub/loopback.cfg") then
		icon = "gnu-linux"
		command = "root=loop; iso_path=" .. iso_path .. "; export iso_path; set theme=${prefix}/themes/slack/extern.txt; export theme; configfile /boot/grub/loopback.cfg"
		name = grub.gettext ("Boot ISO (Loopback)")
		grub.add_icon_menu (icon, command, name)
	end
	loop_path = "/"
	d_table = {loop_path}
	f_table = {}
	i = 0
	function enum_loop_file_iter (d_table)
		j = 0
		d_table_iter = {}
		for k, loop_path in ipairs(d_table) do
			function enum_loop_file (name)
				item = loop_path .. name
				if grub.file_exist ("(loop)" .. item) then
					i = i + 1
					f_table[i] = item
				elseif (name ~= "." and name ~= "..") then
					j = j + 1
					d_table_iter[j] = item .. "/"
				end
			end
			grub.enum_file (enum_loop_file, "(loop)" .. loop_path)
		end
		d_table = d_table_iter
		if (#d_table == 0) then
			return 0
		else
			enum_loop_file_iter (d_table)
		end
	end
	enum_loop_file_iter (d_table)
	function check_distro (f_table)
		for i, loop_file in ipairs(f_table) do
			loop_file = string.lower (loop_file)
			print ("Checking " .. loop_file)
			if string.match (loop_file, "^/arch/") then
				return "arch"
			elseif string.match (loop_file, "^/casper/") then
				return "ubuntu"
			elseif string.match (loop_file, "^/liveos/") then
				return "fedora"
			elseif string.match (loop_file, "^/parabola/") then
				return "parabola"
			elseif string.match (loop_file, "^/blackarch/") then
				return "blackarch"
			elseif string.match (loop_file, "^/kdeos/") then
				return "kaos"
			elseif string.match (loop_file, "^/sysrcd%.dat") then
				return "sysrcd"
			elseif string.match (loop_file, "^/dat[%d]+%.dat") then
				return "acronis"
			elseif string.match (loop_file, "^/livecd%.sqfs") then
				return "pclinuxos"
			elseif string.match (loop_file, "^/system%.sfs") then
				return "android"
			elseif string.match (loop_file, "^/netbsd") then
				return "netbsd"
			elseif string.match (loop_file, "^/porteus/") then
				return "porteus"
			elseif string.match (loop_file, "^/slax/") then
				return "slax"
			elseif string.match (loop_file, "^/wifislax/") then
				return "wifislax"
			elseif string.match (loop_file, "^/wifislax64/") then
				return "wifislax64"
			elseif string.match (loop_file, "^/wifiway/") then
				return "wifiway"
			elseif string.match (loop_file, "^/manjaro/") then
				return "manjaro"
			elseif string.match (loop_file, "^/pmagic/") then
				return "pmagic"
			elseif string.match (loop_file, "^/antix/") then
				return "antix"
			elseif string.match (loop_file, "^/cdlinux/") then
				return "cdlinux"
			elseif string.match (loop_file, "^/isolinux/gentoo") then
				return "gentoo"
			elseif string.match (loop_file, "^/isolinux/pentoo") then
				return "pentoo"
			elseif string.match (loop_file, "^/live/vmlinuz") then
				return "debian"
			elseif string.match (loop_file, "^/boot/sabayon") then
				return "sabayon"
			elseif string.match (loop_file, "^/boot/core.gz") then
				return "tinycore"
			elseif string.match (loop_file, "^/kernels/huge%.s/bzimage") then
				return "slackware"
			elseif string.match (loop_file, "^/boot/isolinux/minirt%.gz") then
				return "knoppix"
			elseif string.match (loop_file, "^/boot/kernel/kfreebsd%.gz") then
				return "debianbsd"
			elseif string.match (loop_file, "^/boot/kernel/kernel") then
				return "freebsd"
			elseif string.match (loop_file, "^/[%w%.]+/[%w]+/bsd.rd") then
				return "openbsd"
			elseif string.match (loop_file, "^/boot/x86_64/loader/linux") then
				return "suse64"
			elseif string.match (loop_file, "^/platform/i86pc/kernel/amd64/unix") then
				return "smartos"
			end
		end
		return "unknown"
	end
	distro = check_distro (f_table)
	if distro ~= "unknown" then
		print ("Distro: " .. distro)
		
	end
	grub.getkey()
end

function open (file, file_type, device, device_type, arch, platform)
-- common
	icon = "go-previous"
	command = "action=genlst; path=" .. path .. "; hidden_menu=1; export action; export path; export hidden_menu; configfile $prefix/clean.sh"
	name = grub.gettext("Back")
	grub.add_icon_menu (icon, command, name)
-- 
	if file_type == "iso" then
		if device_type ~= "3" then
			-- mount
			grub.run ("loopback -d loop")
			grub.run ("loopback loop " .. file)
			icon = "iso"
			command = "action=genlst; path=; export action; export path; configfile $prefix/clean.sh"
			name = grub.gettext("Mount ISO")
			grub.add_icon_menu (icon, command, name)
			-- isoboot
			iso_path = string.match (file, "^%([%w,]+%)(.*)$")
			grub.setenv ("iso_path", iso_path)
			grub.run ("probe --set=dev_uuid -u " .. device)
			dev_uuid = grub.getenv ("dev_uuid")
			grub.run ("probe -q --set=iso_label --label (loop)")
			iso_label = grub.getenv ("iso_label")
			grub.run ("probe --set=iso_uuid -u (loop)")
			iso_uuid = grub.getenv ("iso_uuid")
			isoboot (iso_path, iso_label, iso_uuid, dev_uuid)
		end
		if platform == "pc" then
			-- memdisk iso
			icon = "iso"
			command = "linux16 $prefix/memdisk iso raw; enable_progress_indicator=1; initrd16 " .. file
			name = grub.gettext("Boot ISO (memdisk)")
			grub.add_icon_menu (icon, command, name)
			-- grub4dos map iso
			icon = "iso"
			tog4dpath (file, device, device_type)
			command = "g4d_cmd=\"find --set-root /fm.loop;/MAP nomem cd " .. g4d_file .."\";"
			command = command .. "linux $prefix/grub.exe --config-file=$g4d_cmd; "
			if g4d_file == "(rd)+1" then
				command = command .. "enable_progress_indicator=1; initrd " .. file
			end
			name = grub.gettext("Boot ISO (GRUB4DOS)")
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "wim" then
		if platform == "pc" then
			-- wimboot
			icon = "wim"
			command = "enable_progress_indicator=1; loopback wimboot /wimboot; linux16 (wimboot)/wimboot gui; initrd16 newc:bootmgr:(wimboot)/bootmgr newc:bcd:(wimboot)/bcd newc:boot.sdi:(wimboot)/boot.sdi newc:boot.wim:" .. file
			name = grub.gettext("Boot NT6.x WIM (wimboot)")
			grub.add_icon_menu (icon, command, name)
			-- BOOTMGR/NTLDR only supports (hdx,y)
			if device_type == "1" then
				if grub.file_exist ("/NTBOOT.MOD/NTBOOT.NT6") then
					-- NTBOOT NT6 WIM
					icon = "nt6"
					tog4dpath (file, device, device_type)
					command = "g4d_cmd=\"find --set-root /fm.loop;/NTBOOT NT6=" .. g4d_file .. "\";"
					command = command .. "linux $prefix/grub.exe --config-file=$g4d_cmd; "
					name = grub.gettext("Boot NT6.x WIM (NTBOOT)")
					grub.add_icon_menu (icon, command, name)
				end
				if grub.file_exist ("/NTBOOT.MOD/NTBOOT.PE1") then
					-- NTBOOT NT5 WIM (PE1)
					icon = "nt5"
					tog4dpath (file, device, device_type)
					command = "g4d_cmd=\"find --set-root /fm.loop;/NTBOOT pe1=" .. g4d_file .. "\";"
					command = command .. "linux $prefix/grub.exe --config-file=$g4d_cmd; "
					name = grub.gettext("Boot NT5.x WIM (NTBOOT)")
					grub.add_icon_menu (icon, command, name)
				end
			end
		end
	elseif file_type == "wpe" then
		if platform == "pc" then
			-- NTLDR only supports (hdx,y)
			if device_type == "1" then
				if grub.file_exist ("/NTBOOT.MOD/NTBOOT.PE1") then
					-- NTBOOT NT5 PE
					icon = "nt5"
					tog4dpath (file, device, device_type)
					command = "g4d_cmd=\"find --set-root /fm.loop;/NTBOOT pe1=" .. g4d_file .. "\";"
					command = command .. "linux $prefix/grub.exe --config-file=$g4d_cmd; "
					name = grub.gettext("Boot NT5.x PE (NTBOOT)")
					grub.add_icon_menu (icon, command, name)
				end
			end
		end
	elseif file_type == "vhd" then
		if platform == "pc" then
			-- BOOTMGR only supports (hdx,y)
			if device_type == "1" then
				if grub.file_exist ("/NTBOOT.MOD/NTBOOT.NT6") then
					-- NTBOOT NT6 VHD
					icon = "nt6"
					tog4dpath (file, device, device_type)
					command = "g4d_cmd=\"find --set-root /fm.loop;/NTBOOT NT6=" .. g4d_file .. "\";"
					command = command .. "linux $prefix/grub.exe --config-file=$g4d_cmd; "
					name = grub.gettext("Boot Windows NT6.x VHD (NTBOOT)")
					grub.add_icon_menu (icon, command, name)
				end
			end
		end
	elseif file_type == "fba" then
		if device_type ~= "3" then
			-- mount
			icon = "img"
			command = "loopback -d ud; loopback ud " .. file .. "; action=genlst; path=(ud); export action; export path; configfile $prefix/clean.sh"
			name = grub.gettext("Mount Image")
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "disk" then
		if device_type ~= "3" then
			-- mount
			icon = "img"
			command = "loopback -d img; loopback img " .. file .. "; action=genlst; path=; export action; export path; configfile $prefix/clean.sh"
			name = grub.gettext("Mount Image")
			grub.add_icon_menu (icon, command, name)
		end
		if platform == "pc" then
			-- memdisk floppy
			icon = "img"
			command = "linux16 $prefix/memdisk floppy raw; enable_progress_indicator=1; initrd16 " .. file
			name = grub.gettext("Boot Floppy Image (memdisk)")
			grub.add_icon_menu (icon, command, name)
			-- grub4dos map fd
			icon = "img"
			tog4dpath (file, device, device_type)
			command = "g4d_cmd=\"find --set-root /fm.loop;/MAP nomem fd " .. g4d_file .. "\";"
			command = command .. "linux $prefix/grub.exe --config-file=$g4d_cmd; "
			if g4d_file == "(rd)+1" then
				command = command .. "enable_progress_indicator=1; initrd " .. file
			end
			name = grub.gettext("Boot Floppy Image (GRUB4DOS)")
			grub.add_icon_menu (icon, command, name)
			-- memdisk harddisk
			icon = "img"
			command = "linux16 $prefix/memdisk harddisk raw; enable_progress_indicator=1; initrd16 " .. file
			name = grub.gettext("Boot Hard Drive Image (memdisk)")
			grub.add_icon_menu (icon, command, name)
			-- grub4dos map hd
			icon = "img"
			tog4dpath (file, device, device_type)
			command = "g4d_cmd=\"find --set-root /fm.loop;/MAP nomem hd " .. g4d_file .. "\";"
			command = command .. "linux $prefix/grub.exe --config-file=$g4d_cmd; "
			if g4d_file == "(rd)+1" then
				command = command .. "enable_progress_indicator=1; initrd " .. file
			end
			name = grub.gettext("Boot Hard Drive Image (GRUB4DOS)")
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "ipxe" then
		if platform == "pc" then
			-- ipxe
			icon = "net"
			command = "linux16 $prefix/ipxe.lkrn; initrd16 " .. file
			name = grub.gettext("Open As iPXE Script")
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "efi" then
		if platform == "efi" then
			-- efi
			icon = "uefi"
			command = "chainloader " .. file
			name = grub.gettext("Open As EFI")
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "tar" then
		if device_type ~= "3" then
			-- mount
			icon = "7z"
			command = "loopback -d tar; loopback tar " .. file .. "; action=genlst; path=(tar); export action; export path; configfile $prefix/clean.sh"
			name = grub.gettext("Open As Archiver")
			grub.add_icon_menu (icon, command, name)
		end
	elseif file_type == "cfg" then
		-- GRUB 2 menu
		icon = "cfg"
		command = "root=" .. device .. "; configfile " .. file
		name = grub.gettext("Open As Grub2 Menu")
		grub.add_icon_menu (icon, command, name)
		-- Syslinux menu
		icon = "cfg"
		command = "root=" .. device .. "; syslinux_configfile " .. file
		name = grub.gettext("Open As Syslinux Menu")
		grub.add_icon_menu (icon, command, name)
	elseif file_type == "lst" then
		if platform == "pc" then
			if device_type ~= "3" then
				-- GRUB4DOS menu
				icon = "cfg"
				tog4dpath (file, device, device_type)
				command = "g4d_cmd=\"find --set-root /fm.loop;configfile " .. g4d_file .. "\";"
				command = command .. "linux $prefix/grub.exe --config-file=$g4d_cmd; "
				name = grub.gettext("Open As GRUB4DOS Menu")
				grub.add_icon_menu (icon, command, name)
			end
		end
		-- GRUB-Legacy menu
		icon = "cfg"
		command = "root=" .. device .. "; legacy_configfile " .. file
		name = grub.gettext("Open As GRUB-Legacy Menu")
		grub.add_icon_menu (icon, command, name)
	elseif file_type == "pf2" then
		-- PF2 font
		icon = "pf2"
		command = "loadfont " .. file
		name = grub.gettext("Open As Font")
		grub.add_icon_menu (icon, command, name)
	elseif file_type == "mod" then
		-- insmod
		icon = "mod"
		command = "insmod " .. file
		name = grub.gettext("Insert Grub2 Module")
		grub.add_icon_menu (icon, command, name)
	elseif file_type == "image" then
		-- png/jpg/tga
		icon = "png"
		command = "background_image " .. file .. "; echo -n " .. grub.gettext ("Press [ESC] to continue...") .. "; "
		command = command .. "getkey; background_image ${prefix}/themes/slack/black.png"
		name = grub.gettext("Open As Image")
		grub.add_icon_menu (icon, command, name)
	elseif file_type == "lua" then
		-- lua
		icon = "lua"
		command = "root=" .. device .. "; lua " .. file
		name = grub.gettext("Open As Lua Script")
		grub.add_icon_menu (icon, command, name)
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