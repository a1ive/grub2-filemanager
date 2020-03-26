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

locale_dir = grub.getenv ("secondary_locale_dir")
if (locale_dir == nil) then
  locale_dir = "(memdisk)/boot/grubfm/locale"
end

function enum_mo_file (name)
  local item = locale_dir .. "/" .. name
  local lang = string.match (name, "(.*)%.mo$")
  if grub.file_exist (item) and lang ~= nil then
    i = i + 1
    f_table[i] = lang
  end
end

grub.clear_menu ()
f_table = {}
i = 0
grub.enum_file (enum_mo_file,locale_dir .. "/")
table.sort (f_table)

command = "export lang=en_US; configfile ${prefix}/settings.sh;"
grub.add_icon_menu ("lang", command, "en_US")

for j, name in ipairs(f_table) do
  command = "export lang=" .. name .. "; configfile ${prefix}/settings.sh;"
  grub.add_icon_menu ("lang", command, name)
end

grub.script ("source ${prefix}/global.sh")
