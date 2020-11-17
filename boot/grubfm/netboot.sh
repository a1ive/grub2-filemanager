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

if [ "$grub_platform" = "efi" ];
then
  set netbootxyz=netboot.xyz.efi
  set chain=chainloader
else
  set netbootxyz=netboot.xyz.lkrn
  set chain=linux16
fi;

menuentry $"netboot.xyz" --class net {
  set lang=en_US;
  terminal_output console;
  echo $"Please wait ...";
  $chain (http,boot.netboot.xyz)/ipxe/$netbootxyz
}

source ${prefix}/global.sh;
