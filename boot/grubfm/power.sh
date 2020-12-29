# Grub2-FileManager
# Copyright (C) 2020  A1ive.
#
# Grub2-FileManager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Grub2-FileManager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Grub2-FileManager.  If not, see <http://www.gnu.org/licenses/>.

menuentry $"Warm Reboot (R)" --class reboot --hotkey "r" {
  reset -w;
}

menuentry $"Cold Reboot (S)" --class reboot --hotkey "s" {
  reset -c;
}

menuentry $"Halt (H)" --class halt --hotkey "h" {
  halt;
}

if [ "$grub_platform" = "efi" ];
then
  menuentry $"EFI Firmware Setup" --class mem {
    reset -f;
  }

else
  menuentry $"Halt (don't use APM)" --class uefi {
    halt -n;
  }
fi;

source ${prefix}/global.sh;
