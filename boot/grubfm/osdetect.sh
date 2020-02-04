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

function to_win_ver {
  if [ "${1}" = "5.0" ];
  then
    set winver="Windows 2000";
  elif [ "${1}" = "5.1" ];
  then
    set winver="Windows XP";
  elif [ "${1}" = "5.2" ];
  then
    set winver="Windows Server 2003";
  elif [ "${1}" = "6.0" ];
  then
    set winver="Windows Server 2008";
  elif [ "${1}" = "6.1" ];
  then
    set winver="Windows 7";
  elif [ "${1}" = "6.2" ];
  then
    set winver="Windows 8";
  elif [ "${1}" = "6.3" ];
  then
    set winver="Windows 8.1";
  elif [ "${1}" = "10.0" ];
  then
    set winver="Windows 10";
  else
    set winver="Windows NT ${1}";
  fi;
}

for dev in (hd*,*);
do
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
      to_win_ver "${sysver}";
      menuentry $"Boot ${winver} on ${device}" "${device}" --class nt6 {
        set root="${2}";
        set lang=en_US;
        terminal_output console;
        loopback wimboot ${prefix}/wimboot.gz;
        ntboot --gui --win --efi=(wimboot)/bootmgfw.efi "(${root})";
      }
      unset sysver;
      unset winver;
    fi;
  elif [ "$grub_platform" = "pc" ];
  then
    probe --set=bootable -b ${device};
    if regexp 'bootable' "${bootable}";
    then
      menuentry $"Boot ${device}" "${device}" --class hdd {
        set root="${2}";
        auto_swap;
        regexp --set=1:tmp '(hd[0-9]+),[a-zA-Z]*[0-9]+' "${2}";
        chainloader --force --bpb "(${tmp})+1";
      }
    fi;
    if ntversion "(${device})" sysver;
    then
      to_win_ver "${sysver}";
      menuentry $"Boot ${winver} on ${device}" "${device}" "${sysver}" --class nt6 {
        regexp --set=1:tmp --set=2:num '(hd[0-9]+,)[a-zA-Z]*([0-9]+)' "${2}";
        expr --set=num "${num} - 1";
        set g4d_dev="(${tmp}${num})";
        if regexp '^5\.' "${3}";
        then
          set nt="NT5";
        else
          set nt="NT6";
        fi;
        set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/NTBOOT ${nt}=${g4d_dev};";
        linux ${prefix}/grub.exe --config-file=${g4d_cmd};
      }
      unset sysver;
      unset winver;
    fi;
  fi;
done;

source ${prefix}/global.sh;
