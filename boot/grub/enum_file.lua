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

root = grub.getenv ("fm_path")
encoding = grub.getenv ("encoding")
if encoding == nil then
	encoding = "utf8"
end
if (root == nil) or (root == "") then
	return 1;
else
	d_table, f_table = {}, {}
	i, j = 0, 0
	local function enum_file (name)
		local path = root .. "/" .. name
		if (encoding == "gbk") then
			name = grub.toutf8(name)
		end
		name = string.gsub(name, " ", ":")
		if grub.file_exist (path) then
			i = i + 1
			f_table[i] = name
		elseif (name ~= "." and name ~= "..") then
			j = j + 1
			d_table[j] = name
		end
	end
	grub.enum_file (enum_file,root .. "/")
	if (grub.getenv ("enable_sort") == "1") then
		table.sort (f_table)
		table.sort (d_table)
	end
	f_list, d_list = table.concat (f_table, "\n"), table.concat (d_table, "\n")
	grub.setenv ("f_list", f_list)
	grub.setenv ("d_list", d_list)
end

	