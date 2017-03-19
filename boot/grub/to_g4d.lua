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
if (file == nil) then
	return 1
end

-- remove 'msdos' or 'gpt'
if (string.match (file, "^%(%w+,%a+%d+%)/.*$") ~= nil) then
	 file = string.match (file, "^(%(%w+,)%a+%d+%)/.*$") .. string.match (file, "^%(%w+,%a+(%d+%)/.*)$")
	 print ("convert to grub4dos path: " .. file)
end

grub.setenv ("g4d", file)