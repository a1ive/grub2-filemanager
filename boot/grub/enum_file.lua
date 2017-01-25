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

if (root == nil) or (root == "") then
	return 1;
else
	d_list = ""
	f_list = ""
	local function enum_file (name)
		local path = root .. "/" .. name
		if grub.file_exist (path) then
			f_list = name .. "\n" .. f_list
		elseif (name ~= "." and name ~= "..") then
			d_list = name .. "\n" .. d_list
		end
	end
	grub.enum_file (enum_file,root .. "/")
	grub.setenv ("f_list", f_list)
	grub.setenv ("d_list", d_list)
end

	