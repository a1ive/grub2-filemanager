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

menuentry $"Hotkeys" {
  echo;
}

menuentry $"F1 - Help" {
  echo;
}

menuentry $"F2 - File Manager" {
  echo;
}

menuentry $"F3 - OS Detect" {
  echo;
}

menuentry $"F4 - Settings" {
  echo;
}

if [ -n "${aioboot}" ];
then
  menuentry $"F5 - AIO Boot" {
    echo;
  }
elif [ -n "${ventoy}" ];
then
  menuentry $"F5 - Ventoy" {
    echo;
  }
else
  menuentry $"F5 - PXE Boot Menu" {
    echo;
  }
fi;

menuentry $"F6 - Power Off" {
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

hiddenentry "" --hotkey f1 {
  echo;
}

hiddenentry "" --hotkey f2 {
  if [ -n "${grubfm_current_path}" ];
  then
    grubfm "${grubfm_current_path}";
  else
    grubfm;
  fi;
}

hiddenentry "" --hotkey f3 {
  configfile ${prefix}/osdetect.sh;
}

hiddenentry "" --hotkey f4 {
  configfile ${prefix}/settings.sh;
}

hiddenentry "" --hotkey f5 {
  configfile ${prefix}/f5.sh;
}

hiddenentry "" --hotkey f6 {
  configfile ${prefix}/power.sh;
}
