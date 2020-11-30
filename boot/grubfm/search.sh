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

function search_prepare {
  if [ -f "${theme_std}" ];
  then
    export theme=${theme_std};
  fi;
  menuentry $"Back" --class go-previous --hotkey esc {
    grubfm "${grubfm_current_path}";
  }
}

function search_list {
  set grubfm_search_ext=${1};
  set grubfm_search_ico=${2};
  lua ${prefix}/search.lua;
}

submenu "[I] *.iso" --class iso --hotkey "i" {
  search_prepare;
  search_list iso iso;
}

submenu "[W] *.wim" --class wim --hotkey "w" {
  search_prepare;
  search_list wim wim;
}

submenu "[V] *.vhd | *.vhdx" --class img --hotkey "v" {
  search_prepare;
  search_list vhd img;
  search_list vhdx img;
}

if [ "$grub_platform" = "efi" ];
then
  submenu "[U] *.efi" --class exe --hotkey "u" {
    search_prepare;
    search_list efi uefi;
  }
fi;

submenu "[M] *.img" --class img --hotkey "m" {
  search_prepare;
  search_list img img;
}

source ${prefix}/global.sh;
