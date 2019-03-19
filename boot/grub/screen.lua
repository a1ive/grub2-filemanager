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
grub.clear_menu()
gfxlist = video.info ()
grub.run ("terminal_output console")

command = "set gfxmode=auto; terminal_output gfxterm; lua $prefix/settings.lua"
name = "AUTO DETECT"
grub.add_menu (command, name)

for gfxmode in string.gmatch (gfxlist, "%w+") do
    command = "set gfxmode=" .. gfxmode .. "; terminal_output gfxterm; lua $prefix/settings.lua"
    name = gfxmode
    grub.add_menu (command, name)
end
