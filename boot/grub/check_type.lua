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

file = grub.getenv ("file_name")
file_extn = grub.getenv ("file_extn")

if (file == nil) then
	return 1;
else
	file_type = "unknown"
	file_icon = "txt"
	if file_extn ~= nil then
		file_extn = string.lower(file_extn)
		if file_extn == "iso" then
			file_type, file_icon = "iso", "iso"
		elseif file_extn == "img" or file_extn == "vhd" then
			file_type, file_icon = "disk", "img"
		elseif file_extn == "jpg" or file_extn == "png" or file_extn == "tga" then
			file_type, file_icon = "image", "png"
		elseif file_extn == "bmp" or file_extn == "gif" then
			file_icon = "png"
		elseif file_extn == "efi" then
			file_type, file_icon = "efi", "uefi"
		elseif file_extn == "lua" then
			file_type, file_icon = "lua", "lua"
		elseif file_extn == "7z" or file_extn == "rar" then
			file_icon = "7z"
		elseif file_extn == "lz" or file_extn == "zip" or file_extn == "lzma" then
			file_icon = "7z"
		elseif file_extn == "xz" or file_extn == "gz" then
			file_icon = "7z"
		elseif file_extn == "wim" then
			file_icon = "wim"
		elseif file_extn == "exe" then
			file_icon = "exe"
		elseif file_extn == "cfg" then
			file_type = "cfg"
		end
	end
	grub.setenv ("file_type",file_type)
	grub.setenv ("file_icon",file_icon)
end
	