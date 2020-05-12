# Grub2-FileManager
# Copyright (C) 2017,2020  A1ive.
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

function search_list {
  set ext="${1}";
  unset found;
  echo "Searching *.${ext} ...";
  for file in ${srcdir}*.${ext} ${srcdir}*/*.${ext} ${srcdir}*/*/*.${ext};
  do
    if [ -f "${file}" ];
    then
      echo "${file}";
    else
      continue;
    fi
    set found="1";
    menuentry "${file}" --class ${2} {
      grubfm_open "${1}";
    }
  done;
  if [ -z "${found}" ];
  then
    menuentry $"File not found" --class search {
      configfile ${prefix}/search.sh;
    }
  fi;
}

function search_menu {
  menuentry $"Please select the type of file you want to search:" --class search {
    grubfm;
  }
  submenu "wim" --class wim {
    search_list "wim" "wim";
  }
  submenu "iso" --class iso {
    search_list "iso" "iso";
  }
  submenu "img" --class img {
    search_list "img" "img";
  }
  submenu "vhd" --class img {
    search_list "vhd" "img";
  }
  submenu "efi" --class exe {
    search_list "efi" "exe";
  }
}

search_menu;
source $prefix/global.sh;
