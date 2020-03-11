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

if [ -f "${theme_help}" ];
then
  export theme=${theme_help};
fi;

videomode -c mode_current;

if [ "${mode_current}" != "0x0" ];
then
  menuentry $"Hotkeys" {
    echo;
  }

  menuentry $"F1 - Help" {
    echo;
  }

  menuentry $"F2 - Boot Menu" {
    echo;
  }

  menuentry $"F3 - File Manager" {
    echo;
  }

  menuentry $"F4 - OS Detect" {
    echo;
  }

  menuentry $"F5 - Settings" {
    echo;
  }

  menuentry $"F6 - PXE Boot Menu" {
    echo;
  }

  menuentry $"F7 - Power Off" {
    echo;
  }

  if [ "${mode_current}" != "0x0" ];
  then
    menuentry $"Ctrl+l/Ctrl+r - Scroll menu entry's text" {
      echo;
    }
  fi;
  if [ "$grub_platform" = "efi" ];
  then
    menuentry $"LCtrl+LAlt+F12 - Take Screenshots (EFI)" {
      echo;
    }
  fi;
fi;

menuentry $"[A] About GRUB2-FileManager" --hotkey a {
  terminal_output console;
  set gfxmode=640x480;
  terminal_output gfxterm;
  grubfm_about;
  terminal_output console;
  if [ "${mode_current}" != "0x0" ];
  then
    set gfxmode=${mode_current};
    terminal_output gfxterm;
  fi;
}

source ${prefix}/global.sh;

hiddenentry "LCtrl + LAlt + F12 - Take Screenshots (EFI)" { 
  echo;
}
