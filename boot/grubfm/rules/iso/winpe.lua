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

local winpe_wim_list =
{
  "(loop)/boot/boot.wim",
  "(loop)/sources/boot.wim",
  "(loop)/wim/w10pe64.wim",
  "(loop)/wim/w10pe32.wim",
  "(loop)/DLC1/W10PE/W10x64.wim",
  "(loop)/DLC1/W10PE/W10x86.wim",
  "(loop)/HKBoot/PE/W10x64PE.wim",
  "(loop)/HKBoot/PE/W10x86PE.wim",
  "(loop)/HKBoot/PE/W8x64PE.wim",
  "(loop)/HKBoot/PE/W8x86PE.wim",
  "(loop)/KMPE/PE64W10.wim",
  "(loop)/KMPE/PE32W10.wim",
  "(loop)/KMPE/PE32W8.wim",
  "(loop)/KMPE/PE32W8NE.wim",
  "(loop)/SSTR/strelec10x64Eng.wim",
  "(loop)/SSTR/strelec10Eng.wim",
  "(loop)/SSTR/strelec8Eng.wim",
  "(loop)/SSTR/strelec8NEEng.wim",
  "(loop)/SSTR/strelec10x64.wim",
  "(loop)/SSTR/strelec10.wim",
  "(loop)/SSTR/strelec8.wim",
  "(loop)/SSTR/strelec8NE.wim",
  "(loop)/BOOT/USM1PE6F.wim", 
  "(loop)/BOOT/USM8PE6F.wim",
  "(loop)/BOOT/USM1PE6L.wim",
  "(loop)/BOOT/USM1PE8F.wim",
  "(loop)/BOOT/USM1PE8L.wim",
  "(loop)/BOOT/USM8PE6L.wim",
  "(loop)/BOOT/USM8PE8F.wim",
  "(loop)/BOOT/USM7PE6L.wim",
  "(loop)/BOOT/USM8PE8L.wim",
  "(loop)/BOOT/USM7PE8L.wim",
  "(loop)/BOOT/H3_1064.WIM",
  "(loop)/BOOT/H3_8164.WIM",
  "(loop)/BOOT/H3_864.WIM",
  "(loop)/BOOT/H3_10PE.WIM",
  "(loop)/BOOT/H3_81PE.WIM",
  "(loop)/BOOT/H3_8PE.WIM",
  "(loop)/BOOT/H3_7PE.WIM",
  "(loop)/Rescue/Rescue.wim",
  "(loop)/boot/images/w7x64/w7x64.wim",
  "(loop)/boot/images/w7x86/w7x86.wim",
  "(loop)/boot/images/w7x86/w7x86n.wim",
  "(loop)/boot/images/w10x64/w10x64.wim",
  "(loop)/boot/images/w10x86/w10x86.wim",
}

local function search_wim (wim_table)
  local j = 0
  for i, wim in ipairs (winpe_wim_list) do
    if (grub.file_exist (wim)) then
      print ("found WIM " .. wim)
      j = j + 1
      wim_table[j] = wim
    end
  end
  return j
end

local function gen_wimboot (wim)
  local platform = grub.getenv ("grub_platform")
  local iso_path = string.match (grub.getenv ("grubfm_file"), "^%([%w,]+%)(.*)$")
  local cmd = "set installiso=\"" .. iso_path .. "\"\n" ..
        "terminal_output console\n" ..
        "set lang=en_US\n" ..
        "tr --set=installiso \"/\" \"\\\\\"\n" ..
        "loopback -m envblk ${prefix}/null.cpio\n" ..
        "save_env -s -f (envblk)/null.cfg installiso\n" ..
        "cat (envblk)/null.cfg\n" ..
        "loopback wimboot ${prefix}/wimboot.xz\n" ..
        "loopback install ${prefix}/install.xz\n" ..
        "wimboot @:bootmgfw.efi:(wimboot)/bootmgfw.efi" ..
        " @:null.cfg:(envblk)/null.cfg" ..
        " @:mount_x64.exe:(install)/mount_x64.exe" ..
        " @:mount_x86.exe:(install)/mount_x86.exe" ..
        " @:start.bat:${grubfm_startpebat}" ..
        " @:winpeshl.ini:(install)/winpeshl.ini" ..
        " @:boot.wim:\"" .. wim .. "\"\n"
  return cmd
end

local function list_wim (wim_table)
  grub.clear_menu ()
  for i, wim in ipairs (wim_table) do
    print ("list WIM " .. wim)
    grub.add_icon_menu ("wim", gen_wimboot (wim), wim)
  end
end

local loop_wim_list = {}
local num = search_wim (loop_wim_list)
local do_list = grub.getenv ("do_list")
if (do_list == nil) then
  grub.setenv ("wim_count", num)
else
  grub.script ("unset do_list")
  if (num > 0) then
    list_wim (loop_wim_list)
  end
end
