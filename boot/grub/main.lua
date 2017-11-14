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

function init ()
	encoding = grub.getenv ("encoding")
	if (encoding == nil) then
		encoding = "utf8"
	end
	enable_sort = grub.getenv ("enable_sort")
	if (enable_sort == nil) then
		enable_sort = 1
	end
	path = grub.getenv ("path")
	if (path == nil) then
		path = ""
	end
end

function enum_device (device, fs, uuid, label)
-- ignore (memdisk) and (proc)
	print (device)
	if (device == "memdisk" or device == "proc") then
		return 0
	end
	icon = "img"
	if (fs == "iso9660" or fs == "udf") then
		icon = "iso"
	end
	if (string.match (device, "^hd") ~= nil) then
		icon = "hdd"
	end
	title = "(" .. device .. ") [" .. fs .. "] "
	if (label ~= nil) then
		title = title .. label
	end
	command = "action=genlst; path=(" .. device .. "); export action; export path; configfile $prefix/clean.sh"
	grub.add_icon_menu (icon, command, title)
end

function check_file (name, name_extn)
	if (name == nil) then
		return 1
	end
	file_type = "unknown"
	file_icon = "txt"
	if (name_extn == nil) then
		return file_type, file_icon
	end
	name_extn = string.lower(name_extn)
	if name_extn == "iso" then
		file_type, file_icon = "iso", "iso"
	elseif name_extn == "img" or name_extn == "ima" then
		file_type, file_icon = "disk", "img"
	elseif name_extn == "vhd" or name_extn == "vhdx" then
		file_type, file_icon = "vhd", "img"
	elseif name_extn == "fba" then
		file_type, file_icon = "fba", "img"
	elseif name_extn == "jpg" or name_extn == "png" or name_extn == "tga" then
		file_type, file_icon = "image", "png"
	elseif name_extn == "bmp" or name_extn == "gif" then
		file_icon = "png"
	elseif name_extn == "efi" then
		file_type, file_icon = "efi", "uefi"
	elseif name_extn == "lua" then
		file_type, file_icon = "lua", "lua"
	elseif name_extn == "7z" or name_extn == "rar" then
		file_icon = "7z"
	elseif name_extn == "lz" or name_extn == "zip" or name_extn == "lzma" then
		file_icon = "7z"
	elseif name_extn == "tar" or name_extn == "xz" or name_extn == "gz" or name_extn == "cpio" then
		file_type, file_icon = "tar", "7z"
	elseif name_extn == "wim" then
		file_type, file_icon = "wim", "wim"
	elseif name_extn == "is_" or name_extn == "im_" then
		file_type, file_icon = "wpe", "windows"
	elseif name_extn == "exe" then
		file_icon = "exe"
	elseif name_extn == "cfg" then
		file_type = "cfg"
	elseif name_extn == "pf2" then
		file_type, file_icon = "pf2", "pf2"
	elseif name_extn == "mod" then
		file_type, file_icon = "mod", "mod"
	elseif name_extn == "mbr" then
		file_type, file_icon = "mbr", "bin"
	elseif name_extn == "sh" or name_extn == "bat" then
		file_icon = "cfg"
	elseif name_extn == "lst" then
		file_type, file_icon = "lst", "cfg"
	elseif name_extn == "ipxe" then
		file_type, file_icon = "ipxe", "net"
	end
	return file_type, file_icon
end

function enum_file (name)
	item = path .. "/" .. name
	print (item)
	if grub.file_exist (item) then
		i = i + 1
		f_table[i] = name
	elseif (name ~= "." and name ~= "..") then
		j = j + 1
		d_table[j] = name
	end
end

function genlst (path)
	if (path == "") then
		grub.enum_device (enum_device)
	else
		i, j = 0, 0
		f_table, d_table = {}, {}
		grub.enum_file (enum_file,path .. "/")
		
		if (enable_sort == 1) then
			table.sort (f_table)
			table.sort (d_table)
		end
		
		icon = "go-previous"
		lpath = string.match (path, "^(.*)/.*$")
		if lpath == nil then
			lpath = ""
		end
		command = "action=genlst; path=" .. lpath .. "; export action; export path; configfile $prefix/clean.sh"
		name = "Back"
		grub.add_icon_menu (icon, command, name)
		
		for j, name in ipairs(d_table) do
			item = path .. "/" .. name
			if (encoding == "gbk") then
				name = grub.toutf8(name)
			end
			icon = "dir"
			command = "action=genlst; path=" .. item .. "; export action; export path; configfile $prefix/clean.sh"
			grub.add_icon_menu (icon, command, name)
		end
		for i, name in ipairs(f_table) do
			item = path .. "/" .. name
			if (encoding == "gbk") then
				name = grub.toutf8(name)
			end
			name_extn = string.match (name, ".*%.([%w]+)$")
			file_type, file_icon = check_file (name, name_extn)
			command = "action=open; file=" .. item .. ";file_type=" .. file_type .. "; export action; export file; export file_type; configfile $prefix/clean.sh"
			grub.add_icon_menu (file_icon, command, name)
		end
	end
end

init()
print ("path: " .. path)
genlst (path)
