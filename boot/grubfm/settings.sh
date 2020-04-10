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

videomode -l mode_list;
videomode -c mode_current;

menuentry $"Language" --class lang {
  lua ${prefix}/language.lua;
}

if [ "${mode_current}" != "0x0" ];
then
  menuentry $"Disable graphics mode (T)" --class ms-dos --hotkey "t" {
    set lang=en_US;
    terminal_output console;
    configfile ${prefix}/settings.sh;
  }
fi;

submenu $"Resolution (R): ${mode_current}" --class screen --hotkey "r" {
  set lang=en_US;
  terminal_output console;
  menuentry "AUTO DETECT" {
    set gfxmode=auto;
    terminal_output gfxterm;
    set lang=${grubfm_lang};
    configfile ${prefix}/settings.sh;
  }
  for item in ${mode_list};
  do
    menuentry "${item}" {
      set gfxmode=${1};
      terminal_output gfxterm;
      set lang=${grubfm_lang};
      configfile ${prefix}/settings.sh;
    }
  done;
}

if [ "${grub_fs_case_sensitive}" != "1" ];
then
  menuentry $"Enable case-sensitive filenames" --class strcase {
    export grub_fs_case_sensitive=1;
    configfile ${prefix}/settings.sh;
  }
else
  menuentry $"Disable case-sensitive filenames" --class strcase {
    unset grub_fs_case_sensitive;
    configfile ${prefix}/settings.sh;
  }
fi;

if [ "${grubfm_disable_qsort}" != "1" ];
then
  menuentry $"Do not sort files by name" --class sort {
    export grubfm_disable_qsort=1;
    configfile ${prefix}/settings.sh;
  }
else
  menuentry $"Sort files by name" --class sort {
    unset grubfm_disable_qsort;
    configfile ${prefix}/settings.sh;
  }
fi;

if grubfm_get --boot;
then
  menuentry $"Enable secondary boot options menu" --class sh {
    grubfm_set --boot 0;
    configfile ${prefix}/settings.sh;
  }
else
  menuentry $"Disable secondary boot options menu" --class sh {
    grubfm_set --boot 1;
    configfile ${prefix}/settings.sh;
  }
fi;

if grubfm_get --hide;
then
  menuentry $"Display all files" --class search {
    grubfm_set --hide 0;
    configfile ${prefix}/settings.sh;
  }
else
  menuentry $"Hide non-bootable files" --class search {
    grubfm_set --hide 1;
    configfile ${prefix}/settings.sh;
  }
fi;

menuentry $"Load AHCI Driver" --class pmagic {
  insmod ahci;
}

menuentry $"Mount encrypted volumes (LUKS and geli)" --class konboot {
  insmod luks;
  insmod geli;
  cryptomount -a;
}

menuentry $"Enable serial terminal" --class ms-dos {
  insmod serial;
  terminal_input --append serial;
  terminal_output --append serial;
}

source ${prefix}/global.sh;
