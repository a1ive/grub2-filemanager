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
local map_dev = grub.getenv ("map_dev")
local file_device = string.match (file, "^(%([%w,]+%))")
local file_path = string.match (file, "^%([%w,]+%)(.*)$")
local g4dcmd = ""
print ("device: " .. file_device)
print ("path  : " .. file_path)
if (string.match (file_device, "^%(hd%d+,%a*%d+%)$") ~= nil) then
	local devnum = string.match (file_device, "^%(hd%d+,%a*(%d+)%)$")
	if (devnum > "0") then
		devnum = devnum - 1
	end
	file_device = string.match (file_device, "^(%(hd%d+,)%a*%d+%)$") .. devnum .. ")"
	file = file_device .. file_path
	print ("grub4dos file path : " .. file)
elseif (string.match (file_device, "^%([fhc]d%d+%)$") ~= nil) then
	print ("grub4dos file path : " .. file)
else
	print ("wrong path")
	file = file_path
	g4dcmd = "find --set-root " .. file .. ";"
end
g4dcmd = g4dcmd .. "map " .. file .. " " .. map_dev .. ";map --hook;chainloader "
if (map_dev == "(fd0)" or map_dev == "(hd0)") then
	g4dcmd = g4dcmd .. map_dev .. "+1;rootnoverify " .. map_dev .. ";boot"
else
	g4dcmd = g4dcmd .. map_dev .. ";boot"
end
print (g4dcmd)
grub.setenv ("g4dcmd", g4dcmd)
print ("按任意键继续")
grub.getkey()
return 0