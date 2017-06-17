#!lua
-- Grub2-FileManager
-- Copyright (C) 2017  A1ive.
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

local device = grub.getenv ("device")
local file = nil
local sysver="Windows NT"
local dlltable = {
        "(" .. device .. ")/Windows/System32/Version.dll",
        "(" .. device .. ")/Windows/System32/version.dll",
        "(" .. device .. ")/Windows/system32/Version.dll",
        "(" .. device .. ")/Windows/system32/version.dll",
        "(" .. device .. ")/windows/System32/Version.dll",
        "(" .. device .. ")/windows/System32/version.dll",
        "(" .. device .. ")/windows/system32/Version.dll",
        "(" .. device .. ")/windows/system32/version.dll"
}
for i=1,8 do
        dll = dlltable[i]
        if (grub.file_exist (dll)) then
                file = grub.file_open (dll)
                print ("DLL File : " .. dll)
                break
        end
end
if (file == nil) then
        print "ERROR"
        return 1
end
offset = 0x1000
length = 0x001c
buf = ""
while (buf ~= "P.r.o.d.u.c.t.V.e.r.s.i.o.n.")
do
        offset = offset + 1
        buf = grub.hexdump (file, offset, length)

end
offset = offset + length + 2
print ("OFFSET : " .. offset)
buf = ""
for i=0,6,2 do
        buf = buf .. grub.hexdump (file, offset + i, 1)
end
print ("RAW : " .. buf)
if (buf == "5.0.") then
        sysver = "Windows 2000"
elseif (buf == "5.1.") then
        sysver = "Windows XP"
elseif (buf == "5.2.") then
        sysver = "Windows Server 2003"
elseif (buf == "6.0.") then
        sysver = "Windows Server 2008"
elseif (buf == "6.1.") then
        sysver = "Windows 7"
elseif (buf == "6.2.") then
        sysver = "Windows 8"
elseif (buf == "6.3.") then
        sysver = "Windows 8.1"
elseif (buf == "10.0") then
        sysver = "Windows 10"
else
        sysver = "Windows NT"
end
print ("Version : " .. sysver)
grub.setenv ("sysver", sysver)
return 0