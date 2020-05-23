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

kbd_dir = "(memdisk)/boot/grubfm/kbd"

function enum_kbd_file (name)
  local item = kbd_dir .. "/" .. name
  local kbd_name = string.match (name, "KBD_(.*)%.cfg$")
  if grub.file_exist (item) and kbd_name ~= nil then
    i = i + 1
    f_table[i] = kbd_name
  end
end

grub.clear_menu ()
f_table = {}
i = 0
grub.enum_file (enum_kbd_file, kbd_dir .. "/")
table.sort (f_table)

command = "setkey -r; setkey -d; configfile ${prefix}/settings.sh;"
grub.add_icon_menu ("gkb", command, "QWERTY_USA")

for j, name in ipairs(f_table) do
  command = "source " .. kbd_dir .. "/KBD_" .. name .. ".cfg; configfile ${prefix}/settings.sh;"
  grub.add_icon_menu ("gkb", command, name)
end

grub.script ("source ${prefix}/global.sh")
