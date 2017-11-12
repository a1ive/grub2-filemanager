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
--B KiB MiB GiB
function div1024 (file_size, unit)
	part_int = file_size / 1024
	part_f1 = 10 * ( file_size % 1024 ) / 1024
	part_f2 =  10 * ( file_size % 1024 ) % 1024
	part_f2 = 10 * ( part_f2 % 1024 ) / 1024
	str = part_int .. "." .. part_f1 .. part_f2 .. unit
	return part_int, str
end

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
grub.setenv ("file_size", str)