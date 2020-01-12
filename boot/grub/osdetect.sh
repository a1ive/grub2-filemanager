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

function auto_swap {
  if regexp '^hd[0-9a-zA-Z,]+$' $root;
  then
    regexp -s devnum '^hd([0-9]+).*$' $root;
    if test "devnum" != "0";
    then
      drivemap -s (hd0) ($root);
    fi;
  fi;
}

for dev in (*); do
  if [ -e ${dev} ];
  then
    regexp --set=device '\((.*)\)' "${dev}";
  else
    continue;
  fi;
  if [ -f "(${device})/boot/grub/external_menu.cfg" ];
  then
    menuentry $"Load External Menu on (${device})" "${device}" --class cfg {
      export theme=${prefix}/themes/slack/theme.txt;
      set root="${2}";
      configfile (${root})/boot/grub/external_menu.cfg;
    }
  fi;
  if [ "${grub_platform}" = "efi" ];
  then
    if [ -f "(${device})/efi/microsoft/boot/bootmgfw.efi" ];
    then
      menuentry $"Load Windows Boot Manager on ${device}" "${device}" --class nt6 {
        set root="${2}";
        chainloader -t (${root})/efi/microsoft/boot/bootmgfw.efi;
      }
    fi;
    if [ "${grub_cpu}" = "x86_64" ];
    then
      set boot_file="/efi/boot/bootx64.efi";
    elif [ "${grub_cpu}" = "x86_64" ];
    then
      set boot_file="/efi/boot/bootia32.efi";
    fi;
    if [ -f "(${device})${boot_file}" ];
    then
      menuentry $"Boot ${device}" "${device}" "${boot_file}" --class uefi {
        set root="${2}";
        set boot_file="${3}";
        chainloader -t (${root})${boot_file};
      }
    fi;
    if [ -f "(${device})/System/Library/CoreServices/boot.efi" ];
    then
      menuentry $"Boot macOS on ${device}" "${device}" --class macOS {
        set root="${2}";
        chainloader -t "(${root})/System/Library/CoreServices/boot.efi";
      }
    fi;
    if ntversion "(${device})" sysver;
    then
      menuentry $"Boot Windows ${sysver} on ${device}" "${device}" --class nt6 {
        set root="${2}";
        set lang=en_US;
        terminal_output console;
        loopback wimboot ${prefix}/wimboot.gz;
        ntboot --gui --win --efi=(wimboot)/bootmgfw.efi "(${root})";
      }
      unset sysver;
    fi;
  elif [ "$grub_platform" = "pc" ];
  then
    echo "";
  fi;
done;

source ${prefix}/global.sh;
