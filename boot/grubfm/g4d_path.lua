#!lua
-- Grub2-FileManager
-- Copyright (C) 2018, 2019, 2020  A1ive.
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

file = grub.getenv ("g4d_path")
if (file == nil) then
  file = ""
end

device = string.match (file, "^%(([%w,]+)%)/.*$")
if string.match (device, "^hd[%d]+,[%w]+") ~= nil then
  -- (hdx,y)
  devnum = string.match (device, "^hd%d+,%a*(%d+)$")
  devnum = devnum - 1
  g4d_file = "(" .. string.match (device, "^(hd%d+,)%a*%d+$") .. devnum .. ")"
             .. string.match (file, "^%([%w,]+%)(.*)$")
elseif string.match (device, "^[hcf]d[%d]*") ~= nil then
-- (hdx) (cdx) (fdx) (cd)
  g4d_file = file
else
-- (loop) (memdisk) (proc) etc.
  g4d_file = ""
end

g4d_file = string.gsub (g4d_file, " ", "\\ ")
grub.exportenv ("g4d_path", g4d_file)
