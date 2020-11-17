#!lua
-- Grub2-FileManager
-- Copyright (C) 2020  A1ive.
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

menu = grub.getenv ("g4d_menu")
if (menu == nil) then
  menu = ""
end

fat.umount (9)
fat.mount ("rd", 9)
fp = fat.open ("9:/menu.lst", 0x0a)
fat.write (fp, menu)
fat.close (fp)
fat.umount (9)
