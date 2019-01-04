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
platform = grub.getenv ("grub_platform")
grub.exportenv ("theme", "slack/f5.txt")
grub.clear_menu ()
grub.add_icon_menu ( "reboot", "reboot", grub.gettext ("Reboot"))
grub.add_icon_menu ( "halt", "halt", grub.gettext ("Halt"))

if platform == "efi" then
    -- fwsetup
	icon = "mem"
	command = "fwsetup"
	name = grub.gettext ("EFI Firmware Setup")
	grub.add_icon_menu (icon, command, name)
    -- efi shell
    icon = "ms-dos"
	command = "set lang=en_US; terminal_output=console; chainloader $prefix/Shell.efi"
	name = grub.gettext ("EFI Shell")
	grub.add_icon_menu (icon, command, name)
end
-- grub cmdline
icon = "ms-dos"
command = "commandline"
name = grub.gettext ("GRUB Console")
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
hotkey = "f4"
command = "lua $prefix/settings.lua"
grub.add_hidden_menu (hotkey, command, "Settings")
