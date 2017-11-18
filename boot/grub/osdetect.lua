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
		if grub.file_exist (windev .. "ntldr")
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


function enum_device (device, fs, uuid)
	local root
	local title
	local source
	local kernels = {}
	local kernelnames = {}
	local kernel_num = 0
	local function enum_file (name)
		local version
		version = string.match (name, "vmlinuz%-(.*)")
		if (version == nil) then
			version = string.match (name, "linux%-(.*)")
		end
		if (version ~= nil) then
			table.insert (kernels, version)
			table.insert (kernelnames, name)
			kernel_num = kernel_num + 1
		end
	end

	local function sort_kernel (first, second)
		local a1, a2, a3, a4, b1, b2, b3, b4
		a1, a2, a3, a4 = string.match (first, "(%d+)%.?(%d*).?(%d*)%-?(%d*)")
		b1, b2, b3, b4 = string.match (second, "(%d+)%.?(%d*).?(%d*)%-?(%d*)")
		return (a1 > b1) or (a2 > b2) or (a3 > b3) or (a4 < b4);
	end
	local function freebsd_variants (title, header, footer)
		icon = "freebsd"
		normal = "\nset FreeBSD.acpi_load=YES" ..
		 "\nset FreeBSD.hint.acpi.0.disabled=0"
		noacpi = "\nunset FreeBSD.acpi_load" ..
		 "\nset FreeBSD.hint.acpi.0.disabled=1" ..
		 "\nset FreeBSD.loader.acpi_disabled_by_user=1"
		safe = "\nset FreeBSD.hint.apic.0.disabled=1" ..
		 "\nset FreeBSD.hw.ata.ata_dma=0" ..
	 	 "\nset FreeBSD.hw.ata.atapi_dma=0" ..
		 "\nset FreeBSD.hw.ata.wc=0" ..
		 "\nset FreeBSD.hw.eisa_slots=0" ..
		 "\nset FreeBSD.hint.kbdmux.0.disabled=1"
		grub.add_icon_menu (icon, header .. normal .. footer, title)
		grub.add_icon_menu (icon, header .. " --single" .. normal .. footer,
		   title .. " (single)")
		grub.add_icon_menu (icon, header .. " --verbose" .. normal .. footer,
		   title .. " (verbose)")
		grub.add_icon_menu (icon, header .. " --verbose" .. noacpi .. footer,
		   title .. " (without ACPI)")
		grub.add_icon_menu (icon, header .. " --verbose" .. noacpi .. safe .. footer,
		   title .. " (safe mode)")
	end

	root = "(" .. device .. ")/"
	source = "set root=" .. device .. "\nchainloader +1"

	local drive_num = string.match (device, "hd(%d+)")
	if (drive_num ~= nil) and (drive_num ~= "0") then
		source = source .. "\ndrivemap -s hd0 hd" .. drive_num
	end
	icon = "img"
	title = nil
	if (grub.file_exist (root .. "bootmgr") and
	  grub.file_exist (root .. "boot/bcd")) then
		title = get_ntver (root)
		icon = "nt6"
		source = "set root=" .. device .. "\nchainloader +1"
	elseif (grub.file_exist (root .. "ntldr") and
	  grub.file_exist (root .. "ntdetect.com") and
	  grub.file_exist (root .. "boot.ini")) then
		icon = "nt5"
		title = get_ntver (root)
	elseif (grub.file_exist (root .. "windows/win.com")) then
		icon = "nt5"
		title = "Windows 98/ME"
	elseif (grub.file_exist (root .. "io.sys") and
	  grub.file_exist (root .. "command.com")) then
		icon = "ms-dos"
		title = "MS-DOS"
	elseif (grub.file_exist (root .. "kernel.sys")) then
		icon = "ms-dos"
		title = "FreeDOS"
	elseif ((fs == "ufs1" or fs == "ufs2") and grub.file_exist (root .. "boot/kernel/kernel") and
	  grub.file_exist (root .. "boot/device.hints")) then
		header = "set root=" .. device .. "\nfreebsd /boot/kernel/kernel"
		footer = "\nset FreeBSD.vfs.root.mountfrom=ufs:ufsid/" .. uuid ..
		 "\nfreebsd_loadenv /boot/device.hints"
		icon = "freebsd"
		title = "FreeBSD (on " .. fs .. " ".. device .. ")"
		freebsd_variants (title, header, footer)
		return 0
	elseif (fs == "zfs" and grub.file_exist (root .. "/@/boot/kernel/kernel") and
	  grub.file_exist (root .. "/@/boot/device.hints")) then
		header = "set root=" .. device .. "\nfreebsd /@/boot/kernel/kernel"
		footer =  "\nfreebsd_module_elf /@/boot/kernel/opensolaris.ko" ..
		 "\nfreebsd_module_elf /@/boot/kernel/zfs.ko" ..
		 "\nfreebsd_module /@/boot/zfs/zpool.cache type=/boot/zfs/zpool.cache" ..
		 "\nprobe -l -s name $root" ..
		 "\nset FreeBSD.vfs.root.mountfrom=zfs:$name" ..
		 "\nfreebsd_loadenv /@/boot/device.hints"
		icon = "freebsd"
		title = "FreeBSD (on " .. fs .. " ".. device .. ")"
		freebsd_variants (title, header, footer)
		return 0
	elseif (fs == "hfsplus" and grub.file_exist (root .. "mach_kernel")) then
		source = "set root=" .. device ..
		 "\ninsmod vbe" ..
		 "\ndo_resume=0" ..
		 "\nif [ /var/vm/sleepimage -nt10 / ]; then" ..
		 "\n  if xnu_resume /var/vm/sleepimage; then" ..
	 	 "\n     do_resume=1" ..
		 "\n  fi" ..
		 "\nfi" ..
		 "\nif [ $do_resume == 0 ]; then" ..
		 "\n   xnu_uuid "  .. uuid .. " uuid" ..
		 "\n   if [ -f /Extra/DSDT.aml ]; then" ..
		 "\n      acpi -e /Extra/DSDT.aml" ..
		 "\n   fi" ..
		 "\n   xnu_kernel /mach_kernel boot-uuid=${uuid} rd=*uuid" ..
		 "\n   if [ /System/Library/Extensions.mkext -nt /System/Library/Extensions ]; then" ..
		 "\n      xnu_mkext /System/Library/Extensions.mkext" ..
		 "\n   else" ..
		 "\n      xnu_kextdir /System/Library/Extensions" ..
		 "\n   fi" ..
		 "\n   if [ -f /Extra/Extensions.mkext ]; then" ..
		 "\n      xnu_mkext /Extra/Extensions.mkext" ..
		 "\n   fi" ..
		 "\n   if [ -d /Extra/Extensions ]; then" ..
		 "\n      xnu_kextdir /Extra/Extensions" ..
		 "\n   fi" ..
		 "\n   if [ -f /Extra/devtree.txt ]; then" ..
		 "\n      xnu_devtree /Extra/devtree.txt" ..
		 "\n   fi" ..
		 "\n   if [ -f /Extra/splash.jpg ]; then" ..
		 "\n      insmod jpeg" ..
		 "\n      xnu_splash /Extra/splash.jpg" ..
		 "\n   fi" ..
		 "\n   if [ -f /Extra/splash.png ]; then" ..
	 	 "\n      insmod png" ..
		 "\n      xnu_splash /Extra/splash.png" ..
		 "\n   fi" ..
	 	 "\n   if [ -f /Extra/splash.tga ]; then" ..
		 "\n      insmod tga" ..
		 "\n      xnu_splash /Extra/splash.tga" ..
		 "\n   fi" ..
		 "\nfi"
		icon = "macOS"
		title = "Mac OS X/Darwin"
	else
		grub.enum_file (enum_file, root .. "boot")
		if kernel_num ~= 0 then
			table.sort (kernels, sort_kernel)
			table.sort (kernelnames, sort_kernel)
			for i = 1, kernel_num do
				local initrd
				title = "Linux " .. kernels[i]
				source = "set root=" .. device ..
			 	 "\nlinux /boot/" .. kernelnames[i] ..
				 " root=UUID=" .. uuid ..  " ro"
				if grub.file_exist (root .. "boot/initrd-" ..
				  kernels[i] .. ".img") then
					initrd = "\ninitrd /boot/initrd-" .. kernels[i] .. ".img"
				elseif grub.file_exist (root .. "boot/initrd.img-" .. kernels[i]) then
					initrd = "\ninitrd /boot/initrd.img-" .. kernels[i]
				elseif grub.file_exist (root .. "boot/initrd-" .. kernels[i]) then
					initrd = "\ninitrd /boot/initrd-" .. kernels[i]
				else
					initrd = ""
				end
				icon = "gnu-linux"
				grub.add_icon_menu (icon, source .. initrd, title)
				grub.add_icon_menu (icon, source .. " single" .. initrd,
				 title .. " (single-user mode)")
			end
			return 0
		end
	end

	if title == nil then
		local partition = string.match (device, ".*,(%d+)")
		if (partition ~= nil) and (tonumber (partition) > 4) then
			return 0
		end
		title = "Other OS"
	end
	grub.add_icon_menu (icon, source, title)
	return 0
end

boot_func = grub.getenv ("boot_func")
if boot_func == nil then
	boot_func = ""
end
if boot_func == "osdetect" then
	grub.enum_device (enum_device)
else
	windev = grub.getenv ("device")
	if windev == nil then
		return 1
	end
	windev = "(" .. windev .. ")"
	grub.setenv ("sysver", get_ntver (windev))
end