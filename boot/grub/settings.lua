#!lua
-- Grub2-FileManager
-- Copyright (C) 2018  A1ive.
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

arch = grub.getenv ("grub_cpu")
platform = grub.getenv ("grub_platform")
gfxmode = grub.getenv ("gfxmode")
encoding = grub.getenv ("encoding")
if (encoding == nil) then
	encoding = "utf8"
end
enable_sort = grub.getenv ("enable_sort")
if (enable_sort == nil) then
	enable_sort = "1"
end
debug_flag = grub.getenv ("debug")
if (debug_flag == nil) then
	debug_flag = "off"
end
grub.exportenv ("theme", "slack/extern.txt")
grub.clear_menu ()

-- encoding
if (encoding == "utf8") then
	icon = "gnu-linux"
	command = "export encoding=gbk;"
else
	icon = "nt5"
	command = "export encoding=utf8;"
end
command = command .. " lua $prefix/settings.lua"
name = grub.gettext ("Encoding: ") .. string.upper (encoding)
grub.add_icon_menu (icon, command, name)
-- sort
if (enable_sort == "1") then
	icon = "check"
	command = "export enable_sort=0;"
else
	icon = "cancel"
	command = "export enable_sort=1;"
end
command = command .. " lua $prefix/settings.lua"
name = grub.gettext ("Sort files by name")
grub.add_icon_menu (icon, command, name)
-- resolution
icon = "screen"
command = "lua $prefix/screen.lua"
name = grub.gettext ("Resolution (R): ") .. gfxmode
grub.add_icon_menu (icon, command, name)
grub.add_hidden_menu ("r", command, "gfxmode")
-- debug
if (debug_flag == "off") then
	icon = "cancel"
	command = "export debug=all;"
else
	icon = "check"
	command = "export debug=off;"
end
command = command .. " lua $prefix/settings.lua"
name = grub.gettext ("Enable debug messages")
grub.add_icon_menu (icon, command, name)
-- fwsetup
if platform == "efi" then
	icon = "mem"
	command = "fwsetup"
	name = grub.gettext ("EFI Firmware Setup")
	grub.add_icon_menu (icon, command, name)
end

icon = "go-previous"
command = "lua $prefix/main.lua"
name = grub.gettext ("Back")
grub.add_icon_menu (icon, command, name)