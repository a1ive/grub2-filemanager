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
local file = grub.getenv ("file_name")
encoding = grub.getenv ("encoding")
if (encoding == nil) then
	encoding = "utf8"
end

if (file == nil) then
	return 1
else
	data = grub.file_open(file)
	grub.cls()
	print ("File: " .. file .. " Size: " .. grub.file_getsize(data))
	print ("Encoding: " .. encoding)
	while (grub.file_eof(data) == false)
	do
		line = grub.file_getline (data)
		if (encoding == "gbk") then
			line = grub.toutf8(line)
		end
		print (line)
	end
	print ("EOF")
	print ("按任意键退出...")
	grub.getkey()
	return 0
end