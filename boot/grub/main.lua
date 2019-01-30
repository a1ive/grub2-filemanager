#!lua
-- Grub2-FileManager
-- Copyright (C) 2017,2018  A1ive.
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

function enum_device (device, fs, uuid, label)
-- ignore (memdisk) and (proc)
	if (device == "memdisk" or device == "proc") then
		return 0
	end
	if (fs == "iso9660" or fs == "udf") then
		icon = "iso"
	else
		icon = "hdd"
	end
	title = "(" .. device .. ") [" .. fs .. "] "
	if (label ~= nil) then
		title = title .. label
	end
	command = "export path=(" .. device .. "); lua $prefix/main.lua"
	grub.add_icon_menu (icon, command, title)
end

function check_file (name, name_extn)
	if (name == nil) then
		return 1
	end
	file_type = "unknown"
	file_icon = "file"
	if (name_extn == nil) then
		return file_type, file_icon
	end
	name_extn = string.lower(name_extn)
	if name_extn == "iso" then
		file_type, file_icon = "iso", "iso_file"
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
		file_type, file_icon = "efi", "exe"
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
		file_type, file_icon = "wpe", "wim"
	elseif name_extn == "exe" then
		file_icon = "exe"
	elseif name_extn == "cfg" then
		file_type, file_icon = "cfg", "cfg"
	elseif name_extn == "pf2" then
		file_type, file_icon = "pf2", "pf2"
	elseif name_extn == "mod" then
		file_type, file_icon = "mod", "mod"
	elseif name_extn == "mbr" then
		file_type, file_icon = "mbr", "bin"
    elseif name_extn == "nsh" then
		file_type, file_icon = "nsh", "sh"
	elseif name_extn == "sh" or name_extn == "bat" then
		file_icon = "sh"
	elseif name_extn == "lst" then
		file_type, file_icon = "lst", "cfg"
	elseif name_extn == "ipxe" then
		file_type, file_icon = "ipxe", "net"
	elseif name_extn == "c" or name_extn == "cpp" or name_extn == "h" or name_extn == "hpp" or name_extn == "s" or name_extn == "asm" then
		file_icon = "c"
	elseif name_extn == "mp3" or name_extn == "wav" or name_extn == "cda" or name_extn == "ogg" then
		file_icon = "mp3"
	elseif name_extn == "mp4" or name_extn == "mpeg" or name_extn == "avi" or name_extn == "rmvb" or name_extn == "3gp" or name_extn == "flv" then
		file_icon = "mp4"
	elseif name_extn == "doc" or name_extn == "docx" or name_extn == "wps" or name_extn == "pptx" or name_extn == "pptx" or name_extn == "xls" or name_extn == "xlsx" then
		file_icon = "doc"
    elseif name_extn == "txt" or name_extn == "ini" or name_extn == "log" then
		file_icon = "txt"
    elseif name_extn == "crt" or name_extn == "cer" or name_extn == "der" then
		file_icon = "crt"
    elseif name_extn == "py" then
		file_icon = "py"
	end
	return file_type, file_icon
end

function enum_file (name)
	local item = path .. "/" .. name
	if grub.file_exist (item) then
		i = i + 1
		f_table[i] = name
	elseif (name ~= "." and name ~= "..") then
		j = j + 1
		d_table[j] = name
	end
end

encoding = grub.getenv ("encoding")
if (encoding == nil) then
	encoding = "utf8"
end
enable_sort = grub.getenv ("enable_sort")
if (enable_sort == nil) then
	enable_sort = "1"
end
path = grub.getenv ("path")
if (path == nil) then
	path = ""
end
grub.clear_menu ()
grub.exportenv ("theme", "slack/f2.txt")
if (path == "") then	
    grub.enum_device (enum_device)
else
	i, j = 0, 0
	f_table, d_table = {}, {}
	grub.enum_file (enum_file,path .. "/")
	if (enable_sort == "1") then
		table.sort (f_table)
		table.sort (d_table)
	end
	icon = "go-previous"
	lpath = string.match (path, "^(.*)/.*$")
	if lpath == nil then
		lpath = ""
	end
	command = "export path=" .. lpath .. "; lua $prefix/main.lua"
	name = grub.gettext("Back")
	grub.add_icon_menu (icon, command, name)
	
	for j, name in ipairs(d_table) do
		item = string.gsub(path .. "/" .. name, " ", "\\ ")
		if (encoding == "gbk") then
			name = gbk.toutf8(name)
		end
		icon = "dir"
		command = "export path=" .. item .. "; lua $prefix/main.lua"
		grub.add_icon_menu (icon, command, name)
	end
	for i, name in ipairs(f_table) do
		item = string.gsub(path .. "/" .. name, " ", "\\ ")
		if (encoding == "gbk") then
			name = gbk.toutf8(name)
		end
		name_extn = string.match (name, ".*%.(.*)$")
		file_type, file_icon = check_file (name, name_extn)
		command = "export file=" .. item .. "; export file_type=" .. file_type .. "; lua $prefix/open.lua"
		grub.add_icon_menu (file_icon, command, name)
	end
end
-- hidden menu
hotkey = "f1"
command = "lua $prefix/help.lua"
grub.add_hidden_menu (hotkey, command, "Help")
hotkey = "f3"
command = "lua $prefix/osdetect.lua"
grub.add_hidden_menu (hotkey, command, "Boot")
hotkey = "f4"
command = "lua $prefix/settings.lua"
grub.add_hidden_menu (hotkey, command, "Settings")
hotkey = "f5"
command = "lua $prefix/power.lua"
grub.add_hidden_menu (hotkey, command, "Reboot")
