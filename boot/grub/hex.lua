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

grub.exportenv ("theme", "slack/hex.txt")
grub.clear_menu ()
local file = grub.getenv ("file")
if (file == nil) then
	return 1
else
	offset = grub.getenv ("offset")
	if offset == nil then
		offset = 0x00
	else
		offset = tonumber (offset)
		if offset < 0 then
			offset = 0x00
		end
	end
	data = grub.file_open (file)
	if data == nil then
		print ("Can't open " .. file)
		grub.getkey ()
		return 1
	end
	size = grub.file_getsize (data)
	length = 0x10
	items = 16
	if offset ~= 0x00 then
		grub.add_menu ("export offset=" .. offset - items * length .."; lua $prefix/hex.lua", "<- ")
	end
	for i=1,items do
		if (offset > size) then
			break
		end
		str, hex = grub.hexdump (data, offset, length)
		if (#str > length) then
			str = string.sub (str, 0, length -1)
		end
		grub.add_menu ("echo;", string.format ("0x%08x", offset) .. "    " .. hex .. " |" .. str .. "|")
		offset = offset + length
	end
	if offset < size then
		grub.add_menu ("export offset=" .. offset .."; lua $prefix/hex.lua", "-> ")
	else
		grub.add_menu ("echo;", "---END---")
	end
	data = nil
	return 0
end
hotkey = "q"
command = "lua $prefix/open.lua"
grub.add_hidden_menu (hotkey, command, "Quit")
