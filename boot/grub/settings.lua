#!lua
-- Grub2-FileManager
-- Copyright (C) 2018,2019  A1ive.
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
esc_flag = grub.getenv ("grub_disable_esc")
if (esc_flag == nil) then
    esc_flag = "0"
end
disk_flag = grub.getenv ("show_vdisk")
if (disk_flag == nil) then
    disk_flag = "0"
end
grub.exportenv ("theme", "slack/f4.txt")
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
    icon = "sort"
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
-- enable_esc
if (esc_flag == "1") then
    icon = "cancel"
    command = "export grub_disable_esc=0;"
else
    icon = "check"
    command = "export grub_disable_esc=1;"
end
command = command .. " lua $prefix/settings.lua"
name = grub.gettext ("Enable ESC (not recommended)")
grub.add_icon_menu (icon, command, name)
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
-- show memdisk
if (disk_flag == "0") then
    icon = "cancel"
    command = "export show_vdisk=1;"
else
    icon = "check"
    command = "export show_vdisk=0;"
end
command = command .. " lua $prefix/settings.lua"
name = grub.gettext ("Show hidden drives")
grub.add_icon_menu (icon, command, name)
-- extra module
icon = "mem"
command = "lua $prefix/extra.lua"
name = grub.gettext ("Load extra modules")
grub.add_icon_menu (icon, command, name)
-- hidden menu
hotkey = "f1"
command = "lua $prefix/help.lua"
grub.add_hidden_menu (hotkey, command, "Help")
hotkey = "f2"
command = "lua $prefix/main.lua"
grub.add_hidden_menu (hotkey, command, "FM")
hotkey = "f3"
command = "lua $prefix/osdetect.lua"
grub.add_hidden_menu (hotkey, command, "Boot")
hotkey = "f5"
command = "lua $prefix/power.lua"
grub.add_hidden_menu (hotkey, command, "Reboot")