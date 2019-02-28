#!lua
-- Grub2-FileManager
-- Copyright (C) 2019  A1ive.
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
grub.exportenv ("theme", "slack/f4.txt")
grub.clear_menu ()
-- ahci
icon = "pmagic"
command = "insmod ahci"
name = grub.gettext ("Load AHCI Driver")
grub.add_icon_menu (icon, command, name)
-- ehci (useless)
-- icon = "pmagic"
-- command = "insmod ehci"
-- name = grub.gettext ("Load EHCI Driver")
-- grub.add_icon_menu (icon, command, name)
-- crypto
icon = "konboot"
command = "insmod luks; insmod geli; cryptomount -a"
name = grub.gettext ("Mount encrypted volumes (LUKS and geli)")
grub.add_icon_menu (icon, command, name)
-- serial
icon = "ms-dos"
command = "insmod serial; terminal_input --append serial; terminal_output --append serial"
name = grub.gettext ("Enable serial terminal")
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
hotkey = "f5"
command = "lua $prefix/power.lua"
grub.add_hidden_menu (hotkey, command, "Reboot")