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

function net_detect {
  export grub_netboot=0;
  if [ "${bootdev}" != "tftp" ];
  then
    return;
  fi;
  if [ "${grub_platform}" = "efi" ];
  then
    if [ -z "${net_default_server}" -a -n "${net_efinet0_next_server}" ];
    then
      export net_default_server="${net_efinet0_next_server}";
    fi;
    if getargs --value "proxydhcp" proxydhcp;
    then
      export net_default_server="${proxydhcp}"; 
    fi;
    if [ -z "${net_default_server}" ];
    then
      return;
    fi;
  else
    if [ -z "${net_default_server}" ];
    then
      export net_default_server="${net_pxe_next_server}";
    fi;
  fi;
  export grub_netboot=1;
  grubfm_set --boot 1;
}
