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
local param = grub.getenv ("g4d_param")
local file_device = string.match (file, "^(%([%w,]+%))")
local file_path = string.match (file, "^%([%w,]+%)(.*)$")
local g4dcmd = "find --set-root /fm.loop;"
print ("device: " .. file_device)
print ("path  : " .. file_path)
grub.setenv ("rd", "0")
if (string.match (file_device, "^%(hd%d+,%a*%d+%)$") ~= nil) then
	local devnum = string.match (file_device, "^%(hd%d+,%a*(%d+)%)$")
	if (devnum > "0") then
		devnum = devnum - 1
	end
	file_device = string.match (file_device, "^(%(hd%d+,)%a*%d+%)$") .. devnum .. ")"
	file = file_device .. file_path
	print ("grub4dos file path : " .. file)
elseif (string.match (file_device, "^%([fhc]d%d+%)$") ~= nil or file_device == "(cd)") then
	print ("grub4dos file path : " .. file)
else
	print ("wrong path")
	if param == "cdboot" or param == "ntboot" or param == "peboot" or param == "config" or param == "command" then
		print ("Press any key to continue ...")
		grub.getkey ()
		return 1
	end
	grub.setenv ("rd", "1")
	file = "(rd)+1"
end
if param == "config" then
	g4dcmd = g4dcmd .. "configfile " .. file
elseif param == "command" then
	g4dcmd = g4dcmd .. "command " .. file
elseif param == "ntboot" then
	g4dcmd = g4dcmd .. "/NTBOOT NT6=" .. file
elseif param == "peboot" then
	g4dcmd = g4dcmd .. "/NTBOOT pe1=" .. file
elseif param == "cdboot" then
-- FIX ME
	g4dcmd = g4dcmd .. "partnew (hd0,3) 0x00 " .. file .. "/MAP nomem cd " .. file
elseif param == "cd" then
	g4dcmd = g4dcmd .. "/MAP nomem cd " .. file
elseif param == "cd mem" then
	g4dcmd = g4dcmd .. "/MAP mem cd " .. file
elseif param == "hd" then
	g4dcmd = g4dcmd .. "/MAP nomem hd " .. file
elseif param == "hd mem" then
	g4dcmd = g4dcmd .. "/MAP mem hd " .. file
elseif param == "fd" then
	g4dcmd = g4dcmd .. "/MAP nomem cd " .. file
elseif param == "fd mem" then
	g4dcmd = g4dcmd .. "/MAP mem fd " .. file
end
print (g4dcmd)
grub.setenv ("g4dcmd", g4dcmd)

-- print ("Press any key to continue ...")
-- grub.getkey ()
return 0