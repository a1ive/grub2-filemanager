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

grub.exportenv ("theme", "slack/text.txt")
grub.clear_menu ()
local file = grub.getenv ("file")
encoding = grub.getenv ("encoding")
if (encoding == nil) then
	encoding = "utf8"
end
if (file == nil) then
	return 1
else
	data = grub.file_open(file)
	while (grub.file_eof(data) == false)
	do
		line = grub.file_getline (data)
		if (encoding == "gbk") then
			line = grub.toutf8(line)
		end
		grub.add_menu ("echo;", line)
	end
	return 0
end
hotkey = "n"
if (encoding == utf8) then
	command = "export encoding=gbk; lua $prefix/text.lua"
else
	command = "export encoding=utf8; lua $prefix/text.lua"
end
grub.add_hidden_menu (hotkey, command, "Encoding")
hotkey = "q"
command = "lua $prefix/open.lua"
grub.add_hidden_menu (hotkey, command, "Quit")