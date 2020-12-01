#!lua
-- Grub2-FileManager
-- Copyright (C) 2017,2018,2020  A1ive.
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

local function enum_subdir (name, isdir)
  if (isdir == 1)
  then
    return
  end
  local name_ext = string.match (string.lower (name), ".*%.(.*)$")
  if (name_ext ~= nil and name_ext == search_ext)
  then
    local title = search_path .. subdir .. name
    --print (title)
    grub.add_icon_menu (search_ico, "grubfm_open \"" .. title .. "\"", title)
  end
end

local function enum_file (name, isdir)
  if (isdir == 1)
  then
    subdir = name .. "/"
    grub.enum_file (enum_subdir, search_path .. "/" .. subdir)
  end
  local name_ext = string.match (string.lower (name), ".*%.(.*)$")
  if (name_ext ~= nil and name_ext == search_ext)
  then
    local title = search_path .. name
    --print (title)
    grub.add_icon_menu (search_ico, "grubfm_open \"" .. title .. "\"", title)
  end
end

local function search_main ()
  if (search_path == nil or search_ext == nil or search_ico == nil)
  then
    return
  end
  grub.enum_file (enum_file, search_path .. "/")
end

--grub.cls ()
--print ("----")
search_path = grub.getenv ("grubfm_current_path")
search_ext = grub.getenv ("grubfm_search_ext")
search_ico = grub.getenv ("grubfm_search_ico")
search_main ()
--print ("debug")
--input.getkey ()
