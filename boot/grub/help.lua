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

grub.exportenv ("theme", "slack/f1.txt")
grub.clear_menu ()
grub.add_menu ( "echo", "Hotkeys")
grub.add_menu ( "echo", "F1 - Help")
grub.add_menu ( "echo", "F2 - File Manager")
grub.add_menu ( "echo", "F3 - Net Boot")
grub.add_menu ( "echo", "F4 - Boot")
grub.add_menu ( "echo", "F5 - Settings")
grub.add_menu ( "echo", "F6 - Power Off")

-- hidden menu
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