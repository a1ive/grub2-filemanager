# GRUB2-FileManager
# Copyright (C) 2016,2017,2018,2019,2020  A1ive.
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

function enum_device
{
  for device in (*);
  do
    if test -d "${device}";
    then
      probe --set=fs -f -q "${device}";
      probe --set=label -l -q "${device}";
      if [ "${fs}" != "fat" ];
      then
        continue;
      fi;
      if regexp 'loop' "${device}";
      then
        continue;
      fi;
      if test "${device}" = "(memdisk)" -o "${device}" = "(proc)";
      then
        continue;
      fi;
      menuentry "${device} [$fs] $label" "${device}" --class hdd {
        list_main "${2}";
      }
      unset label;
      unset fs;
    fi;
  done;
}

function enum_dir
{
  for item in ${list_path}/*;
  do
    regexp --set=1:name '.*/(.*)$' "${item}";
    if test -d "${item}";
    then
      menuentry "[${name}]" "${item}" --class dir {
        list_main "${2}";
      }
    fi;
  done;
}

# grubfm_main PATH
function list_main
{
  clear_menu;
  if [ -z "${1}" ];
  then
    enum_device;
    menuentry $"Cancel" --class cancel {
      grubfm_open "${grubfm_file}";
    }
  else
    export list_path="${1}";
    set default=1;
    menuentry ".." --class go-previous {
      if ! regexp --set=1:list_path '(^.*)/.*$' "${list_path}";
      then
        export list_path="";
      fi
      export list_path;
      list_main "${list_path}";
    }
    menuentry $"Paste here" --class check {
      export dest="${list_path}/";
      fatfs_opt;
    }
    enum_dir;
  fi;
}
